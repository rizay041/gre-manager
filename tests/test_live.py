#!/usr/bin/env python3
"""Exercise production GRE/SIT setup and official GOST v2 in isolated namespaces."""
import os
from pathlib import Path
import select
import socket
import subprocess
import sys
import tempfile
import threading
import time

ROOT = Path(__file__).resolve().parents[1]
MARKER = b"rizay-live-tcp-udp-test"


def echo_server():
    def tcp():
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
            server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            server.bind(("0.0.0.0", 18080))
            server.listen()
            while True:
                connection, _ = server.accept()
                with connection:
                    connection.sendall(connection.recv(4096))

    def udp():
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as server:
            server.bind(("0.0.0.0", 18081))
            while True:
                data, address = server.recvfrom(4096)
                server.sendto(data, address)

    threading.Thread(target=tcp, daemon=True).start()
    threading.Thread(target=udp, daemon=True).start()
    print("READY", flush=True)
    threading.Event().wait()


def client():
    deadline = time.monotonic() + 6
    while True:
        try:
            with socket.create_connection(("127.0.0.1", 19080), timeout=2) as tcp:
                tcp.sendall(MARKER)
                assert tcp.recv(4096) == MARKER, "TCP payload changed"
            break
        except OSError:
            if time.monotonic() >= deadline:
                raise
            time.sleep(0.2)
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as udp:
        udp.settimeout(4)
        udp.sendto(MARKER, ("127.0.0.1", 19081))
        data, _ = udp.recvfrom(4096)
        assert data == MARKER, "UDP payload changed"


def run(*args, env=None):
    result = subprocess.run(args, env=env, text=True, capture_output=True, timeout=90)
    if result.returncode:
        raise RuntimeError(f"{' '.join(map(str, args))}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def terminate(process):
    if process is None or process.poll() is not None:
        return
    process.terminate()
    try:
        process.wait(timeout=3)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait(timeout=3)


def main():
    if sys.platform != "linux" or os.geteuid() != 0:
        raise RuntimeError("Live tests require Linux root and network namespaces")
    iran = f"rizay-test-{os.getpid()}-iran"
    kharej = f"rizay-test-{os.getpid()}-kharej"
    veth_i, veth_k = f"rzi{os.getpid()}", f"rzk{os.getpid()}"
    namespaces = []
    server = gost = relay = None
    with tempfile.TemporaryDirectory(prefix="rizay-live-") as directory:
        work = Path(directory)
        binary = work / "bin" / "gost"
        environments = {}
        try:
            for role, ns, local_ip in (("iran", iran, "192.0.2.1"), ("kharej", kharej, "192.0.2.2")):
                config = work / role
                config.mkdir()
                (config / "config.conf").write_text(
                    f"ROLE={role}\nMODE=hybrid\nIRAN_IP=192.0.2.1\nKHAREJ_IP=192.0.2.2\n"
                    "MTU=1400\nPRIVATE_ENABLED=yes\nPRIVATE_COUNT=2\n", encoding="ascii"
                )
                env = dict(os.environ, GRE_MANAGER_CONFIG_DIR=str(config),
                           GRE_MANAGER_GOST_BIN=str(binary), GRE_MANAGER_LOCK_FILE=str(work / f"{role}.lock"))
                environments[role] = env
                run("ip", "netns", "add", ns)
                namespaces.append(ns)
                run("ip", "-n", ns, "link", "set", "lo", "up")
            run("ip", "link", "add", veth_i, "type", "veth", "peer", "name", veth_k)
            for ns, device, address in ((iran, veth_i, "192.0.2.1/30"), (kharej, veth_k, "192.0.2.2/30")):
                run("ip", "link", "set", device, "netns", ns)
                run("ip", "-n", ns, "address", "add", address, "dev", device)
                run("ip", "-n", ns, "link", "set", device, "up")
                run("ip", "-n", ns, "route", "add", "default", "dev", device)
            for role, ns in (("iran", iran), ("kharej", kharej)):
                for command in ("start-gre", "start-private", "start-private"):
                    run("ip", "netns", "exec", ns, "bash", str(ROOT / "gre-manager"), command, env=environments[role])
            run("ip", "netns", "exec", iran, "ping", "-n", "-c", "2", "-W", "2", "10.77.0.2")
            print("PASS: real GRE path", flush=True)
            for ns, peer in ((iran, "fd1d:fc98:b73e:b481::1"),
                             (kharej, "fd1d:fc98:b73e:b481::2"),
                             (iran, "fd1d:fc98:b73e:b482::1")):
                run("ip", "netns", "exec", ns, "ping", "-6", "-n", "-c", "2", "-W", "2", peer)
            print("PASS: real bidirectional SIT IPv6, extra pair and repeat setup", flush=True)
            run("bash", "-c", 'source "$1"; install_gost_binary', "_", str(ROOT / "gre-manager"), env=environments["iran"])
            version = run(str(binary), "-V").strip()
            assert version.startswith("gost 2.12.0 "), version
            print(f"PASS: verified official {version}", flush=True)
            run("bash", "-c", 'source "$1"; load_config; write_gost_config', "_", str(ROOT / "gre-manager"), env=environments["kharej"])
            relay_log = (work / "relay.log").open("w")
            relay = subprocess.Popen(["ip", "netns", "exec", kharej, str(binary), "-C", str(work / "kharej" / "gost.json")],
                                     stdout=relay_log, stderr=subprocess.STDOUT)
            server = subprocess.Popen(["ip", "netns", "exec", kharej, sys.executable, str(Path(__file__).resolve()), "--echo"],
                                      stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            if not select.select([server.stdout], [], [], 5)[0] or server.stdout.readline().strip() != "READY":
                raise RuntimeError("Echo service did not start")
            for transport in ("public", "gre", "private"):
                config = work / "iran"
                (config / "gost-rules.conf").write_text(
                    f"tcp 19080 18080 {transport}\nudp 19081 18081 {transport}\n", encoding="ascii"
                )
                run("bash", "-c", 'source "$1"; load_config; write_gost_config', "_", str(ROOT / "gre-manager"), env=environments["iran"])
                with (work / f"gost-{transport}.log").open("w") as log:
                    gost = subprocess.Popen(["ip", "netns", "exec", iran, str(binary), "-C", str(config / "gost.json")],
                                            stdout=log, stderr=subprocess.STDOUT)
                    try:
                        run("ip", "netns", "exec", iran, sys.executable, str(Path(__file__).resolve()), "--client")
                    except Exception:
                        print((work / f"gost-{transport}.log").read_text(), file=sys.stderr)
                        raise
                    finally:
                        terminate(gost)
                print(f"PASS: real GOST v2 TCP + UDP over {transport.upper()} to IPv4-only services", flush=True)
        finally:
            terminate(gost)
            terminate(server)
            terminate(relay)
            for ns in reversed(namespaces):
                subprocess.run(["ip", "netns", "delete", ns], check=False, capture_output=True)
            for device in (veth_i, veth_k):
                subprocess.run(["ip", "link", "delete", device], check=False, capture_output=True)


if __name__ == "__main__":
    if "--echo" in sys.argv:
        echo_server()
    elif "--client" in sys.argv:
        client()
    else:
        main()
