# GRE Manager 2.1

Ù…Ø¯ÛŒØ±ÛŒØª Ø³Ø¨Ú© ØªÙˆÙ†Ù„ GRE Ùˆ Port Forwarding Ù¾Ø§ÛŒØ¯Ø§Ø± Ø±ÙˆÛŒ Linux. ØªÙ†Ø¸ÛŒÙ…Ø§Øª Ùˆ Ù‚ÙˆØ§Ù†ÛŒÙ† Ø¨Ø¹Ø¯ Ø§Ø² reboot Ø¨Ù‡â€ŒÚ©Ù…Ú© systemd Ø¯ÙˆØ¨Ø§Ø±Ù‡ Ø§Ø¹Ù…Ø§Ù„ Ù…ÛŒâ€ŒØ´ÙˆÙ†Ø¯.

> [!WARNING]
> GRE ØªØ±Ø§ÙÛŒÚ© Ø±Ø§ Ø±Ù…Ø²Ù†Ú¯Ø§Ø±ÛŒ ÛŒØ§ Ø§Ø­Ø±Ø§Ø² Ù‡ÙˆÛŒØª Ù†Ù…ÛŒâ€ŒÚ©Ù†Ø¯. Ø¨Ø±Ø§ÛŒ Ø¯Ø§Ø¯Ù‡Ù” Ø­Ø³Ø§Ø³ØŒ GRE Ø±Ø§ Ø¯Ø§Ø®Ù„ IPsec/WireGuard Ø§Ø¬Ø±Ø§ Ú©Ù†ÛŒØ¯ Ùˆ Ø¯Ø³ØªØ±Ø³ÛŒ ÙˆØ±ÙˆØ¯ÛŒ GRE (Ù¾Ø±ÙˆØªÚ©Ù„ IP Ø´Ù…Ø§Ø±Ù‡Ù” 47) Ø±Ø§ ÙÙ‚Ø· Ø¨Ù‡ IP Ø·Ø±Ù Ù…Ù‚Ø§Ø¨Ù„ Ù…Ø­Ø¯ÙˆØ¯ Ú©Ù†ÛŒØ¯.

## Ù¾ÛŒØ´â€ŒÙ†ÛŒØ§Ø²Ù‡Ø§

- Linux Ø¨Ø§ systemd Ùˆ Ø¯Ø³ØªØ±Ø³ÛŒ root
- IPv4 Ø¹Ù…ÙˆÙ…ÛŒ Ø«Ø§Ø¨Øª Ø¯Ø± Ù‡Ø± Ø¯Ùˆ Ø³Ù…Øª
- Ø¨Ø§Ø² Ø¨ÙˆØ¯Ù† Ù¾Ø±ÙˆØªÚ©Ù„ GRE (IP protocol 47) Ø¯Ø± ÙØ§ÛŒØ±ÙˆØ§Ù„/Ù¾Ù†Ù„ Ø§Ø±Ø§Ø¦Ù‡â€ŒØ¯Ù‡Ù†Ø¯Ù‡
- Ø§Ø¨Ø²Ø§Ø±Ù‡Ø§ÛŒ `iproute2`ØŒ `iptables`ØŒ `kmod`ØŒ `procps` Ùˆ `ping`

## Ù†ØµØ¨ Ø¢Ø³Ø§Ù† Ø§Ø² Release

Ø¢Ø®Ø±ÛŒÙ† Ù†Ø³Ø®Ù‡ Ùˆ checksum Ø¢Ù† Ø±Ø§ Ù…Ø³ØªÙ‚ÛŒÙ… Ø¯Ø§Ù†Ù„ÙˆØ¯ Ú©Ù†ÛŒØ¯:

```bash
curl -fLO https://github.com/rizay041/gre-manager/releases/latest/download/gre-manager-linux.tar.gz
curl -fLO https://github.com/rizay041/gre-manager/releases/latest/download/gre-manager-linux.tar.gz.sha256
sha256sum -c gre-manager-linux.tar.gz.sha256
tar -xzf gre-manager-linux.tar.gz
cd gre-manager-linux
sudo ./install.sh
sudo gre-manager configure
```

Ù†ØµØ§Ø¨ ÙˆØ§Ø¨Ø³ØªÚ¯ÛŒâ€ŒÙ‡Ø§ÛŒ Ù…ÙˆØ¬ÙˆØ¯ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ù…ÛŒâ€ŒÚ©Ù†Ø¯ØŒ Ø¨Ø±Ù†Ø§Ù…Ù‡ Ø±Ø§ Ø¯Ø± `/usr/local/bin` Ù‚Ø±Ø§Ø± Ù…ÛŒâ€ŒØ¯Ù‡Ø¯ Ùˆ Ø³Ø±ÙˆÛŒØ³ Ø±Ø§ Ø¨Ø±Ø§ÛŒ boot ÙØ¹Ø§Ù„ Ù…ÛŒâ€ŒÚ©Ù†Ø¯.

## Ø±Ø§Ù‡â€ŒØ§Ù†Ø¯Ø§Ø²ÛŒ Ø¯Ùˆ Ø³Ø± ØªÙˆÙ†Ù„

Ø±ÙˆÛŒ Ø³Ø±ÙˆØ± A:

```text
Local public IPv4: 203.0.113.10
Remote public IPv4: 198.51.100.20
Local tunnel IPv4: 10.10.10.1
Remote tunnel IPv4: 10.10.10.2
Tunnel prefix: 30
MTU: 1400
```

Ø±ÙˆÛŒ Ø³Ø±ÙˆØ± B Ù…Ù‚Ø§Ø¯ÛŒØ± local Ùˆ remote Ø±Ø§ Ø¨Ø±Ø¹Ú©Ø³ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯. Ø¢Ø¯Ø±Ø³â€ŒÙ‡Ø§ÛŒ Ù†Ù…ÙˆÙ†Ù‡Ù” Ø¨Ø§Ù„Ø§ Ù…Ø³ØªÙ†Ø¯Ø§ØªÛŒâ€ŒØ§Ù†Ø¯Ø› IPÙ‡Ø§ÛŒ ÙˆØ§Ù‚Ø¹ÛŒ Ø®ÙˆØ¯ØªØ§Ù† Ø±Ø§ Ø¬Ø§ÛŒÚ¯Ø²ÛŒÙ† Ú©Ù†ÛŒØ¯.

## Ø§Ø³ØªÙØ§Ø¯Ù‡

```bash
sudo gre-manager menu                 # Ù…Ù†ÙˆÛŒ ØªØ¹Ø§Ù…Ù„ÛŒ
sudo gre-manager status               # ÙˆØ¶Ø¹ÛŒØª Ùˆ ØªØ³Øª Ø¯Ø³ØªØ±Ø³ÛŒ Ø·Ø±Ù Ù…Ù‚Ø§Ø¨Ù„
sudo gre-manager add-rule tcp 443 8443 # Ù¾ÙˆØ±Øª 443 Ø¹Ù…ÙˆÙ…ÛŒ Ø¨Ù‡ 8443 Ø³Ù…Øª Ù…Ù‚Ø§Ø¨Ù„
sudo gre-manager list-rules
sudo gre-manager restart
sudo gre-manager clear-rules
gre-manager help
```

Ù‚ÙˆØ§Ù†ÛŒÙ† Ø¯Ø± `/etc/gre-manager/rules.conf` Ùˆ ØªÙ†Ø¸ÛŒÙ…Ø§Øª Ø¯Ø± `/etc/gre-manager/config.conf` Ø¨Ø§ Ø¯Ø³ØªØ±Ø³ÛŒ ÙÙ‚Ø· root Ø°Ø®ÛŒØ±Ù‡ Ù…ÛŒâ€ŒØ´ÙˆÙ†Ø¯.

## Ø¹ÛŒØ¨â€ŒÛŒØ§Ø¨ÛŒ

```bash
sudo systemctl status gre-manager
sudo journalctl -u gre-manager -b
ip tunnel show
sudo iptables -t nat -S GRE_MANAGER_NAT
```

- Ø§Ú¯Ø± ping ØªÙˆÙ†Ù„ Ø¬ÙˆØ§Ø¨ Ù†Ù…ÛŒâ€ŒØ¯Ù‡Ø¯ØŒ protocol 47ØŒ IPÙ‡Ø§ÛŒ Ø¹Ù…ÙˆÙ…ÛŒ Ùˆ route Ø§Ø±Ø§Ø¦Ù‡â€ŒØ¯Ù‡Ù†Ø¯Ù‡ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯.
- Ø§Ú¯Ø± Ø¨Ø³ØªÙ‡â€ŒÙ‡Ø§ Ø¹Ø¨ÙˆØ± Ù†Ù…ÛŒâ€ŒÚ©Ù†Ù†Ø¯ØŒ ÙØ§ÛŒØ±ÙˆØ§Ù„ Ø¯ÛŒÚ¯Ø±ÛŒ Ù…Ø«Ù„ UFW/firewalld Ùˆ Ø³ÛŒØ§Ø³Øª FORWARD Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯.
- Ø§Ú¯Ø± Ø´Ø¨Ú©Ù‡Ù” Ù…Ø³ÛŒØ± MTU Ù¾Ø§ÛŒÛŒÙ†â€ŒØªØ±ÛŒ Ø¯Ø§Ø±Ø¯ØŒ MTU Ø±Ø§ Ù‡Ù†Ú¯Ø§Ù… `configure` Ú©Ø§Ù‡Ø´ Ø¯Ù‡ÛŒØ¯ (Ù…Ø«Ù„Ø§Ù‹ 1380).

## Ø­Ø°Ù

```bash
sudo ./uninstall.sh          # Ù†Ú¯Ù‡â€ŒØ¯Ø§Ø´ØªÙ† ØªÙ†Ø¸ÛŒÙ…Ø§Øª
sudo ./uninstall.sh --purge  # Ø­Ø°Ù Ú©Ø§Ù…Ù„ ØªÙ†Ø¸ÛŒÙ…Ø§Øª
```

## Ù¾Ø´ØªÛŒØ¨Ø§Ù†ÛŒ

ØªÙˆØ²ÛŒØ¹â€ŒÙ‡Ø§ÛŒ Debian/Ubuntu Ùˆ RHEL/Fedora Ø¨Ø§ systemd Ù‡Ø¯Ù Ø§ØµÙ„ÛŒ Ù‡Ø³ØªÙ†Ø¯. Ø§ÛŒÙ† Ø§Ø¨Ø²Ø§Ø± ÙÙ‚Ø· IPv4 Ùˆ iptables Ø±Ø§ Ù¾Ø´ØªÛŒØ¨Ø§Ù†ÛŒ Ù…ÛŒâ€ŒÚ©Ù†Ø¯.

Ù…Ø¬ÙˆØ²: [MIT](LICENSE)

