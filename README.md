![RIZAY Tunnel Manager](assets/rizay-logo.svg)

# RIZAY Tunnel Manager v5.0.1

پنل حرفه‌ای و سبک برای ساخت تونل بین سرورهای `IRAN` و `KHAREJ` با دو موتور `GRE` و `GOST`.

## راهنمای فارسی

### نصب با فقط یک خط

این دستور را روی هر دو سرور اجرا کن:

```bash
curl -fsSL https://raw.githubusercontent.com/rizay041/gre-manager/main/quick-install.sh | sudo bash
```

نصاب آخرین Release را دانلود می‌کند، امضای `SHA256` آن را بررسی می‌کند، پیش‌نیازها را نصب می‌کند و پنل آبی `RIZAY` را باز می‌کند.

### داخل نصب‌کننده چه انتخاب کنم؟

روی هر دو سرور حالت پیشنهادی `HYBRID` را انتخاب کن:

- سروری که کاربر به آن وصل می‌شود: `IRAN`
- سروری که سرویس اصلی روی آن است: `KHAREJ`
- در هر دو سرور، Public IPv4 هر دو سمت را یکسان وارد کن.
- مقدار پیشنهادی `MTU` برابر `1400` است.

GRE به‌صورت خودکار این IPها را می‌سازد:

- `IRAN`: `10.77.0.1/30`
- `KHAREJ`: `10.77.0.2/30`

در حالت `HYBRID`، GRE روی هر دو سرور اجرا می‌شود. سرویس GOST فقط روی `IRAN` لازم است و ترافیک پورت انتخابی را به `KHAREJ` می‌فرستد.

### پنل گرافیکی

هر وقت خواستی پنل را دوباره باز کنی:

```bash
sudo gre-manager
```

بخش‌های پنل:

- `Tunnel Center`: نصب و کنترل GRE و GOST
- `Port Manager`: اضافه، حذف و نمایش پورت‌ها
- `Health Center`: Packet Loss، RTT، Jitter، سرویس‌تست و Doctor
- `Live Dashboard`: وضعیت زنده هر دو موتور
- `Maintenance`: تعمیر خودکار و بهینه‌سازی امن شبکه

### انتقال پورت با GOST

ساده‌ترین حالت، انتقال مستقیم پورت `443` سرور `IRAN` به پورت `8443` سرور `KHAREJ` است:

```bash
sudo gre-manager add-gost tcp 443 8443 public
```

اگر می‌خواهی GOST ترافیک را داخل GRE عبور دهد:

```bash
sudo gre-manager add-gost tcp 443 8443 gre
```

برای UDP، به‌جای `tcp` بنویس `udp`. باینری رسمی GOST v3.3.0 با اولین Rule دانلود می‌شود و checksum رسمی آن قبل از نصب بررسی خواهد شد. این باینری جدا از GOST احتمالی خود سیستم نگهداری می‌شود.

### انتقال پورت با GRE و iptables

این دستور را فقط روی سرور `IRAN` اجرا کن:

```bash
sudo gre-manager add-rule tcp 443 8443
```

### تست واقعی کیفیت مسیر

```bash
sudo gre-manager health
sudo gre-manager health 100
sudo gre-manager health 100 443
```

گزارش شامل Packet Loss مسیر Public و GRE، کمینه/میانگین/بیشینه RTT، Jitter، وضعیت هر دو موتور و امتیاز آمادگی است. این امتیاز تشخیصی است و تضمین آماری محسوب نمی‌شود. تست را روی هر دو سرور اجرا کن.

### Doctor، Repair و بهینه‌سازی

```bash
sudo gre-manager doctor
sudo gre-manager repair
sudo gre-manager optimize
sudo gre-manager status --json
```

`optimize` فقط تنظیمات مشخص و قابل‌بازگشت شامل FQ، TCP MTU probing و در صورت پشتیبانی کرنل BBR را اعمال می‌کند. برای حذف پروفایل:

```bash
sudo gre-manager restore-network
```

### دستورهای کاربردی

```bash
sudo gre-manager status
sudo gre-manager list-rules
sudo gre-manager list-gost
sudo gre-manager remove-gost tcp 443
sudo gre-manager gost-logs
sudo gre-manager restart
```

### نکته امنیتی مهم

GRE رمزنگاری ندارد. انتقال ساده GOST در حالت `public` هم به‌خودی‌خود رمزنگاری‌شده نیست. برای داده حساس از WireGuard یا IPsec استفاده کن و در Firewall فقط پورت‌ها و IPهای لازم را باز بگذار.

---

## English Guide

RIZAY is a bilingual terminal panel for managing a `GRE`, `GOST`, or recommended `HYBRID` stack between an `IRAN` gateway and a `KHAREJ` destination.

### One-line installation

Run on both servers:

```bash
curl -fsSL https://raw.githubusercontent.com/rizay041/gre-manager/main/quick-install.sh | sudo bash
```

Choose `HYBRID`, select the local server role, enter both public IPv4 addresses, and keep MTU `1400` unless your network requires a lower value.

### GOST forwarding on IRAN

```bash
sudo gre-manager add-gost tcp 443 8443 public
sudo gre-manager add-gost udp 443 8443 public
sudo gre-manager add-gost tcp 8443 8443 gre
```

`public` sends directly to the KHAREJ public IP and stays independent of GRE. `gre` targets the private GRE peer. The official pinned GOST binary is checksum-verified and installed in an isolated RIZAY path.

### GRE forwarding on IRAN

```bash
sudo gre-manager add-rule tcp 443 8443
```

### Diagnostics and maintenance

```bash
sudo gre-manager health 100 443
sudo gre-manager doctor
sudo gre-manager repair
sudo gre-manager status --json
sudo gre-manager optimize
```

GRE and plain GOST port forwarding do not provide encryption. Use WireGuard or IPsec when confidentiality is required.

## ارتباط / Contact

[Instagram @rizay_041](https://www.instagram.com/rizay_041/) · [GitHub @rizay041](https://github.com/rizay041)

Made with care by RIZAY. License: [MIT](LICENSE)
