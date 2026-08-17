#!/bin/sh
# WGSmart Linux hub installer.
#
#   curl -fsSL https://wgsmart.base101.app/installer.sh | sh
#
# Prefer to read it first — that is the honest way to run a script that installs a root service:
#
#   curl -fsSL https://wgsmart.base101.app/installer.sh -o installer.sh
#   less installer.sh && sh installer.sh
#
# Options (after `sh -s --` when piping):
#   --with-web    also enable the browser UI (loopback only; prints a one-time password)
#   --dry-run     print what would happen, change nothing
#   --tarball     force the tarball path even on Debian/Ubuntu
#
# ---------------------------------------------------------------------------------------------
# HOW THIS DECIDES WHAT TO TRUST
#
# Two paths, because they have genuinely different trust stories:
#
#   Debian/Ubuntu -> configure the APT repository and let apt install it. The repository is
#     GPG-signed and apt verifies every download against a signed Release file. That is stronger
#     than anything this script could do by hand, and it means upgrades keep working afterwards
#     through the operating system's own machinery instead of by re-running a curl pipe.
#
#   Everything else -> the signed tarball, discovered through the SIGNED update manifest, with
#     the Ed25519 signature checked before a single file is extracted.
#
# On the tarball path this script REFUSES to install if it cannot verify the signature, rather
# than falling back to "TLS looked fine". Ed25519 verification via the openssl CLI needs
# OpenSSL 3.x: 1.1.1's `pkeyutl` has no `-rawin` and its streaming verify API does not support
# Ed25519 at all (measured on Debian 11 / OpenSSL 1.1.1w). Systems that old are almost always
# Debian or Ubuntu, which take the apt path and are unaffected.
#
# Everything is wrapped in main() and only invoked on the LAST line. A truncated download — the
# classic failure of `curl | sh` — therefore defines some functions and does nothing at all.
# ---------------------------------------------------------------------------------------------
set -eu

SITE="https://wgsmart.base101.app"
MANIFEST_URL="${SITE}/updates.json"
APT_LIST="/etc/apt/sources.list.d/wgsmart.list"
APT_KEYRING="/usr/share/keyrings/wgsmart.gpg"
# Matches Models/UpdateConfig.swift and core/api/updatekey.go. Public half only.
PUBKEY_B64="2CmvIIJ1Xl9f2htN7QD1Qp+wuuLbEHfwwA49x+RmWEY="

WITH_WEB=0
DRY_RUN=0
FORCE_TARBALL=0

say()  { printf '%s\n' "$*"; }
info() { printf '\033[1;36m›\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }
run()  { if [ "$DRY_RUN" = 1 ]; then printf '    would run: %s\n' "$*"; else "$@"; fi; }

need() {
    for c in "$@"; do
        command -v "$c" >/dev/null 2>&1 || die "required command not found: $c"
    done
}

# ----- privilege ------------------------------------------------------------------------------
# Deliberately NOT documented as `curl … | sudo sh`: piping into a root shell means the thing
# running as root is a stream nobody can inspect. Run the script as yourself; it escalates only
# the individual commands that need it.
SUDO=""
setup_sudo() {
    # `[ … ] && return 0` looks equivalent and is not: as a NON-root user the test is false, the
    # list returns 1, and `set -e` kills the script — hitting exactly the people who follow the
    # recommended "run it as yourself" advice. A root-only test container never sees it.
    if [ "$(id -u)" = "0" ]; then return 0; fi
    if command -v sudo >/dev/null 2>&1; then SUDO="sudo"
    elif command -v doas >/dev/null 2>&1; then SUDO="doas"
    else die "this needs root and neither sudo nor doas is installed — re-run as root"
    fi
    info "Using $SUDO for the privileged steps"
}
sudo_run() { if [ "$DRY_RUN" = 1 ]; then printf '    would run: %s %s\n' "$SUDO" "$*"; else $SUDO "$@"; fi; }

# ----- platform detection ----------------------------------------------------------------------
detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)  ARCH=amd64 ;;
        aarch64|arm64) ARCH=arm64 ;;
        *) die "unsupported CPU architecture: $(uname -m). WGSmart publishes amd64 and arm64." ;;
    esac
}

detect_os() {
    [ "$(uname -s)" = "Linux" ] || die "this installer is for Linux. On macOS download the .pkg from ${SITE}"
    DISTRO=""; DISTRO_NAME="Linux"
    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        DISTRO="${ID:-}"
        DISTRO_NAME="${PRETTY_NAME:-${NAME:-Linux}}"
        LIKE="${ID_LIKE:-}"
    fi
    IS_DEB=0
    case " $DISTRO $LIKE " in *" debian "*|*" ubuntu "*) IS_DEB=1 ;; esac
    # ID_LIKE is advisory and some derivatives omit it; dpkg's presence is the real test.
    #
    # Written as an `if`, not `command -v dpkg && command -v apt-get && IS_DEB=1`. Under `set -e`
    # that one-liner ABORTS THE WHOLE SCRIPT on any system without dpkg — i.e. on precisely the
    # systems the tarball path exists for. Caught on Fedora, where the installer exited silently
    # with status 1 before printing a single line.
    if command -v dpkg >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
        IS_DEB=1
    fi
}

# ----- apt path ---------------------------------------------------------------------------------
install_via_apt() {
    info "Debian-family system detected — installing from the APT repository"
    need curl
    sudo_run install -d -m 0755 /usr/share/keyrings /etc/apt/sources.list.d

    info "Adding the repository signing key → ${APT_KEYRING}"
    if [ "$DRY_RUN" = 1 ]; then
        say "    would run: curl -fsSL ${SITE}/apt/wgsmart.gpg | $SUDO tee ${APT_KEYRING}"
    else
        tmpkey="$(mktemp)"
        curl -fsSL "${SITE}/apt/wgsmart.gpg" -o "$tmpkey" \
            || die "could not download the repository key from ${SITE}/apt/wgsmart.gpg"
        [ -s "$tmpkey" ] || die "the repository key downloaded empty"
        $SUDO install -m 0644 "$tmpkey" "$APT_KEYRING"
        rm -f "$tmpkey"
    fi

    info "Adding the repository → ${APT_LIST}"
    line="deb [signed-by=${APT_KEYRING}] ${SITE}/apt stable main"
    if [ "$DRY_RUN" = 1 ]; then
        say "    would write: ${line}"
    else
        printf '%s\n' "$line" | $SUDO tee "$APT_LIST" >/dev/null
    fi

    info "apt-get update"
    sudo_run apt-get update
    info "apt-get install wgsmart-hub"
    sudo_run apt-get install -y wgsmart-hub
}

# ----- tarball path -------------------------------------------------------------------------------
# Discover through the SIGNED manifest so there is exactly one source of truth for "what is
# current" — the same document the macOS app reads. A version baked into this script would be a
# second one, and it would be wrong the day after a release.
fetch_manifest() {
    need curl
    MF="$WORK/updates.json"
    curl -fsSL "${MANIFEST_URL}?cb=$$" -o "$MF" || die "could not fetch ${MANIFEST_URL}"
    curl -fsSL "${MANIFEST_URL}.sig?cb=$$" -o "$MF.sig" \
        || die "could not fetch the manifest signature (${MANIFEST_URL}.sig).
   Refusing to continue: without it nothing here can be authenticated."
    verify_sig "$MF" "$MF.sig" "updates.json" \
        || die "the update manifest failed signature verification.
   Someone may be tampering with the download, or the site is mid-deploy. Not installing."
    info "Manifest signature verified"
}

# Verify WGSmart's Ed25519 scheme:
#   signature over SHA256("wgsmart-update-v1\n" + basename + "\n" + sha256hex + "\n")
# The basename is inside the signed digest, which is what stops a signature for one artifact
# being replayed for another — including replaying a .pkg signature onto the manifest.
#
# The binary handling is done in python3 rather than shell. The first version used
# `xxd -r -p` with an od/sed/xargs fallback, which produced WRONG BYTES on any system without
# xxd — Fedora, for one, since xxd lives in vim-common. The signature then failed to verify on a
# perfectly good download, which is the worst possible failure for a security check: it cries
# wolf, and the obvious "fix" a user reaches for is to stop verifying. python3 is already a hard
# requirement on this path for reading the manifest, so this adds no new dependency and removes
# two fragile ones.
verify_sig() {
    _file="$1"; _sigfile="$2"; _name="$3"
    python3 - "$_file" "$_name" "$PUBKEY_B64" "$WORK" <<'PY' || return 1
import base64, hashlib, pathlib, sys
art, name, pub_b64, work = sys.argv[1], sys.argv[2], sys.argv[3], pathlib.Path(sys.argv[4])
h = hashlib.sha256()
with open(art, "rb") as f:
    for chunk in iter(lambda: f.read(1 << 20), b""):
        h.update(chunk)
canonical = f"wgsmart-update-v1\n{name}\n{h.hexdigest()}\n".encode()
# The signed MESSAGE is the 32-byte SHA-256 of that canonical string, not the string itself.
(work / "msg.bin").write_bytes(hashlib.sha256(canonical).digest())
raw = base64.b64decode(pub_b64)
if len(raw) != 32:
    sys.exit("public key is not 32 bytes")
# Raw Ed25519 key -> SubjectPublicKeyInfo DER. The prefix is the fixed algorithm header.
(work / "pub.der").write_bytes(bytes.fromhex("302a300506032b6570032100") + raw)
PY
    python3 -c 'import base64,sys,pathlib
sig = pathlib.Path(sys.argv[1]).read_text().strip()
pathlib.Path(sys.argv[2]).write_bytes(base64.b64decode(sig))' "$_sigfile" "$WORK/sig.bin" \
        || return 1
    openssl pkey -pubin -inform DER -in "$WORK/pub.der" -out "$WORK/pub.pem" 2>/dev/null \
        || return 1
    openssl pkeyutl -verify -pubin -inkey "$WORK/pub.pem" -rawin \
        -in "$WORK/msg.bin" -sigfile "$WORK/sig.bin" >/dev/null 2>&1
}

sha256_of() {
    if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1
    else shasum -a 256 "$1" | cut -d' ' -f1; fi
}

# Pull one string field out of the manifest without requiring jq. Deliberately narrow: it reads
# our own generated file, which is emitted by json.dump with sorted keys and no nesting tricks.
mf_field() {
    _plat="$1"; _key="$2"
    python3 - "$MF" "$_plat" "$_key" 2>/dev/null <<'PY' || return 1
import json, sys
d = json.load(open(sys.argv[1]))["channels"]["stable"]
p = d["platforms"].get(sys.argv[2])
if not p: sys.exit(1)
print(d["version"] if sys.argv[3] == "@version" else p[sys.argv[3]])
PY
}

install_via_tarball() {
    info "Installing from the signed tarball"
    need curl openssl tar
    command -v python3 >/dev/null 2>&1 \
        || die "python3 is required to read the update manifest on this path.
   On Debian/Ubuntu the apt path needs none of this — re-run without --tarball."
    openssl pkeyutl -help 2>&1 | grep -q -- -rawin || die \
"this system's openssl cannot verify Ed25519 signatures (needs OpenSSL 3.x; found $(openssl version)).
   Refusing to install something it cannot check.
   On Debian/Ubuntu use the apt path instead: re-run this script without --tarball."

    fetch_manifest
    PLAT="linux-${ARCH}"
    VER="$(mf_field "$PLAT" @version)"   || die "the manifest advertises no ${PLAT} build"
    FN="$(mf_field "$PLAT" filename)"    || die "the manifest advertises no ${PLAT} build"
    URL="$(mf_field "$PLAT" url)"
    WANT_SHA="$(mf_field "$PLAT" sha256)"
    SIG_B64="$(mf_field "$PLAT" signature)"
    info "Latest is ${VER} (${PLAT})"

    info "Downloading ${FN}"
    run curl -fsSL "$URL" -o "$WORK/$FN"
    # `[ … ] && { …; }` would return 1 when the test is false, and under `set -e` that aborts.
    if [ "$DRY_RUN" = 1 ]; then say "    would verify + install"; return 0; fi

    GOT_SHA="$(sha256_of "$WORK/$FN")"
    [ "$GOT_SHA" = "$WANT_SHA" ] \
        || die "checksum mismatch: expected ${WANT_SHA}, got ${GOT_SHA}. Not installing."
    printf '%s' "$SIG_B64" > "$WORK/$FN.sig"
    verify_sig "$WORK/$FN" "$WORK/$FN.sig" "$FN" \
        || die "signature verification FAILED for ${FN}. Not installing."
    info "Signature verified"

    tar -xzf "$WORK/$FN" -C "$WORK"
    DIR="$WORK/$(basename "$FN" .tar.gz)"
    [ -x "$DIR/install.sh" ] || die "the tarball does not contain install.sh — refusing to guess"
    if [ "$WITH_WEB" = 1 ]; then sudo_run "$DIR/install.sh" --with-web
    else sudo_run "$DIR/install.sh"; fi
}

# ----- main ---------------------------------------------------------------------------------------
main() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --with-web) WITH_WEB=1 ;;
            --tarball)  FORCE_TARBALL=1 ;;
            --dry-run)  DRY_RUN=1 ;;
            -h|--help)
                sed -n '2,20p' "$0" 2>/dev/null || say "see ${SITE}"
                exit 0 ;;
            *) die "unknown option: $1" ;;
        esac
        shift
    done

    detect_os
    detect_arch
    say ""
    info "WGSmart hub installer — ${DISTRO_NAME} (${ARCH})"
    if [ "$DRY_RUN" = 1 ]; then warn "dry run: nothing will be changed"; fi
    setup_sudo

    WORK="$(mktemp -d)"
    trap 'rm -rf "$WORK"' EXIT INT TERM

    if [ "$IS_DEB" = 1 ] && [ "$FORCE_TARBALL" = 0 ]; then
        install_via_apt
    else
        install_via_tarball
    fi

    if [ "$DRY_RUN" = 1 ]; then say ""; info "dry run complete — nothing was changed"; return 0; fi

    # The hub does not start on a fresh install: with no server config it would fail on every
    # restart, and a service flapping in the journal is worse than one that is honestly stopped.
    say ""
    say "✓ WGSmart hub installed."
    say ""
    say "  Next: drop your hub config at /etc/wgsmart/wg0.conf (mode 0600), then"
    say "      ${SUDO} systemctl start wgsmart-hub"
    say ""
    if [ "$WITH_WEB" = 1 ] && [ "$IS_DEB" = 1 ]; then
        say "  You asked for the browser UI. On the apt path it is one more command:"
        say "      ${SUDO} wgsmart-webui-enable"
        say ""
    fi
    say "  Guides: /usr/share/doc/wgsmart-hub/  (INSTALL.md · WEBUI.md — EN, Tiếng Việt, 中文)"
    say "  This build has not been run in production by the author. Read INSTALL.md before"
    say "  putting it on a machine that matters."
    say ""
}

# Called last, on purpose: a truncated download cannot reach this line.
main "$@"
