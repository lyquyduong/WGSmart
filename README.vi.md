<!-- ============================================================= -->
<!--  WGSmart — public landing README  (English · Tiếng Việt · 中文) -->
<!--  Source code lives elsewhere. This repo = intro + releases.    -->
<!-- ============================================================= -->

<div align="center">

<img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/logo.svg" width="88" height="88" alt="WGSmart logo" />

# WGSmart

**The WireGuard power-tool for macOS.**
Run and route **multiple WireGuard tunnels at once** — with per-IP control the official client can't give you.

<sub>Securing the intelligence edge.</sub>

<br/>

[![Platform: macOS Apple Silicon](https://img.shields.io/badge/macOS-Apple%20Silicon-0E1E30?logo=apple&logoColor=white)](#-download--install)
[![Status: pre-release](https://img.shields.io/badge/status-pre--release-F59E0B)](https://github.com/lyquyduong/WGSmart/releases)
[![License: Freeware](https://img.shields.io/badge/license-Freeware-6B7280)](#-license)
[![Star this repo](https://img.shields.io/badge/⭐_Star_this_repo-0E1E30?logo=github&logoColor=white)](https://github.com/lyquyduong/WGSmart)
<!-- Pre-launch, this is a call-to-action (no count) so it never shows "0 stars".
     Once the repo has traction, swap it for the live count:
     [![Stars](https://img.shields.io/github/stars/lyquyduong/WGSmart?color=3B82F6&labelColor=0E1E30)](https://github.com/lyquyduong/WGSmart/stargazers) -->
<!-- After the first GitHub release, replace the static Status badge above with these live ones:
[![Latest release](https://img.shields.io/github/v/release/lyquyduong/WGSmart?color=3B82F6&labelColor=0E1E30)](https://github.com/lyquyduong/WGSmart/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/lyquyduong/WGSmart/total?color=3B82F6&labelColor=0E1E30)](https://github.com/lyquyduong/WGSmart/releases)
-->


<br/>

**🌐 &nbsp;[English](README.md) &nbsp;·&nbsp; Tiếng Việt &nbsp;·&nbsp; [中文](README.zh.md)**

<br/>

[**⬇️ Download**](#-download--install) &nbsp;·&nbsp; [**✨ Working now**](#-working-now) &nbsp;·&nbsp; [**🗺️ Roadmap**](#-roadmap)

<br/>

<!-- Landing hero image. To swap for a real screenshot, see assets/screenshots/MANIFEST.md -->
<img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/screenshots/dashboard.png" width="760" alt="WGSmart dashboard — multiple tunnels active at once" />

</div>

---

## 🇻🇳 Tiếng Việt

### WGSmart là gì?

WGSmart là **control-plane WireGuard cho power user** trên macOS. Client WireGuard chính chủ chỉ bật được **một** tunnel tại một thời điểm. WGSmart bật **nhiều** tunnel **cùng lúc** và cho bạn quyết định — tới từng IP hoặc subnet — **traffic nào đi qua tunnel nào**.

Nó sinh ra từ nhu cầu thật: hai VPN trên hai server, cần dùng đồng thời. Cho dải A đi qua VPN A và dải B đi qua VPN B — cùng lúc — hoặc ghim một IP cụ thể vào đúng tunnel bạn chọn. Đó là việc client mặc định không làm được.

> **Bạn tự mang config WireGuard của mình.** WGSmart không phải dịch vụ VPN — nó là trình quản lý giúp các tunnel của bạn chạy đúng ý.

### ✨ Đang chạy tốt

Chính người viết dùng mỗi ngày trên macOS.

- 🔀 **Nhiều tunnel, cùng lúc** — Mỗi cái giữ `AllowedIPs` riêng, kết nối song song thay vì lần lượt.
- 🎯 **Đẩy địa chỉ nào qua tunnel nào cũng được** — Ghim một IP hoặc CIDR vào tunnel cụ thể. Prefix dài hơn thắng, nên `/32` ghi đè cả full tunnel.
- 🛡️ **Kill switch fail-closed** — Dựng trên `pf`. Nó chụp lại ruleset firewall đang có của bạn và phục hồi khi tắt, chứ không đạp lên.
- ⚠️ **Bắt xung đột ngay khi import** — Dải IP trùng nhau và config full-tunnel thứ hai được cảnh báo trước khi làm hỏng routing.
- 🧪 **Chứng minh nó đang route thật** — Một click báo tuổi handshake, round-trip, và IP thoát của tunnel đặt cạnh IP công khai thật. Một kiểm tra nữa đối chiếu từng route với kernel.
- 🌐 **Endpoint hay đổi IP** — Endpoint dạng hostname được resolve lại qua `1.1.1.1` / `8.8.8.8` khi thay đổi, nên server dùng IP động không làm tunnel chết.
- 📜 **Log trực tiếp, theo tunnel và toàn hệ thống** — Stream thẳng từ engine, lọc được, export được.
- 🎛️ **Menu bar và dashboard** — Throughput và tuổi handshake nhìn là biết; mở cửa sổ đầy đủ khi cần sửa.
- ⌨️ **CLI thật** — Mọi thao tác trong app đều có một câu lệnh tương ứng, qua cùng một interface. Script được, xuất JSON.
- 🏗️ **Config Studio** — Soạn profile server và config client, sinh khoá ngay trên máy, phát ra dạng file hoặc QR.
- 🔐 **Khoá nằm trong Keychain** — Private key ở Keychain macOS, không bao giờ để plaintext trên đĩa.
- ✍️ **Bản cập nhật kiểm chứng được** — Mỗi bản có SHA-256 và chữ ký Ed25519, app kiểm rồi service quyền cao kiểm độc lập lần nữa trước khi cài. Chữ ký bind cả tên file nên hạ cấp phiên bản là fail closed, và khoá ký chưa bao giờ nằm trên GitHub.

### 🧪 Đã viết, còn đang kiểm chứng

Đã viết xong, test riêng lẻ đạt, và có trong bản build — nhưng chưa chạy đủ lâu trên máy thật để dám hứa là ổn. Nên liệt kê ở đây, không phải để bán cho bạn.

- 🌍 **Route theo domain** — Resolve domain rồi ghim các địa chỉ nhận được. Bản chất là best-effort: app dùng DoH/DoT hoặc IP hard-code sẽ lọt qua, và CDN lớn trả về pool luôn thay đổi. Đây là tiện ích routing, **không phải biện pháp bảo mật**.
- 👤 **Route theo user macOS** — Trên macOS cái này khớp theo **user mà process chạy dưới, không phải từng app riêng**. Route theo app thật sự cần một entitlement của Apple mà WGSmart không có.
- 🔌 **Route theo cổng** — Đẩy một cổng hoặc dải cổng qua tunnel chọn trước, TCP, UDP hoặc cả hai, khớp theo cổng nguồn hoặc đích.
- 🧭 **Route theo DNS** — Một resolver cục bộ quan sát câu trả lời để ghim route chính xác hơn. Có sẵn nhưng **mặc định tắt**, vì resolver chạy sai sẽ kéo theo DNS của cả máy.
- 📊 **Widget Notification Center** — Trạng thái tunnel nhìn là biết. **Chỉ đọc** — nó hiện trạng thái, không bật tắt tunnel.
- 📶 **Smart rules theo Wi-Fi** — Tự kết nối ở mạng không tin cậy, tự đứng xuống ở SSID tin cậy.
- 🐧 **Hub máy chủ Linux** — Service headless kèm UI trên browser, cài được bằng một dòng lệnh (đã ký, amd64 và arm64). **Từ bản 1.0.3**, phần đóng gói đã được kiểm chứng đầu-cuối — cài từ apt và từ tarball trên một hệ systemd thật, service khởi động, đã đăng nhập được vào UI. Thứ **vẫn chưa được chứng minh là bản thân phần VPN**: mọi lệnh `nft`, `ip` và cgroup mới chỉ được unit test chạm tới, và chưa có tunnel nào tải lưu lượng trên phần cứng thật. Xem [phần cài Linux](#linux-hub).
- 🪟 **Windows** — Engine biên dịch được và test đạt, chỉ vậy thôi. Chưa có app Windows, định tuyến theo user và theo port chưa có cơ chế tương đương ở đó, và **chưa được đưa ra tải**.

### 🖼️ Ảnh chụp

| Thêm tunnel | Smart Rules | Test kết nối |
|---|---|---|
| ![Thêm tunnel — import .conf, báo xung đột ngay](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/screenshots/tunnels.png) | ![Smart Rules — ghi đè định tuyến theo IP](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/smart-rules.svg) | ![Test kết nối — IP thoát tunnel vs IP công khai](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/connection-test.svg) |

<p align="center"><img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/menubar.svg" width="340" alt="Popover menu bar — trạng thái và lưu lượng trực tiếp" /></p>

### ⬇️ Tải & Cài đặt

1. Lấy bản **`WGSmart-<version>.pkg`** mới nhất ở trang [**Releases**](https://github.com/lyquyduong/WGSmart/releases).
2. Double-click file `.pkg`. Nó cài **WGSmart.app** vào `/Applications` kèm service chạy nền mà tunnel cần — WireGuard trên macOS không tạo được tunnel hay set route nếu thiếu.
3. Mở **WGSmart**, import các file `.conf`, rồi kết nối.

> **Yêu cầu:** **macOS 15 trở lên** · Apple Silicon và Intel · quyền administrator, cho service routing và kill switch.

#### macOS sẽ cảnh báo ở lần đầu. Đây là lý do chính xác.

WGSmart **chưa được Apple notarize**. Notarize cần tài khoản Apple Developer trả phí mà dự án chưa có, nên lần mở đầu macOS nói không xác minh được nhà phát triển. **Cảnh báo đó là đúng** — Apple chưa kiểm tra bản build này.

Để vẫn mở: bấm chuột phải vào app ▸ **Open**, rồi xác nhận một lần. Các bản cập nhật sau sẽ không cần làm lại.

Nếu bạn thấy đó không phải đánh đổi đáng làm cho một công cụ chạy với quyền hệ thống, thì đó là quyết định hoàn toàn hợp lý — hãy chờ bản đã notarize. Đó là mục được ưu tiên gây quỹ, mục tiêu nằm ở phần Ủng hộ bên dưới.

<a id="linux-hub"></a>

### 🐧 Hub máy chủ Linux (Ubuntu, Debian, RHEL)

Đây là một sản phẩm khác với app Mac: không GUI, không phải client. Nó biến một **máy chủ** thành
WireGuard hub — tạo thiết bị TUN, bật IPv4 forwarding, cài masquerade nftables cho dải mạng của
tunnel, và mở cổng lắng nghe. Cùng một core với daemon macOS, chạy dưới systemd.

> ⚠️ **Bản này tác giả chưa từng chạy trong môi trường thật.** Nó cross-compile được và test đạt;
> mọi lệnh `nft`, `ip` và cgroup trong đó mới chỉ được unit test chạm tới. Hãy thử trên máy chủ bạn
> chấp nhận hỏng được, đừng thử trên máy đang có người phụ thuộc. Chúng tôi thà nói thẳng còn hơn
> để bạn tự cho là ngược lại.

**Một dòng, mọi distro**

```sh
curl -fsSL https://wgsmart.base101.app/installer.sh | sh
```

Thêm `sh -s -- --with-web` để bật luôn giao diện web, hoặc `--dry-run` để xem nó sẽ làm gì mà
không thay đổi gì cả.

Nó tự chọn đúng đường cho máy bạn và nói rõ đã chọn đường nào:

| Hệ của bạn | Nó làm gì | Ai xác minh bản tải |
|---|---|---|
| Debian, Ubuntu và các bản dẫn xuất | Cấu hình kho APT rồi `apt install` | **GPG**, và tiếp tục xác minh ở mọi lần `apt upgrade` sau này |
| Còn lại | Tải tarball đã ký, theo đúng tên ghi trong manifest đã ký | **Ed25519**, kiểm trước khi giải nén bất cứ thứ gì |

Nếu không xác minh được, nó **dừng** chứ không cài liều. (Đường tarball cần OpenSSL 3.x để kiểm
Ed25519 — OpenSSL 1.1.1 hoàn toàn không làm được việc này qua dòng lệnh. Những hệ cũ tới mức đó
gần như luôn là Debian hoặc Ubuntu, vốn đi đường apt nên không bị ảnh hưởng.)

**Đọc trước khi chạy vẫn là thói quen tốt hơn** — nó cài một service chạy quyền root, và bạn không
nên phải tin lời chúng tôi về chuyện nó làm gì:

```sh
curl -fsSL https://wgsmart.base101.app/installer.sh -o installer.sh
less installer.sh && sh installer.sh
```

<details>
<summary><b>Muốn tự tay làm? — apt, từng bước</b></summary>

Đúng những gì installer làm trên một hệ Debian-family:

```sh
curl -fsSL https://wgsmart.base101.app/apt/wgsmart.gpg \
  | sudo tee /usr/share/keyrings/wgsmart.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/wgsmart.gpg] https://wgsmart.base101.app/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/wgsmart.list
sudo apt update && sudo apt install wgsmart-hub
```

</details>

Từ đó nâng cấp bằng `apt upgrade` như mọi gói khác. Gói tự kéo `iproute2` và `nftables`, cài
systemd unit, và **enable nhưng không start** service — vì chưa có config. Đặt config của hub vào
rồi mới khởi động:

```sh
sudo install -m 0600 wg0.conf /etc/wgsmart/wg0.conf
sudo systemctl start wgsmart-hub && systemctl status wgsmart-hub
```

<details>
<summary><b>Muốn tự tay làm? — tarball, từng bước</b></summary>

```sh
sudo apt-get install -y iproute2 nftables

# Resolves the newest release, so this snippet never goes stale.
VER=$(curl -fsSI https://github.com/lyquyduong/WGSmart/releases/latest \
      | awk -F'/v' 'tolower($0) ~ /^location:/{print $2}' | tr -d '\r\n')
ARCH=$(uname -m); case "$ARCH" in x86_64) ARCH=amd64;; aarch64|arm64) ARCH=arm64;; esac
BASE="wgsmart-hub-${VER}-linux-${ARCH}.tar.gz"
URL="https://github.com/lyquyduong/WGSmart/releases/download/v${VER}"

curl -fLO "${URL}/${BASE}" && curl -fLO "${URL}/${BASE}.sha256"
sha256sum -c "${BASE}.sha256"          # phải in ra: OK

tar xzf "$BASE"
sudo "wgsmart-hub-${VER}-linux-${ARCH}/install.sh"
```

Trên **RHEL / Fedora / Rocky** chỉ khác đúng dòng đầu:
`sudo dnf install -y iproute nftables`.

Lệnh trên đặt binary vào `/usr/bin/wgsmart-hub`, cài systemd unit, tạo `/etc/wgsmart`, rồi enable
và khởi động service. Chạy lại chính nó để nâng cấp tại chỗ, kể cả giao diện web nếu bạn đã bật.

</details>

```sh
systemctl status wgsmart-hub
journalctl -u wgsmart-hub -f
```

#### Giao diện web

Quản trị hub bằng trình duyệt thay vì app Mac — một trang nhúng sẵn, không CDN, không bước build.

```sh
sudo wgsmart-webui-enable      # cài bằng apt
sudo ./install.sh --with-web   # cài bằng tarball
```

Nó **tắt cho tới khi bạn bật**, chỉ nghe loopback, và chạy dưới tài khoản không đặc quyền — đây là
một form đăng nhập HTTP đặt trước một service chạy root, nên không thứ nào trong đó được bật tự
động. Vào bằng SSH tunnel (`ssh -N -L 8080:127.0.0.1:8080 you@server`) hoặc đặt TLS proxy phía
trước; `WEBUI.md` trong tarball và tại `/usr/share/doc/wgsmart-hub/` hướng dẫn cả hai, bằng cả ba
thứ tiếng.

Trên cùng một máy, nó nói chuyện với hub qua Unix socket **không cần chứng chỉ nào** — socket để
`0600` và mọi kết nối đều bị kiểm bằng `SO_PEERCRED`, tức chính kernel bảo chứng tiến trình bên kia
là ai. Quản trị hub nằm trên **máy khác** thì dùng TLS 1.3 kèm mutual TLS và/hoặc bearer token.

Sau đó export file `.conf` của hub từ **Config Studio** trong app Mac và đặt vào
`/etc/wgsmart/wg0.conf` với quyền `0600` — file này chứa khoá riêng của hub.

Mỗi tarball đều mang theo hướng dẫn cài đầy đủ bằng **tiếng Anh, tiếng Việt và tiếng Trung**
(`INSTALL.md` · `INSTALL.vi.md` · `INSTALL.zh.md`), gồm cả cách kiểm chữ ký Ed25519, quản lý từ xa
qua TLS, gỡ cài đặt và xử lý sự cố.

> **Yêu cầu:** Linux có systemd · `iproute2` và `nftables` trong `PATH` · quyền root.
> Gỡ bằng `sudo <thư-mục>/uninstall.sh` (thêm `--purge` để xoá cả config và state).

#### Kiểm tra file bạn vừa tải

```sh
shasum -a 256 WGSmart-<version>.pkg
```

So kết quả với checksum công bố kèm bản phát hành. Bộ cập nhật trong app còn đi xa hơn: nó kiểm SHA-256 **và** chữ ký Ed25519, rồi service quyền cao tự kiểm lại cả hai trước khi cài. Chữ ký bind cả tên file nên không thể phát lại bản cũ như bản mới — và khoá ký chưa bao giờ nằm trên GitHub, nên tài khoản bị chiếm vẫn không tạo được bản cập nhật mà WGSmart chấp nhận.

### 🗺️ Roadmap

**macOS trước** (hiện tại) → **bản server Linux** kèm UI trên browser từ xa (đã viết, chưa từng chạy trên host Linux thật) → **Windows** (engine compile được; route theo user và theo cổng chưa có cơ chế tương đương ở đó, và app báo lỗi trung thực chứ không giả vờ làm được).

**Apple notarization là việc kế tiếp.** Nó bỏ hẳn cảnh báo lần đầu, và được gây quỹ từ tiền ủng hộ — mục tiêu ở ngay dưới. Vỏ desktop Tauri đã được cân nhắc và **bỏ**: UI trên browser của service Linux đã đủ cho nhu cầu đó. **iOS chủ động gác lại** — framework mạng của Apple chỉ cho một tunnel hoạt động tại một thời điểm, tức là mất luôn lý do tồn tại của WGSmart. **Cũng không lên Mac App Store**: service quyền cao và quyền truy cập firewall mà WGSmart cần đều không được phép trong sandbox App Store.

Mô hình: **Community Edition** miễn phí, mã nguồn đóng + **Premium** + **Sponsor**. Bản phát hành được ký để bạn tự kiểm chứng.

### 💛 Ủng hộ dự án

**WGSmart miễn phí — và sẽ luôn như vậy.** Nếu nó giúp bạn khỏi phải chuyển VPN bằng tay, một khoản nhỏ giúp dự án sống tiếp cho mọi người. Không áp lực nhé. 🧡

> **Mục tiêu đầu tiên — tài khoản Apple Developer ($99/năm).** Đây là thứ duy nhất còn chắn giữa WGSmart và một lần cài không có cảnh báo đáng sợ. Tiền ủng hộ dùng cho nó trước.

[**♥ Ủng hộ**](https://ko-fi.com/nkcoder) &nbsp;·&nbsp; [**💡 Yêu cầu tính năng**](https://github.com/lyquyduong/WGSmart/issues) &nbsp;·&nbsp; [**🐛 Báo lỗi**](https://github.com/lyquyduong/WGSmart/issues) &nbsp;·&nbsp; [**⭐ Star repo**](https://github.com/lyquyduong/WGSmart)

| ☕ Ko-fi | 🏦 Chuyển khoản · VietQR | 📱 MoMo |
|:--:|:--:|:--:|
| <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/kofi-qr.png" width="150" alt="Mã QR Ko-fi" /> | <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/bank-vietqr.png" width="150" alt="Mã VietQR ngân hàng" /> | <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/momo-qr.png" width="150" alt="Mã QR MoMo" /> |
| [ko-fi.com/nkcoder](https://ko-fi.com/nkcoder)<br><sub>Mời một ly cà phê · quốc tế</sub> | **LÝ QUÝ DƯƠNG**<br><code>9007041118966</code><br><sub>Timo · BVBank · napas 247</sub> | **LÝ QUÝ DƯƠNG**<br><sub>tài khoản&nbsp;·&nbsp;\*\*\*\*\*\*\*045</sub> |

---

<a id="-license"></a>

## 📄 License

WGSmart is distributed as **proprietary freeware** — free to use, not open source. This repository hosts the landing page and release downloads only; it does **not** contain the application source code.

<div align="center">
<sub>Made with ⚡ by <a href="https://github.com/lyquyduong">lyquyduong</a> · WGSmart — Securing the intelligence edge.</sub>
</div>
