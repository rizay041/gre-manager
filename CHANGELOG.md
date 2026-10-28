# Changelog

## 6.1.4 - 2026-10-28

- Make standalone `uninstall.sh` independent from the installed binary and safe with broken profiles.
- Remove RIZAY iptables chains and tunnel interfaces during purge, even if configuration validation fails.
- Preserve `/etc/gre-manager` when using `--keep-config` from the standalone remover.

## 6.1.3 - 2026-10-28

- Allow `REMOVE RIZAY completely` and `uninstall --purge` to finish even when the saved profile has an invalid or empty role.
- Stop services and remove all RIZAY files without validating a broken configuration first.

## 6.1.2 - 2026-10-28

- Prevent incomplete old settings from crashing the installer or live dashboard with `role must be IRAN or KHAREJ`.
- Detect invalid saved profiles, keep a timestamped backup, and return users to the numbered IRAN/KHAREJ setup.
- Add regression coverage for invalid saved roles.

## 6.1.1 - 2026-10-28

- Make `uninstall.sh` fall back to direct cleanup when an older installed binary has no uninstall command.
- Document the explicit `--purge` uninstall mode in the command help.

## 6.1.0 - 2026-10-28

- Add a live colored dashboard with GRE, PRIVATE IPv6, GOST and rule cards.
- Add `REMOVE RIZAY completely` to the main numbered menu.
- Add `gre-manager uninstall` and `gre-manager uninstall --keep-config`.
- Make `uninstall.sh` purge by default and delegate to the installed remover.
- Stop and remove all tunnels, services, timers, unit links, binaries and sysctl state during removal.

## 6.0.0 - 2026-10-14

- Switch to checksum-verified official GOST v2.12.0 with native ServeNodes JSON configuration.
- Upgrade existing GOST v3 YAML and binary automatically, retaining saved ports and backups.
- Add automatic private IPv6 over IPv4 (SIT) with the same address scheme as Azumi67's PrivateIP script.
- Add persistent private IPv6 systemd setup and a once-per-minute peer keepalive timer.
- Add PRIVATE IPv6 forwarding as the recommended numbered setup choice.
- Add an advanced private IPv6 menu supporting 1-15 address pairs without duplicate subnets.
- Extend Health, Doctor and JSON status with private IPv6 state and loss measurement.
- Keep IRAN/KHAREJ role selection and comma-separated port setup simple.
- Add real Linux namespace tests for GRE, SIT and GOST v2 TCP/UDP on all three forwarding paths.

## 5.1.0 - 2026-10-13

- Make the main panel numbered: 1) IRAN, 2) KHAREJ, followed by IPs and ports.
- Configure all comma-separated ports during setup, with TCP, UDP or both.
- Start GRE and selected forwarding services automatically after one confirmation.
- Add a menu-driven batch port editor with ordered destination mappings.
- Preserve unrelated rules and migrate selected ports between GRE and GOST.
- Validate complete port lists before saving; reject empty, duplicate or invalid ports.
- Release mutation locks before restarting GRE and between panel actions.
- Add simulated user-flow tests for setup, cancellation, retries and rule migration.
- Rewrite the bilingual guide around the numbered installation flow.

## 5.0.1 - 2026-10-13

- Align the terminal and SVG branding with the new RIZAY Tunnel Manager name.

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
