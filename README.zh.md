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

**🌐 &nbsp;[English](README.md) &nbsp;·&nbsp; [Tiếng Việt](README.vi.md) &nbsp;·&nbsp; 中文**

<br/>

[**⬇️ Download**](#-download--install) &nbsp;·&nbsp; [**✨ Working now**](#-working-now) &nbsp;·&nbsp; [**🗺️ Roadmap**](#-roadmap)

<br/>

<!-- Landing hero image. To swap for a real screenshot, see assets/screenshots/MANIFEST.md -->
<img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/screenshots/dashboard.png" width="760" alt="WGSmart dashboard — multiple tunnels active at once" />

</div>

---

## 🇨🇳 中文

### WGSmart 是什么？

WGSmart 是 macOS 上面向**高级用户的 WireGuard 控制台**。官方 WireGuard 客户端一次只能启用**一条**隧道；WGSmart 可以**同时**保持**多条**隧道在线，并让你精确到单个 IP 或子网地决定——**哪些流量走哪条隧道**。

它源于真实需求：两台服务器上的两个 VPN 需要同时使用。让 A 段走 VPN A、B 段走 VPN B——同时进行——或把某个具体 IP 固定到你指定的隧道。这正是官方客户端做不到的。

> **隧道配置由你自备。** WGSmart 不是 VPN 服务，而是让你的隧道按你意愿运行的管理器。

### ✨ 已经好用

作者本人每天在 macOS 上使用。

- 🔀 **多条隧道同时运行** — 各自保留自己的 `AllowedIPs`，并行连接，而不是轮流上线。
- 🎯 **任意地址走任意隧道** — 把某个 IP 或 CIDR 钉到指定隧道。更长的前缀优先，因此 `/32` 可以覆盖全局隧道。
- 🛡️ **故障即断网的开关** — 基于 `pf` 构建。它会先快照你现有的防火墙规则，退出时再还原，而不是直接覆盖。
- ⚠️ **导入时就发现冲突** — 重叠的地址段、第二份全局隧道配置，会在破坏路由之前被标出来。
- 🧪 **证明它真的在分流** — 一次点击就报告握手时间、往返延迟，以及隧道出口 IP 与你真实公网 IP 的对比。另一项检查会逐条对照内核验证路由。
- 🌐 **会变动的端点** — 域名端点在变化时通过 `1.1.1.1` / `8.8.8.8` 重新解析，动态地址的服务器不会让隧道卡死。
- 📜 **实时日志，按隧道也按全局** — 直接从引擎流出，可筛选、可导出。
- 🎛️ **菜单栏与主面板** — 吞吐量与握手时间一眼可见；需要改动时再打开完整窗口。
- ⌨️ **完整的命令行** — 应用里的每个操作都有对应的一条命令，走同一套接口。可脚本化，支持 JSON 输出。
- 🏗️ **配置工作台** — 编写服务端配置及其客户端配置，在本机生成密钥，以文件或二维码分发。
- 🔐 **密钥保存在钥匙串中** — 私钥存放在 macOS 钥匙串，绝不以明文留在磁盘上。
- ✍️ **可自行核验的更新** — 每个版本都带 SHA-256 与 Ed25519 签名，应用核验一次，特权服务在安装前再独立核验一次。签名绑定文件名，因此版本降级会失败关闭，而签名密钥从未放在 GitHub 上。

### 🧪 已写好，仍在验证

已经写完、单独测试通过，并且随版本发布 —— 但还没有在真实机器上跑够久，无法保证可靠。所以列在这里，而不是拿来向你推销。

- 🌍 **按域名分流** — 解析域名并钉住返回的地址。本质上是尽力而为：使用 DoH/DoT 或硬编码 IP 的应用会绕过它，大型 CDN 返回的地址池也一直在变。这是路由上的便利，**不是安全手段**。
- 👤 **按 macOS 用户分流** — 在 macOS 上，它匹配的是**进程所属的用户，不是单个应用**。真正的按应用分流需要一项 WGSmart 并不具备的 Apple 权限。
- 🔌 **按端口分流** — 把某个端口或端口段送进指定隧道，TCP、UDP 或两者皆可，按源端口或目标端口匹配。
- 🧭 **按 DNS 分流** — 一个本地解析器，通过观察应答来更准确地钉住路由。已经内置但**默认关闭**，因为解析器一旦出错，整台机器的 DNS 都会跟着出问题。
- 📊 **通知中心小组件** — 一眼看到隧道状态。**只读** —— 它显示状态，不切换隧道。
- 📶 **按 Wi-Fi 的智能规则** — 在不可信网络自动连接，在可信 SSID 上自动停用。
- 🐧 **Linux 服务端集线器** — 无界面服务，配浏览器 UI，一行命令即可安装（已签名，amd64 与 arm64）。**自 1.0.3 起**，打包部分已端到端验证过 —— 在真实的 systemd 系统上分别从 apt 和 tarball 安装、服务已启动、浏览器界面已登录成功。**仍未被证明的是 VPN 本身**：其中每一处 `nft`、`ip` 和 cgroup 调用都只被单元测试覆盖过，还没有任何隧道在真实硬件上承载过流量。见 [Linux 安装](#linux-hub)。
- 🪟 **Windows** — 引擎能编译、测试通过，仅此而已。没有 Windows 应用，按用户和按端口分流在那里还没有对应机制，**也不提供下载**。

### 🖼️ 截图

| 添加隧道 | 智能规则 | 连接测试 |
|---|---|---|
| ![添加隧道 — 导入 .conf，当场标记冲突](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/screenshots/tunnels.png) | ![智能规则 — 按 IP 覆盖路由](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/smart-rules.svg) | ![连接测试 — 隧道出口 IP vs 公网 IP](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/connection-test.svg) |

<p align="center"><img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/menubar.svg" width="340" alt="菜单栏弹窗 — 实时状态与吞吐" /></p>

### ⬇️ 下载与安装

1. 从 [**Releases**](https://github.com/lyquyduong/WGSmart/releases) 页面获取最新的 **`WGSmart-<version>.pkg`**。
2. 双击 `.pkg`。它会把 **WGSmart.app** 安装到 `/Applications`，并安装隧道所需的后台服务 —— macOS 上的 WireGuard 没有它就无法创建隧道或设置路由。
3. 打开 **WGSmart**，导入你的 `.conf` 文件，然后连接。

> **系统要求：** **macOS 15 或更高** · Apple Silicon 与 Intel · 管理员权限，用于路由与断网保护服务。

#### 首次打开时 macOS 会警告。原因如下。

WGSmart **尚未通过 Apple 公证**。公证需要付费的 Apple Developer 会员资格，本项目目前还没有，所以首次打开时 macOS 会说无法验证开发者。**那条警告是准确的** —— Apple 确实没有检查过这个版本。

要照常打开：右键点击应用 ▸ **打开**，然后确认一次。后续更新不需要再这样做。

如果你觉得为一个以系统权限运行的工具做这种取舍并不值得，那是完全合理的判断 —— 请等公证版本。它正是当前优先筹措的目标，目标进度见下方「支持」一节。

<a id="linux-hub"></a>

### 🐧 Linux 服务端集线器（Ubuntu、Debian、RHEL）

它与 Mac 应用是**不同的产品**：没有图形界面，也不是客户端。它把一台**服务器**变成 WireGuard 集线
器 —— 创建 TUN 设备、开启 IPv4 转发、为隧道网段安装 nftables 伪装规则、放行监听端口。与 macOS
守护进程同一套内核，由 systemd 托管。

> ⚠️ **这个版本作者从未在生产环境中运行过。**它能交叉编译、测试通过；其中每一处 `nft`、`ip` 和
> cgroup 调用都只被单元测试覆盖过。请在一台坏了也无所谓的服务器上试，不要用在别人依赖的机器上。
> 我们宁愿把这句话说明白，也不愿让你误以为相反。

**一行命令，任意发行版**

```sh
curl -fsSL https://wgsmart.base101.app/installer.sh | sh
```

加上 `sh -s -- --with-web` 可同时启用浏览器界面；加 `--dry-run` 则只显示它会做什么，不改动任何东西。

它会为你的系统选择正确的路径，并明确告诉你选了哪条：

| 你的系统 | 它做什么 | 由谁校验下载内容 |
|---|---|---|
| Debian、Ubuntu 及其衍生版 | 配置 APT 仓库，然后 `apt install` | **GPG**，而且此后每次 `apt upgrade` 都会继续校验 |
| 其余系统 | 按已签名的更新清单所指，下载已签名的 tarball | **Ed25519**，在解压任何文件之前完成校验 |

若无法校验，它会**停止**，而不是照装不误。（tarball 路径需要 OpenSSL 3.x 才能校验 Ed25519 ——
OpenSSL 1.1.1 在命令行上根本做不到。那么旧的系统几乎都是 Debian 或 Ubuntu，它们走 apt 路径，不受影响。）

**先读一遍再运行仍是更好的习惯** —— 它安装的是以 root 运行的服务，你不该只凭我们一句话就相信它做了什么：

```sh
curl -fsSL https://wgsmart.base101.app/installer.sh -o installer.sh
less installer.sh && sh installer.sh
```

<details>
<summary><b>想自己动手？—— apt，分步骤</b></summary>

这正是安装脚本在 Debian 系系统上所做的事：

```sh
curl -fsSL https://wgsmart.base101.app/apt/wgsmart.gpg \
  | sudo tee /usr/share/keyrings/wgsmart.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/wgsmart.gpg] https://wgsmart.base101.app/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/wgsmart.list
sudo apt update && sudo apt install wgsmart-hub
```

</details>

之后用 `apt upgrade` 升级即可。软件包会自动拉取 `iproute2` 与 `nftables`，安装 systemd 单元，并
**只启用、不启动**服务 —— 因为此时还没有配置。放好集线器配置再启动：

```sh
sudo install -m 0600 wg0.conf /etc/wgsmart/wg0.conf
sudo systemctl start wgsmart-hub && systemctl status wgsmart-hub
```

<details>
<summary><b>想自己动手？—— tarball，分步骤</b></summary>

```sh
sudo apt-get install -y iproute2 nftables

# Resolves the newest release, so this snippet never goes stale.
VER=$(curl -fsSI https://github.com/lyquyduong/WGSmart/releases/latest \
      | awk -F'/v' 'tolower($0) ~ /^location:/{print $2}' | tr -d '\r\n')
ARCH=$(uname -m); case "$ARCH" in x86_64) ARCH=amd64;; aarch64|arm64) ARCH=arm64;; esac
BASE="wgsmart-hub-${VER}-linux-${ARCH}.tar.gz"
URL="https://github.com/lyquyduong/WGSmart/releases/download/v${VER}"

curl -fLO "${URL}/${BASE}" && curl -fLO "${URL}/${BASE}.sha256"
sha256sum -c "${BASE}.sha256"          # 必须输出：OK

tar xzf "$BASE"
sudo "wgsmart-hub-${VER}-linux-${ARCH}/install.sh"
```

在 **RHEL / Fedora / Rocky** 上，只有第一行不同：
`sudo dnf install -y iproute nftables`。

它会把可执行文件装到 `/usr/bin/wgsmart-hub`，放置 systemd 单元，创建 `/etc/wgsmart`，然后启用并
启动服务。重复执行即为原地升级，若你已启用浏览器界面，它也会一并升级。

</details>

```sh
systemctl status wgsmart-hub
journalctl -u wgsmart-hub -f
```

#### 浏览器界面

用浏览器管理集线器，而不必依赖 Mac 应用 —— 一个内嵌页面，没有 CDN，没有构建步骤。

```sh
sudo wgsmart-webui-enable      # 通过 apt 安装时
sudo ./install.sh --with-web   # 通过 tarball 安装时
```

它**在你启用之前一直是关闭的**，只监听回环地址，并以非特权账户运行 —— 这是摆在 root 服务前面的一个
HTTP 登录界面，所以其中没有任何一项是自动开启的。通过 SSH 隧道访问
（`ssh -N -L 8080:127.0.0.1:8080 you@server`），或在前面架一层 TLS 代理；tarball 中以及
`/usr/share/doc/wgsmart-hub/` 下的 `WEBUI.md` 用三种语言讲清了这两种做法。

在同一台机器上，它通过 Unix 套接字与集线器通信，**完全不需要证书** —— 套接字权限为 `0600`，每个连接
都经过 `SO_PEERCRED` 校验，由内核担保对端究竟是哪个进程。管理**另一台机器**上的集线器则使用 TLS 1.3
配合双向 TLS 和/或 bearer 令牌。

随后在 Mac 应用的 **Config Studio** 里导出集线器的 `.conf`，放到 `/etc/wgsmart/wg0.conf`，权限设
为 `0600` —— 该文件含有集线器的私钥。

每个压缩包都附带**英文、越南文和中文**三种完整安装指南（`INSTALL.md` · `INSTALL.vi.md` ·
`INSTALL.zh.md`），涵盖 Ed25519 签名核验、通过 TLS 的远程管理、卸载与故障排查。

> **环境要求：** 带 systemd 的 Linux · `PATH` 中有 `iproute2` 与 `nftables` · root 权限。
> 卸载用 `sudo <目录>/uninstall.sh`（加 `--purge` 连配置和状态一起删除）。

#### 核验你下载的文件

```sh
shasum -a 256 WGSmart-<version>.pkg
```

把结果与随版本发布的校验值比对。应用内的更新流程走得更远：它核验 SHA-256 **和** Ed25519 签名，特权服务在安装前还会自己再核验一遍。签名绑定文件名，因此旧版本无法被当作新版本重放 —— 而签名密钥从未放在 GitHub 上，因此即便账号被攻破，也无法造出 WGSmart 会接受的更新。

### 🗺️ 路线图

**macOS 优先**（当前）→ **Linux 服务端版本**及远程浏览器 UI（已写好，从未在真实 Linux 主机上运行）→ **Windows**（引擎可以为它编译；按用户和按端口分流在那里还没有对应机制，应用会如实报错，而不是假装支持）。

**接下来是 Apple 公证。** 它能彻底消除首次打开的警告，资金来自捐款 —— 目标就在下方。桌面版 Tauri 外壳经过考虑后已**放弃**：Linux 服务的浏览器 UI 已经覆盖了这个需求。**iOS 是有意搁置的** —— Apple 的网络框架一次只允许一条隧道活动，这等于抹掉了 WGSmart 存在的全部理由。**也不会上 Mac App Store**：WGSmart 依赖的特权服务与防火墙访问，在 App Store 沙盒里都是不被允许的。

模式：免费闭源的 **Community Edition** + **Premium** + **Sponsor**。发布版本都有签名，你可以自行核验。

### 💛 支持本项目

**WGSmart 是免费的——并将一直如此。** 如果它让你不必手动切换 VPN，一点小小的心意就能让项目继续为大家服务。没有压力。🧡

> **第一个目标 —— Apple Developer 会员资格（每年 99 美元）。** 这是 WGSmart 与「安装时没有可怕警告」之间唯一的阻碍。捐款会优先用于它。

[**♥ 支持**](https://ko-fi.com/nkcoder) &nbsp;·&nbsp; [**💡 请求功能**](https://github.com/lyquyduong/WGSmart/issues) &nbsp;·&nbsp; [**🐛 报告问题**](https://github.com/lyquyduong/WGSmart/issues) &nbsp;·&nbsp; [**⭐ Star 仓库**](https://github.com/lyquyduong/WGSmart)

| ☕ Ko-fi | 🏦 银行转账 · VietQR | 📱 MoMo |
|:--:|:--:|:--:|
| <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/kofi-qr.png" width="150" alt="Ko-fi 二维码" /> | <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/bank-vietqr.png" width="150" alt="银行 VietQR 二维码" /> | <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/momo-qr.png" width="150" alt="MoMo 二维码" /> |
| [ko-fi.com/nkcoder](https://ko-fi.com/nkcoder)<br><sub>请我喝杯咖啡 · 国际</sub> | **LÝ QUÝ DƯƠNG**<br><code>9007041118966</code><br><sub>Timo · BVBank · napas 247</sub> | **LÝ QUÝ DƯƠNG**<br><sub>账户&nbsp;·&nbsp;\*\*\*\*\*\*\*045</sub> |

---

<a id="-license"></a>

## 📄 License

WGSmart is distributed as **proprietary freeware** — free to use, not open source. This repository hosts the landing page and release downloads only; it does **not** contain the application source code.

<div align="center">
<sub>Made with ⚡ by <a href="https://github.com/lyquyduong">lyquyduong</a> · WGSmart — Securing the intelligence edge.</sub>
</div>
