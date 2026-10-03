![RIZAY GRE Manager](assets/rizay-logo.svg)

# RIZAY GRE Manager v3.0.1

## راهنمای فارسی

سلام رفیق! این ابزار بین سرور `IRAN` و `KHAREJ` تونل GRE می‌سازد. کاربران به IP سرور ایران وصل می‌شوند و پورت‌ها به سرویس اصلی روی سرور خارج منتقل می‌شوند.

### نصب با فقط یک خط

این دستور را روی هر دو سرور اجرا کن:

```bash
curl -fsSL https://raw.githubusercontent.com/rizay041/gre-manager/main/quick-install.sh | sudo bash
```

تمام! نصب‌کننده خودش آخرین Release را دانلود می‌کند، SHA256 را بررسی می‌کند، پیش‌نیازها را نصب می‌کند و Wizard آبی و گرافیکی `RIZAY` را باز می‌کند.

### داخل Wizard چه چیزی انتخاب کنم؟

- روی سرور ایران، نقش `IRAN` را انتخاب کن.
- روی سرور مقصد، نقش `KHAREJ` را انتخاب کن.
- در هر دو سرور، IP عمومی ایران و خارج را وارد کن.
- برای MTU معمولاً مقدار `1400` مناسب است.

آدرس‌های داخلی GRE خودکار تنظیم می‌شوند:

- `IRAN`: `10.77.0.1/30`
- `KHAREJ`: `10.77.0.2/30`

### انتقال پورت

قانون Port Forward فقط روی سرور `IRAN` ساخته می‌شود. مثال زیر پورت `443` ایران را به پورت `8443` خارج منتقل می‌کند:

```bash
sudo gre-manager add-rule tcp 443 8443
```

برای UDP فقط `tcp` را با `udp` عوض کن.

### بررسی Packet Loss و کیفیت تونل

```bash
sudo gre-manager health
```

این ابزار به‌صورت پیش‌فرض ۵۰ پکت روی مسیر Public و ۵۰ پکت داخل GRE می‌فرستد و موارد زیر را نمایش می‌دهد:

- درصد Packet Loss مسیر Public و GRE
- حداقل، میانگین و حداکثر RTT
- وضعیت GRE Interface و IPv4 Forwarding
- امتیاز تخمینی آمادگی تونل از ۰ تا ۱۰۰

برای بررسی دقیق‌تر می‌توانی تعداد نمونه را تا ۲۰۰ افزایش بدهی:

```bash
sudo gre-manager health 100
```

این درصد یک امتیاز تشخیصی است، نه احتمال آماری تضمین‌شده. ممکن است ICMP در فایروال بسته باشد ولی سرویس کار کند. برای نتیجه بهتر، دستور Health را روی هر دو سرور اجرا کن.

### داشبورد گرافیکی

```bash
sudo gre-manager menu
```

از داخل داشبورد می‌توانی Setup، Health، Port Forward، Status، Restart و پاک‌کردن Rules را انجام بدهی.

### نکته امنیتی

GRE رمزنگاری ندارد. برای اطلاعات حساس آن را داخل IPsec یا WireGuard استفاده کن و دسترسی IP Protocol 47 را فقط برای IP سرور مقابل باز بگذار.

---

## English Guide

RIZAY creates a persistent GRE tunnel from an `IRAN` gateway to a `KHAREJ` destination server, with managed port forwarding and network diagnostics.

### One-line installation

Run this command on both servers:

```bash
curl -fsSL https://raw.githubusercontent.com/rizay041/gre-manager/main/quick-install.sh | sudo bash
```

The installer downloads the latest verified release, checks its SHA256 checksum, installs dependencies, and opens the blue graphical terminal wizard.

### Setup

- Select `IRAN` on the gateway server.
- Select `KHAREJ` on the destination server.
- Enter both public IPv4 addresses on each server.
- Keep the recommended MTU of `1400` unless your network needs a lower value.

GRE addresses are assigned automatically: `10.77.0.1/30` for IRAN and `10.77.0.2/30` for KHAREJ.

### Forward a port

Run port-forward commands on the IRAN server only:

```bash
sudo gre-manager add-rule tcp 443 8443
```

### Network diagnostics

```bash
sudo gre-manager health
sudo gre-manager health 100
```

Health reports Public/GRE packet loss, min/average/max RTT, interface state, forwarding state, and an estimated readiness score. Run it on both servers for a two-sided comparison. The score is diagnostic, not a guaranteed statistical probability.

### Useful commands

```bash
sudo gre-manager menu
sudo gre-manager status
sudo gre-manager list-rules
sudo gre-manager restart
sudo gre-manager clear-rules
```

## ارتباط / Contact

[Instagram @rizay_041](https://www.instagram.com/rizay_041/)

Made with care by RIZAY. License: [MIT](LICENSE)
