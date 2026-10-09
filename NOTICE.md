# NOTICE — Third-party attribution

This repository combines the author's own reverse-engineering analysis with
redistributed third-party software. This file records the provenance of each
part. It does not grant any license.

## 1. Analyzed target (proprietary)

**TypingMaster 12.0.1.981** — 32-bit Windows application, Delphi VCL.
Copyright of the respective rights holder (the product is commercial and
proprietary). Present here under `app/` and, as installed state, under
`prefix/`. No rights are granted to this software. Do not redistribute.

The decompilation under `native-re/` and the memory dumps under `unpacked/`
are derived works of the above and inherit the same restrictions.

## 2. Wine

`runtime/app-files/` contains a build of **Wine** (the Windows compatibility
layer), including `wine`, `winecfg`, `wineserver`, the Win32/Win64 DLLs and
support libraries.

- Project: https://www.winehq.org/
- License: **GNU Lesser General Public License v2.1 or later (LGPL-2.1-or-later)**
- License texts are included within the runtime directory.

Wine is distributed unmodified. It is used only to execute the target
application on Linux.

## 3. Freedesktop SDK / Flatpak platform runtime

`runtime/platform-files/` contains libraries and utilities from the
**Freedesktop SDK** (the Flatpak platform runtime), including glibc, GnuTLS,
ICU, PipeWire, fontconfig, OpenSSL and others.

Each component is licensed by its own upstream project (commonly LGPL-2.1+,
MIT, BSD, or GPL-2.0+). Original license files ship with the runtime.

## 4. Why the runtimes are bundled

The runtime trees are included so the application remains runnable offline,
with exactly the versions it was delivered against. They are **not** authored
by the maintainer and are subject to their upstream licenses, not to this
repository's terms.

## 5. Author's own work

The following are original work by the maintainer and are covered by
`LICENSE` (All Rights Reserved):

- `README.md`, `DOCUMENTATION.md`, `CHANGELOG.md`, `CONTRIBUTING.md`,
  `SECURITY.md`, `CODE_OF_CONDUCT.md`
- `launcher.sh`, `run.sh`, `run-standalone.sh` (annotations and standalone
  wrapper; the launcher logic itself originates from the Flatpak package)
- `analysis/` maps and reports
- `MANIFEST.txt` (hashes and their presentation)
