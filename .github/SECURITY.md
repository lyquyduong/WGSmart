# Security policy

WGSmart installs a background service that runs with system privileges, and it manages
private keys. Security reports are handled ahead of everything else.

## Reporting a vulnerability

**Do not open a public issue.** Use either:

- **GitHub private vulnerability reporting** —
  [report an advisory](https://github.com/lyquyduong/WGSmart/security/advisories/new)
- **Email** — <wgsmart@solutions101.org>

Please include: the WGSmart version, your macOS version, what an attacker can achieve, and
the steps to reproduce it. Proof-of-concept code is welcome. Write in English, Tiếng Việt
or 中文.

**What to expect:** an acknowledgement within 3 working days, and an assessment within 14
days. If a fix is warranted you will be told when the release is planned, and credited in
the release notes unless you would rather not be. This is a single-maintainer project, so
please allow reasonable time before disclosing publicly.

## In scope

- The privileged background service, and anything that lets an unprivileged process reach
  it or influence what it does
- The update path — installing an artifact that should have been rejected, including
  substituting a different or older signed build
- Private key handling: extraction from the Keychain, exposure in logs, on disk, or over
  the wire
- The kill switch failing open — traffic leaving outside the tunnel when it should be
  blocked
- Routing rules sending traffic somewhere other than where they say
- The hub's remote interface (TLS, mTLS, tokens) and the browser interface, when enabled

## Known limitations — please do not report these as vulnerabilities

These are documented, deliberate properties rather than defects:

- **Builds are not yet notarized by Apple.** macOS warns on first launch, and that warning
  is accurate. Notarization requires a paid membership the project does not have yet.
- **Routing by domain is best-effort.** Applications using DoH/DoT or hard-coded addresses
  bypass it, and large CDNs return address pools that change. It is a routing convenience,
  not a security control.
- **Routing by "app" on macOS matches the user a process runs as, not the individual
  application.** Genuine per-application routing needs an Apple entitlement WGSmart does
  not have. It is described as per-user for that reason.
- **Linux and Windows are not shipped.** The code cross-compiles and its tests pass, but it
  has never run against a real kernel on either platform.
- **The DNS proxy is switched off by default** and is not part of a default install.
- **The source code is not public.** WGSmart is proprietary freeware; releases carry a
  SHA-256 and an Ed25519 signature instead.

## Supported versions

Only the latest release receives security fixes. WGSmart requires macOS 15 or later.
