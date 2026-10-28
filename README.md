![RIZAY Tunnel Manager](assets/rizay-logo.svg)

# RIZAY Tunnel Manager v6.1.3

نصب مرحله‌به‌مرحله GRE، IPv6 خصوصی و GOST نسخه ۲ بین `IRAN` و `KHAREJ`؛ با پنل عددی آبی و پورت‌های جداشده با `,`.

## راهنمای فارسی

### فقط یک‌بار این دستور را روی هر سرور بزن

```bash
curl -fsSL https://raw.githubusercontent.com/rizay041/gre-manager/main/quick-install.sh | sudo bash
```

نصاب برنامه را دانلود و checksum را بررسی می‌کند، پیش‌نیازها را نصب می‌کند و این پنل را باز می‌کند:

```text
1) IRAN - setup IPs and comma-separated ports
2) KHAREJ - setup the destination server
3) Add or change ports
4) Status and saved ports
5) Health Center - packet loss and Doctor
6) Port Manager
7) Tunnel Center - start / stop / restart
8) Maintenance and optimization
9) About RIZAY / @rizay_041
10) PRIVATE IPv6 - status / repair / extra addresses
11) REMOVE RIZAY completely
0) Exit
```

### اول روی سرور KHAREJ

1. عدد `2` را بزن.
2. IP عمومی سرور `IRAN` را وارد کن.
3. IP عمومی همین سرور `KHAREJ` را وارد کن.
4. مشخصات را ببین و با عدد `1` نصب را تأیید کن.

تمام! GRE، IPv6 خصوصی و GOST نسخه ۲ روی مقصد راه می‌افتند. پورت‌ها را در مرحله بعد روی سرور ایران تعیین می‌کنی؛ سرویس اصلی باید روی پورت موردنظر سرور خارج در حال اجرا باشد.

### بعد روی سرور IRAN

1. عدد `1` را بزن.
2. IP عمومی `IRAN` را وارد کن.
3. IP عمومی `KHAREJ` را وارد کن؛ همان IPهایی که در سمت مقابل دادی.
4. پورت‌ها را یک‌جا و با کامای انگلیسی بنویس؛ مثلاً `443,8443,2053`.
5. پروتکل را انتخاب کن: `1` برای TCP، `2` برای UDP، `3` برای هر دو.
6. برای نصب ساده، روش `1` یعنی `GOST v2 + PRIVATE IPv6` را انتخاب کن. روش `2` برای GOST داخل GRE، `3` برای GRE و iptables و `4` برای GOST مستقیم روی IPv4 است.
7. خلاصه را بررسی کن و با عدد `1` تأیید کن.

همه پورت‌ها خودکار ذخیره و فعال می‌شوند. لازم نیست برای هر پورت دستور جداگانه بنویسی. در نصب اولیه، شماره پورت ایران و خارج یکسان است؛ مثلاً `443` ایران به `443` خارج می‌رود. GRE و IPv6 خصوصی هم روی هر دو سرور ساخته می‌شوند؛ رسیدن به سرور مقابل را از گزینه `5` بررسی کن.

### IPv6 خصوصی خودش ساخته می‌شود

نیازی به IPv6 عمومی یا واردکردن آدرس‌های پیچیده نداری؛ همان دو IPv4 عمومی کافی است. روش SIT و آدرس‌ها مطابق [اسکریپت PrivateIP](https://github.com/Azumi67/PrivateIP_TCP-UDP_Tunnel) هستند:

- `IRAN`: `fd1d:fc98:b73e:b481::2/64`
- `KHAREJ`: `fd1d:fc98:b73e:b481::1/64`

آدرس‌ها بعد از ریبوت برمی‌گردند و keepalive هر دقیقه اجرا می‌شود. یک جفت آدرس برای استفاده عادی کافی است؛ اگر لازم داشتی، از گزینه `10` تعداد را تا ۱۵ جفت افزایش بده و همان تعداد را روی هر دو سرور انتخاب کن.

GOST روی مسیر خصوصی به‌صورت دوطرفه تنظیم می‌شود تا سرویس‌های IPv4 خارج هم کار کنند. نیازی به تغییر تنظیمات سرویس اصلی به IPv6 نیست؛ سرویس خارج باید روی IPv4 لوکال یا `0.0.0.0` گوش بدهد.

### اگر نسخه قبلی را نصب داری

همان دستور نصب یک‌خطی را دوباره اجرا کن. GOST به نسخه رسمی `2.12.0` تغییر می‌کند، قوانین قبلی حفظ می‌شوند و تنظیمات قدیمی backup می‌شوند. برای فعال‌کردن مسیر IPv6 خصوصی، نصب `KHAREJ` و سپس `IRAN` را از پنل انجام بده و روش `1` را انتخاب کن.

### پورت بیشتری می‌خوای؟

هر وقت خواستی پنل را باز کن:

```bash
sudo gre-manager
```

روی `IRAN` گزینه `3` را انتخاب کن و پورت‌ها را با `,` وارد کن. برای پورت‌های `KHAREJ` فقط Enter بزن تا همان شماره‌ها استفاده شوند؛ یا یک لیست هم‌تعداد به‌ترتیب وارد کن. مثال: `443,2053` در ایران و `8443,8080` در خارج یعنی انتقال `443 → 8443` و `2053 → 8080`.

پورت‌های دیگر حفظ می‌شوند. اگر پورت انتخابی قبلاً تنظیم شده باشد، همان Rule به‌روزرسانی می‌شود. هر پروتکل/پورت هم‌زمان به یک موتور تعلق دارد؛ تغییر روش انتقال، Rule همان پورت را بین GOST و GRE جابه‌جا می‌کند.

### بررسی وضعیت و کیفیت

- گزینه `4`: وضعیت سرویس‌ها و لیست پورت‌ها.
- گزینه `5`: Packet Loss، RTT، Jitter، تست TCP و Doctor.
- گزینه `6`: حذف یا مدیریت پورت‌ها.
- گزینه `7`: Start، Stop و Restart.
- گزینه `8`: Repair و بهینه‌سازی اختیاری شبکه.
- گزینه `10`: وضعیت، تعمیر و آدرس‌های IPv6 خصوصی.
- گزینه `11`: حذف کامل RIZAY، سرویس‌ها، تونل‌ها، باینری و تنظیمات.

برای حذف کامل از داخل پنل عدد `11` را بزن. اگر فقط برنامه را می‌خواهی حذف کنی و تنظیمات برای نصب بعدی بماند، از دستور زیر استفاده کن:

```bash
sudo gre-manager uninstall --keep-config
```

حذف کامل مستقیم:

```bash
sudo gre-manager uninstall --purge
```

امتیاز آمادگی یک گزارش تشخیصی است. برای مقایسه دوطرفه، Health را روی هر دو سرور اجرا کن. تنظیمات پیش‌فرض GRE: `10.77.0.1/30` در ایران، `10.77.0.2/30` در خارج و MTU برابر `1400`.

GOST رسمی v2.12.0 با checksum نصب می‌شود. در Firewall سرور و پنل دیتاسنتر، پروتکل `41` برای SIT و `47` برای GRE را فقط بین دو IP مجاز کن. ICMPv6 و ترافیک Relay روی TCP/6080 را داخل رابط خصوصی مجاز کن؛ این پورت روی IP عمومی گوش نمی‌دهد. پورت‌های کاربران را هم روی سرور ایران باز بگذار. IPv6 خصوصی، GRE و Relay به‌خودی‌خود رمزنگاری ندارند.

---

## English guide

Run the one-line installer above on both Linux/systemd servers. The numbered panel handles the entire setup; no per-port commands are needed.

1. On the destination, choose `2) KHAREJ`, enter both public IPv4 addresses, and confirm with `1`.
2. On the gateway, choose `1) IRAN`, enter the same IPs, and enter ports such as `443,8443,2053`.
3. Choose TCP, UDP, or both. Select forwarding option `1` for GOST v2 over private IPv6; options `2`, `3`, and `4` provide GOST over GRE, GRE/iptables, and direct public IPv4.
4. Review the summary and confirm with `1`. GRE, private IPv6, and the selected forwarding ports start automatically.

Use `sudo gre-manager` to reopen the panel. Option `3` adds or updates comma-separated ports, with optional matching destination ports. Other rules are preserved. Cancelling setup applies no changes.

Every panel screen starts with the colored `RIZAY LIVE DASHBOARD`: it shows real GRE, PRIVATE IPv6 and GOST v2 state, public/private paths, saved rule counts and a ready score. Choose `11) REMOVE RIZAY completely` to stop and remove the tunnels, services, timers, binaries and firewall state. For a reinstall that keeps settings, use `sudo gre-manager uninstall --keep-config`; for a clean wipe, use `sudo gre-manager uninstall --purge` or `sudo ./uninstall.sh`.

Private IPv6 is built automatically using SIT over the public IPv4 endpoints. The address scheme matches the PrivateIP reference: IRAN `fd1d:fc98:b73e:b481::2`, KHAREJ `fd1d:fc98:b73e:b481::1`. Allow IPv4 Protocol 41 between the endpoints. No native public IPv6 is required.

GOST v2.12.0 is installed with checksum verification. The private path uses a relay bound to KHAREJ's private IPv6 address and forwards to its IPv4 local services, so IPv4-only backends work. Existing v3 rules migrate to v2 JSON during upgrades. Option `10` manages private addresses and keepalive. Use the same address-pair count on both servers.

## ارتباط / Contact

[Instagram @rizay_041](https://www.instagram.com/rizay_041/) · [GitHub @rizay041](https://github.com/rizay041)

Numbered setup inspired by [Gost-ip6](https://github.com/masoudgb/Gost-ip6); SIT private IPv6 design inspired by [Azumi67 PrivateIP](https://github.com/Azumi67/PrivateIP_TCP-UDP_Tunnel). Independently implemented for RIZAY. License: [MIT](LICENSE).
