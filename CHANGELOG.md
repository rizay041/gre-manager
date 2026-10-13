# Changelog

## 5.0.0 - 2026-10-13

- Add HYBRID mode with GRE and verified official GOST 3.3.0 forwarding.
- Add separate persistent GOST rules over the public path or inside GRE.
- Add SHA256-verified multi-architecture GOST installation without overwriting a system GOST binary.
- Replace the flat menu with Tunnel, Port, Health, and Maintenance centers.
- Add GOST service status, logs, rule removal, rebuild, and Doctor checks.
- Add an opt-in safe network profile with FQ, MTU probing, and feature-detected BBR.
- Add a hardened standalone systemd service for the GOST engine.
- Preserve the one-line installer and bilingual usage guide.

## 4.0.0 - 2026-10-13

- Add Doctor preflight checks for commands, kernel GRE, routes, permissions, service, firewall, and saved rules.
- Add safe single-rule removal with an automatic firewall rebuild.
- Add live iptables packet and byte counters.
- Add a Repair workflow that rebuilds the tunnel and rules before diagnostics.
- Add JSON status output for monitoring and automation.
- Add optional TCP service probing plus jitter to network Health reports.
- Serialize network mutations with a process lock and wait for the xtables lock.
- Make rule-file updates atomic and remove every stale duplicate firewall jump.
- Back up the previous installed binary during upgrades.
- Harden the systemd service and add automated core behavior tests.

## 3.0.1 - 2026-10-03

- Redesign the RIZAY terminal logo as a large nine-row high-density dot matrix.
- Add bright-blue ANSI branding, a dotted frame, and centered version text.
- Apply a consistent blue theme to every Whiptail wizard and dashboard window.
- Add a blue dotted RIZAY SVG logo for GitHub and release documentation.

## 3.0.0 - 2026-10-03

- Add a graphical terminal wizard with a large dotted RIZAY banner.
- Add explicit IRAN gateway and KHAREJ destination roles.
- Restrict port-forward creation to the IRAN gateway.
- Add 50-sample Public/GRE packet-loss, RTT, and readiness diagnostics.
- Add a graphical management dashboard and port-forward forms.
- Install Whiptail automatically while keeping a plain-terminal fallback.
- Use Latin-only IRAN/KHAREJ labels across the app and documentation.

## 2.1.1 - 2026-09-27

- Add a true one-line installer that downloads, verifies, installs, and starts configuration.
- Install required system packages automatically on Debian, Ubuntu, RHEL, and Fedora.
- Rewrite the Persian guide with friendlier explanations and direct support contact.

## 2.1.0 - 2026-09-27

- Validate every IP address, prefix, port, protocol, and MTU.
- Parse configuration as data instead of executing it as shell code.
- Persist and restore port-forward rules after reboot.
- Make firewall and tunnel operations idempotent.
- Add CLI help, status, rule listing, restart, and safe uninstall commands.
- Add hardened file permissions, systemd integration, documentation, and CI.
