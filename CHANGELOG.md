# Changelog

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
