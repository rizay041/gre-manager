# RIZAY GRE Manager v3.0.0

```text
......   .....  ......   ...   ..    ..
..   ..    ..      ..   .. ..   ..  ..
......     ..     ..    .......    ..
..  ..     ..    ..     ..   ..    ..
..   ..  .....  ......  ..   ..    ..
```

Salam refigh! In abzar barat beyn server `IRAN` va server `KHAREJ` tunnel GRE misaze. User be IP server IRAN vasl mishe va port-ha az IRAN be service asli roye KHAREJ forward mishan.

## Nasb ba faghat yek khat

Hamin yek khat ro roye har do server bezan:

```bash
curl -fsSL https://raw.githubusercontent.com/rizay041/gre-manager/main/quick-install.sh | sudo bash
```

Tamam! Script khodesh akharin release ro download mikone, SHA256 ro check mikone, dependency-ha ro nasb mikone va Wizard graphic ro baz mikone.

## Wizard chejori kar mikone?

Aval role in server ro entekhab mikoni:

- `IRAN`: server voroodi va mabda port-forward.
- `KHAREJ`: server maghsad ke service asli roosh ejra mishe.

Bad faghat in chizha ro mide:

| Field | Chi vared konam? |
|---|---|
| `IRAN public IPv4` | IP asli server IRAN |
| `KHAREJ public IPv4` | IP asli server KHAREJ |
| `MTU` | Mamoolan `1400` aliye |

GRE IP-ha khodkar set mishan:

- IRAN: `10.77.0.1/30`
- KHAREJ: `10.77.0.2/30`

Pas dige IP local va remote ro eshtebah nemizani. Wizard ro roye har do server ejra kon; faghat role ro dorost entekhab kon.

## Port Forward

Port-forward faghat roye server `IRAN` sakhte mishe. Mesalan port `443` IRAN bere roye port `8443` KHAREJ:

```bash
sudo gre-manager add-rule tcp 443 8443
```

Baraye UDP faghat `tcp` ro be `udp` tabdil kon.

## Packet Loss va Tunnel Score

In dastoor 50 packet roye masir Public va 50 packet dakhele GRE test mikone:

```bash
sudo gre-manager health
```

Natije in chizha ro neshon mide:

- Public path packet loss
- GRE path packet loss
- Average RTT
- UP/DOWN boodan interface
- ON/OFF boodan IPv4 forwarding
- Estimated readiness score az `0%` ta `100%`

Score yek emtiaz tashkhisiye, na ehtemal amari ya guarantee. Momkene ICMP ro firewall block karde bashe vali service kar kone. Baraye natije vaghei, `health` ro roye har do server IRAN va KHAREJ ejra kon.

Sample bishtar mikhay? Adad beyn 5 ta 200 bede:

```bash
sudo gre-manager health 100
```

## Dashboard Graphic

```bash
sudo gre-manager menu
```

Az dakhele menu mitooni Setup, Health, Port Forward, Status, Restart va Clear Rules ro anjam bedi.

## Dastoor-haye mofid

```bash
sudo gre-manager status
sudo gre-manager list-rules
sudo gre-manager restart
sudo gre-manager clear-rules
```

Config va rule-ha bad az reboot ham mimoonan va systemd tunnel ro khodkar bala miavare.

## Agar tunnel bala nayoomad

1. `IP Protocol 47` bayad beyn IP server IRAN va KHAREJ baz bashe.
2. IP-ha ro dobare check kon.
3. UFW, firewalld va policy chain `FORWARD` ro check kon.
4. `sudo gre-manager health 100` ro roye har do server ejra kon.
5. Log-ha ro ba dastoor-haye zir check kon.

```bash
sudo systemctl status gre-manager
sudo journalctl -u gre-manager -b
```

## Security

GRE encryption nadare. Baraye data hassas, GRE ro dakhele IPsec ya WireGuard estefade kon va Protocol 47 ro faghat baraye IP server moghabel baz bezar.

## Ertebat

Soal ya pishnahad dashti Issue baz kon ya Instagram message bede:

[Instagram @rizay_041](https://www.instagram.com/rizay_041/)

Made with care by RIZAY. License: [MIT](LICENSE)
