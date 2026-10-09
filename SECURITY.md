# Security Policy

## About this repository

This is a **private research repository** containing a reverse-engineering
study of a third-party Windows application, together with the Wine runtime used
to run it. It is not a deployed service and it does not accept untrusted input.

## Reporting a vulnerability

If you believe you have found a security problem in **this repository's own
content** — for example in the launcher scripts (`launcher.sh`, `run.sh`,
`run-standalone.sh`) or in the analysis tooling — please report it privately.

- **Preferred:** open a private security advisory via
  **Security → Advisories → Report a vulnerability** on GitHub.
- **Alternative:** contact the maintainer directly at
  [@NurMohammadDuari](https://github.com/NurMohammadDuari).

Please do **not** open a public issue for security matters.

### What to include

- A description of the problem and its impact.
- Steps to reproduce, or the exact file and line involved.
- Any suggested fix, if you have one.

### What to expect

- Acknowledgement as soon as reasonably possible.
- An assessment and, where warranted, a fix with credit if you wish.

## Out of scope

The following are **not** in scope for this repository:

- Vulnerabilities in **TypingMaster** itself — those belong with the product's
  vendor, not here.
- Vulnerabilities in **Wine** or the **Freedesktop/Flatpak runtime** — report
  those to the respective upstream projects (https://www.winehq.org/,
  https://gitlab.freedesktop.org/). The copies here are unmodified.
- Any request to bypass, crack, or defeat the product's licence check. Such
  requests will be declined; see `CONTRIBUTING.md`.

## Handling of the bundled runtimes

`runtime/` ships Wine and platform libraries **unmodified** so the target
application runs with the versions it was delivered against. These are not
maintained here; security fixes for them must come from upstream.

## Secrets

Do not commit credentials of any kind. If you spot a secret in the history,
report it privately so it can be rotated and purged.
