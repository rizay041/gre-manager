# GRE Manager 2.1

مدیریت سبک تونل GRE و Port Forwarding پایدار روی Linux. تنظیمات و قوانین بعد از reboot به‌کمک systemd دوباره اعمال می‌شوند.

> [!WARNING]
> GRE ترافیک را رمزنگاری یا احراز هویت نمی‌کند. برای دادهٔ حساس، GRE را داخل IPsec/WireGuard اجرا کنید و دسترسی ورودی GRE (پروتکل IP شمارهٔ 47) را فقط به IP طرف مقابل محدود کنید.

## پیش‌نیازها

- Linux با systemd و دسترسی root
- IPv4 عمومی ثابت در هر دو سمت
- باز بودن پروتکل GRE (IP protocol 47) در فایروال/پنل ارائه‌دهنده
- ابزارهای `iproute2`، `iptables`، `kmod`، `procps` و `ping`

## نصب آسان از Release

از بخش **Releases** فایل `gre-manager-linux.tar.gz` را دانلود کنید، سپس:

```bash
tar -xzf gre-manager-linux.tar.gz
cd gre-manager-linux
sudo ./install.sh
sudo gre-manager configure
```

نصاب وابستگی‌های موجود را بررسی می‌کند، برنامه را در `/usr/local/bin` قرار می‌دهد و سرویس را برای boot فعال می‌کند.

## راه‌اندازی دو سر تونل

روی سرور A:

```text
Local public IPv4: 203.0.113.10
Remote public IPv4: 198.51.100.20
Local tunnel IPv4: 10.10.10.1
Remote tunnel IPv4: 10.10.10.2
Tunnel prefix: 30
MTU: 1400
```

روی سرور B مقادیر local و remote را برعکس وارد کنید. آدرس‌های نمونهٔ بالا مستنداتی‌اند؛ IPهای واقعی خودتان را جایگزین کنید.

## استفاده

```bash
sudo gre-manager menu                 # منوی تعاملی
sudo gre-manager status               # وضعیت و تست دسترسی طرف مقابل
sudo gre-manager add-rule tcp 443 8443 # پورت 443 عمومی به 8443 سمت مقابل
sudo gre-manager list-rules
sudo gre-manager restart
sudo gre-manager clear-rules
gre-manager help
```

قوانین در `/etc/gre-manager/rules.conf` و تنظیمات در `/etc/gre-manager/config.conf` با دسترسی فقط root ذخیره می‌شوند.

## عیب‌یابی

```bash
sudo systemctl status gre-manager
sudo journalctl -u gre-manager -b
ip tunnel show
sudo iptables -t nat -S GRE_MANAGER_NAT
```

- اگر ping تونل جواب نمی‌دهد، protocol 47، IPهای عمومی و route ارائه‌دهنده را بررسی کنید.
- اگر بسته‌ها عبور نمی‌کنند، فایروال دیگری مثل UFW/firewalld و سیاست FORWARD را بررسی کنید.
- اگر شبکهٔ مسیر MTU پایین‌تری دارد، MTU را هنگام `configure` کاهش دهید (مثلاً 1380).

## حذف

```bash
sudo ./uninstall.sh          # نگه‌داشتن تنظیمات
sudo ./uninstall.sh --purge  # حذف کامل تنظیمات
```

## پشتیبانی

توزیع‌های Debian/Ubuntu و RHEL/Fedora با systemd هدف اصلی هستند. این ابزار فقط IPv4 و iptables را پشتیبانی می‌کند.

مجوز: [MIT](LICENSE)
