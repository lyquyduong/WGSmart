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

**🌐 &nbsp;English &nbsp;·&nbsp; [Tiếng Việt](README.vi.md) &nbsp;·&nbsp; [中文](README.zh.md)**

<br/>

[**⬇️ Download**](#-download--install) &nbsp;·&nbsp; [**✨ Working now**](#-working-now) &nbsp;·&nbsp; [**🗺️ Roadmap**](#-roadmap)

<br/>

<!-- Landing hero image. To swap for a real screenshot, see assets/screenshots/MANIFEST.md -->
<img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/screenshots/dashboard.png" width="760" alt="WGSmart dashboard — multiple tunnels active at once" />

</div>

---

## 🇬🇧 English

### What is WGSmart?

WGSmart is a **WireGuard control-plane for power users** on macOS. The official WireGuard client keeps **one** tunnel up at a time. WGSmart keeps **several** up simultaneously and lets you decide — down to a single IP or subnet — **which traffic goes through which tunnel**.

It was born from a real need: two VPNs on two servers, both required at the same time. Route range A through VPN A and range B through VPN B — at once — or pin one specific IP to the exact tunnel you choose. That's the job the stock client won't do.

> **You bring your own WireGuard configs.** WGSmart is not a VPN service — it's the manager that makes your tunnels behave.

### ✨ Working now

Used every day on macOS by the person who wrote it.

- 🔀 **Many tunnels, all at once** — Each keeps its own `AllowedIPs`, connected in parallel rather than one-at-a-time.
- 🎯 **Route any address to any tunnel** — Pin an IP or CIDR to a specific tunnel. Longest prefix wins, so a `/32` overrides a full tunnel.
- 🛡️ **Kill switch that fails closed** — Built on `pf`. It snapshots your existing firewall rules and restores them on the way out, instead of trampling them.
- ⚠️ **Conflicts caught at import** — Overlapping ranges and a second full-tunnel config get flagged before they break your routing.
- 🧪 **Prove it is actually routing** — One click reports handshake age, round-trip, and the tunnel's exit IP next to your real public IP. A second check verifies every route against the kernel.
- 🌐 **Endpoints that move** — Hostname endpoints are re-resolved via `1.1.1.1` / `8.8.8.8` when they change, so a server on a dynamic address does not strand the tunnel.
- 📜 **Live logs, per tunnel and system-wide** — Streamed straight from the engine, filterable, exportable.
- 🎛️ **Menu bar and dashboard** — Throughput and handshake age at a glance; the full window when you need to change something.
- ⌨️ **A real CLI** — Every action in the app is also one command, over the same interface. Scriptable, JSON output.
- 🏗️ **Config Studio** — Author a server profile and its client configs, generate keys on-device, hand them out as files or QR codes.
- 🔐 **Keys stay in the Keychain** — Private keys live in the macOS Keychain, never in plaintext on disk.
- ✍️ **Updates you can verify** — Every release carries a SHA-256 and an Ed25519 signature, checked by the app and then independently again by the privileged service before anything installs. The signature binds the filename, so a downgrade fails closed, and the signing key has never been on GitHub.

### 🧪 Built, still being proven

Written, tested in isolation, and shipping in the build — but not yet run long enough on real machines to promise they work. Listed here rather than sold to you.

- 🌍 **Route by domain** — Resolves a domain and pins the addresses it returns. Best-effort by nature: apps using DoH/DoT or hard-coded IPs slip past it, and large CDNs return pools that shift. A routing convenience, **not a security control**.
- 👤 **Route by macOS user** — On macOS this matches the **user a process runs as, not the individual app**. Genuine per-application routing needs an Apple entitlement WGSmart does not have.
- 🔌 **Route by port** — Send a port or range down a chosen tunnel, TCP, UDP or both, matching on source or destination.
- 🧭 **DNS routing** — A local resolver that watches answers to pin routes more accurately. Present but **switched off by default**, because a resolver that misbehaves takes the whole machine's DNS with it.
- 📊 **Notification Center widget** — Tunnel status at a glance. **Read-only** — it shows state, it does not toggle tunnels.
- 📶 **Smart rules by Wi-Fi** — Auto-connect on untrusted networks, stand down on trusted SSIDs.
- 🐧 **Linux server hub** — A headless service with a browser UI, and **as of 1.0.2 it is downloadable** (signed, amd64 and arm64). It cross-compiles and its tests pass, but **it has not yet been run in production** — every `nft`, `ip` and cgroup call in it is exercised only by unit tests. See [Linux install](#linux-hub).
- 🪟 **Windows** — The engine compiles and its tests pass, and nothing more. There is no Windows app, routing by user and by port have no equivalent mechanism there yet, and it is **not offered as a download**.

### 🖼️ Screenshots

| Add a tunnel | Smart Rules | Connection test |
|---|---|---|
| ![Add a tunnel — import a .conf, conflicts flagged on the spot](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/screenshots/tunnels.png) | ![Smart Rules — per-IP routing overrides](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/smart-rules.svg) | ![Connection test — tunnel exit IP vs public IP](https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/connection-test.svg) |

<p align="center"><img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/ui/menubar.svg" width="340" alt="Menu-bar popover — live status and throughput" /></p>

### ⬇️ Download & Install

1. Grab the latest **`WGSmart-<version>.pkg`** from the [**Releases**](https://github.com/lyquyduong/WGSmart/releases) page.
2. Double-click the `.pkg`. It installs **WGSmart.app** to `/Applications` plus the background service the tunnels need — WireGuard on macOS cannot create tunnels or set routes without one.
3. Launch **WGSmart**, import your `.conf` files, and connect.

> **Requirements:** **macOS 15 or later** · Apple Silicon and Intel · administrator access, for the routing and kill-switch service.

#### macOS will warn you the first time. Here is exactly why.

WGSmart is **not yet notarized by Apple**. Notarization needs a paid Apple Developer membership this project does not have yet, so on first launch macOS says the developer cannot be verified. **That warning is accurate** — Apple has not checked this build.

To open it anyway: right-click the app ▸ **Open**, then confirm once. You should not need to repeat it for later updates.

If that is not a trade you want to make for a tool that runs with system privileges, that is a completely reasonable call — wait for the notarized build. It is the next thing being funded, and the goal is in the Support section below.

<a id="linux-hub"></a>

### 🐧 Linux server hub (Ubuntu, Debian, RHEL)

A different product from the Mac app: no GUI, no client. It turns a **server** into a WireGuard
hub — creates the TUN device, enables IPv4 forwarding, installs an nftables masquerade for the
tunnel subnet, and opens the listen port. Same core as the macOS daemon, under systemd.

> ⚠️ **This build has not been run in production by the author.** It cross-compiles and its tests
> pass; every `nft`, `ip` and cgroup call in it is covered only by unit tests. Try it on a server
> you can afford to break, not on one people depend on. We would rather say this than have you
> assume otherwise.

**Ubuntu / Debian**

```sh
sudo apt-get install -y iproute2 nftables

# Resolves the newest release, so this snippet never goes stale.
VER=$(curl -fsSI https://github.com/lyquyduong/WGSmart/releases/latest \
      | awk -F'/v' 'tolower($0) ~ /^location:/{print $2}' | tr -d '\r\n')
ARCH=$(uname -m); case "$ARCH" in x86_64) ARCH=amd64;; aarch64|arm64) ARCH=arm64;; esac
BASE="wgsmart-hub-${VER}-linux-${ARCH}.tar.gz"
URL="https://github.com/lyquyduong/WGSmart/releases/download/v${VER}"

curl -fLO "${URL}/${BASE}" && curl -fLO "${URL}/${BASE}.sha256"
sha256sum -c "${BASE}.sha256"          # must print: OK

tar xzf "$BASE"
sudo "wgsmart-hub-${VER}-linux-${ARCH}/install.sh"
```

On **RHEL / Fedora / Rocky** the only difference is the first line:
`sudo dnf install -y iproute nftables`.

That installs the binary to `/usr/local/bin/wgsmart-hub`, drops a systemd unit, creates
`/etc/wgsmart`, then enables and starts the service. Re-running it upgrades in place.

```sh
systemctl status wgsmart-hub
journalctl -u wgsmart-hub -f
```

Then export the hub's `.conf` from the Mac app's **Config Studio** and place it at
`/etc/wgsmart/wg0.conf` with mode `0600` — it contains the hub's private key.

Every tarball carries a full install guide in **English, Tiếng Việt and 中文**
(`INSTALL.md` · `INSTALL.vi.md` · `INSTALL.zh.md`), including the Ed25519 signature check, remote
management over TLS, uninstall, and troubleshooting.

> **Requirements:** Linux with systemd · `iproute2` and `nftables` on `PATH` · root.
> Uninstall with `sudo <dir>/uninstall.sh` (add `--purge` to drop config and state too).

#### Verify what you downloaded

```sh
shasum -a 256 WGSmart-<version>.pkg
```

Compare the result against the checksum published with the release. The in-app updater goes further: it checks the SHA-256 **and** an Ed25519 signature, and the privileged service re-checks both itself before installing anything. The signature binds the filename, so an older build cannot be replayed as a newer one — and the signing key has never been on GitHub, so a compromised account still cannot forge an update WGSmart will accept.

### 🗺️ Roadmap

**macOS first** (now) → **Linux server edition** with a remote browser UI (written, never run on a real Linux host) → **Windows** (the engine compiles for it; routing by user and by port have no equivalent mechanism there yet, and the app fails those calls honestly rather than pretending).

**Apple notarization is next.** It removes the first-launch warning entirely, and it is funded by donations — the goal is below. A desktop Tauri shell was considered and **dropped**: the Linux service's browser UI already covers that need. **iOS is intentionally parked** — Apple's networking framework allows one active tunnel at a time, which removes the entire reason WGSmart exists. **Not on the Mac App Store** either: the privileged service and firewall access WGSmart depends on are not permitted inside the App Store sandbox.

Model: a free, closed-source **Community Edition** + **Premium** + **Sponsor**. Releases are signed so you can verify them yourself.

### 💛 Support this project

**WGSmart is free — and staying that way.** If it saved you from juggling VPNs by hand, a small tip keeps it alive for everyone. No pressure. 🧡

> **First goal — the Apple Developer membership ($99/year).** It is the one thing standing between WGSmart and an install with no scary warning. Donations go to it first.

[**♥ Support**](https://ko-fi.com/nkcoder) &nbsp;·&nbsp; [**💡 Request a feature**](https://github.com/lyquyduong/WGSmart/issues) &nbsp;·&nbsp; [**🐛 Report a bug**](https://github.com/lyquyduong/WGSmart/issues) &nbsp;·&nbsp; [**⭐ Star the repo**](https://github.com/lyquyduong/WGSmart)

<!-- Before publishing, add the two QR images: assets/support/bank-vietqr.png and assets/support/momo-qr.png (kofi-qr.png is already in place). -->

| ☕ Ko-fi | 🏦 Bank transfer · VietQR | 📱 MoMo |
|:--:|:--:|:--:|
| <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/kofi-qr.png" width="150" alt="Ko-fi QR code" /> | <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/bank-vietqr.png" width="150" alt="Bank VietQR code" /> | <img src="https://raw.githubusercontent.com/lyquyduong/WGSmart/docs/assets/support/momo-qr.png" width="150" alt="MoMo QR code" /> |
| [ko-fi.com/nkcoder](https://ko-fi.com/nkcoder)<br><sub>Buy me a coffee · international</sub> | **LÝ QUÝ DƯƠNG**<br><code>9007041118966</code><br><sub>Timo · BVBank · napas 247</sub> | **LÝ QUÝ DƯƠNG**<br><sub>account&nbsp;·&nbsp;\*\*\*\*\*\*\*045</sub> |

---

<a id="-license"></a>

## 📄 License

WGSmart is distributed as **proprietary freeware** — free to use, not open source. This repository hosts the landing page and release downloads only; it does **not** contain the application source code.

<div align="center">
<sub>Made with ⚡ by <a href="https://github.com/lyquyduong">lyquyduong</a> · WGSmart — Securing the intelligence edge.</sub>
</div>
