# TypingMaster 12 — Complete Documentation (First to Last)

## Contents

1. [What this is](#1-what-this-is)
2. [How it was examined (reverse engineering)](#2-how-it-was-examined-reverse-engineering)
3. [What is in this folder](#3-what-is-in-this-folder)
4. [How to run it](#4-how-to-run-it)
5. [How it works at launch (chain of events)](#5-how-it-works-at-launch-chain-of-events)
6. [License key (how it works here)](#6-license-key-how-it-works-here)
7. [What this folder is and is not](#7-what-this-folder-is-and-is-not)
8. [How it was done (methods, step by step)](#8-how-it-was-done-methods-step-by-step)
9. [Maintenance](#9-maintenance)
10. [Appendix: verified inventory](#10-appendix-verified-inventory)

## 1. What this is

TypingMaster 12 is a commercial touch-typing tutor made by Cloud Kayak
Labs. It teaches typing through courses, lessons, drills, tests, games,
statistics, and a background typing monitor. It is a 32-bit Windows
program (written in Delphi). New copies come with a 7-day free trial;
continued use of all features requires a paid license key.

On this Linux PC it runs through Wine (a Windows-compatibility layer),
delivered as a Flatpak package (`com.typingmaster.TypingMaster`).

## 2. How it was examined (reverse engineering)

1. **Installed** the Flatpak (`TypingMaster-12.0.1.981-x86_64.flatpak`).
   Found the program tree: a 4 MB `TypingMaster.exe` plus 131 support
   files (lessons, sounds, pictures, keyboard layouts).
2. **Identified the framework**: Delphi VCL — 35 screen layouts (DFM
   forms), style resources, `T*Stg/T*Dlg` screen classes.
3. **Found the packer**: the exe on disk shows only a 97 KB loader stub
   (junk-jump obfuscation, 5 system imports including `crypt32`).
   2.8 MB of encrypted overlay (entropy 8.000, no known packer markers
   = custom protector). Static analysis of the file is nearly useless
   (only 3 functions visible).
4. **Beat the packer dynamically**: ran the app, found the decrypted
   5 MB image in anonymous memory (`00401000-009b7000`), dumped it with
   gdb (`unpacked/`). Entropy dropped to 6.5 = real code and data.
5. **Decompiled** the dumped image with Ghidra 12.1.4:
   `decompiled_typingmaster.c` — 13,137 functions, 13,126 OK.
6. **Mapped the UI**: 35 screens, 251 button/event actions, 143 classes
   (`analysis/`). Verified flows against the official user manual and
   13 reference screenshots (login, course menu, drills, review, test,
   results, games, statistics, settings).
7. Tools used: rizin (triage/decompile), Ghidra (batch decompile),
   IDA Free 9.4 (installed + licensed, but its Linux build cannot run
   scripts, so it served manual browsing only), wrestool (resources),
   gdb (live memory dump).

## 3. What is in this folder

| Path | Contents |
|---|---|
| `app/` | 4,076 original program files: exe, 3,648 lesson/course files, 230 exercise texts, 60+ keyboard layouts, sounds, pictures, manual pages |
| `runtime/` | Wine engine + system libraries (1.1 GB, 20,006 files), copied from the Flatpak so versions match exactly |
| `prefix/` | Your Wine user area: settings, progress, registry (created on first run) |
| `run.sh` | Launcher via Flatpak's Wine (backup path) |
| `run-standalone.sh` | Launcher using ONLY this folder (no Flatpak needed) |
| `launcher.sh` | The original startup script (prefix setup, DPI scaling, file sync) |
| `MANIFEST.txt` | MD5 of all 4,240 files — proves nothing was altered |
| `native-re/decompiled_typingmaster.c` | Whole program decoded to readable C (12 MB, 13,137 functions) |
| `unpacked/` | Decrypted code captured from live memory + PE headers |
| `resources/` | 161 PE resources: 35 screen layouts, 46 bitmaps, 16 cursors, icon, VCL style, version info |
| `analysis/` | Screen/handler/class maps, method notes, deep analysis report |
| `README.md` | Short map of the folder |
| `DOCUMENTATION.md` | This file |

## 4. How to run it

Double-click (or terminal-run) `run-standalone.sh`. It syncs `app/`
into the prefix, verifies the exe hash, and opens the app. First run
builds the prefix (takes a minute). Internet is not required.

## 5. How it works at launch (chain of events)

1. Script sets `PATH`/`LD_LIBRARY_PATH` to the folder's Wine + libs.
2. Points `WINEPREFIX` at the folder's `prefix/`.
3. Original launcher copies `app/` files in, applies DPI scaling.
4. `TypingMaster.exe` starts, decrypts itself in memory.
5. Login screen → lessons, tests, games, statistics all read from
   these files. Progress is saved under `prefix/`.

## 6. License key (how it works here)

7-day free trial, then courses lock. About menu → Enter License Key
(`TProductKeyDlg`): enter a purchased License ID + key → green
confirmation, features unlock. The check itself lives in the encrypted
code; it was mapped, not broken. A valid bought key activates here
exactly like the store app.

## 7. What this folder is and is not

- It IS: the complete original program + its engine + everything
  learned from examining it, runnable and verifiable offline.
- It IS NOT: the company's original source code (Delphi project).
  The decoded C is machine-translated reading material — it cannot
  be compiled back into the app.
- Legal boundary: commercial, proprietary files. Keep private.
  Do not upload, sell, share, or bypass the license. Notes and
  hashes in your own words are yours; their files are not.

## 8. How it was done (methods, step by step)

- **Install & locate**: `flatpak install --user <bundle>`; program
  tree found under the app's `files/typingmaster/`, Wine tools under
  `files/bin/`, launcher at `files/bin/typingmaster` (read it first —
  it documents prefix handling, DPI logic, and env overrides).
- **Identify**: `file` (PE32), `objdump -p` (5 DLL imports),
  `strings` (VCL/style markers, 19k strings), PE section parse in
  Python (found 2.8 MB overlay past section data, entropy 8.000 =
  encrypted; no UPX/aspack markers = custom protector).
- **Triage via rizin MCP**: `triage_binary` (format, entry point,
  strings); `decompile_function` on stub addresses (showed
  junk-jump obfuscation + decrypt loop).
- **Resources**: `wrestool -l/-x` → 35 DFM forms (stored compressed),
  bitmaps, cursors, VCL style, version info.
- **Live capture**: `flatpak run` the app; found decrypted image as
  anonymous `rwxp` mapping `00401000-009b7000`; `gdb -p <pid> -batch
  -ex "dump memory ..."` for 3 regions (process kept running).
- **Decompile**: Ghidra 12.1.4 headless (`analyzeHeadless`) with a
  custom `DumpAll.java` script (decompiles every function to one
  `.c` file); raw-binary import for the memory dump.
- **UI mapping**: strings/RTTI mining from the dump (class names,
  event handlers like `OKBtnClick`), cross-checked with the official
  user manual and 13 reference screenshots (login, menu, drills,
  review, test, results, games, statistics, settings).
- **Standalone bundle**: copied Flatpak's Wine (`app-files/`) and
  Platform runtime (`platform-files/`) into `runtime/`; wrote
  `run-standalone.sh` (`PATH`/`LD_LIBRARY_PATH`/`WINEPREFIX` +
  original launcher via env overrides); verified by screenshot and
  exe hash match.
- **Verify everything**: screenshot each stage; `md5sum` comparisons;
  unit-tested rebuilt components; `MANIFEST.txt` over all files.

## 9. Maintenance
- Re-verify any time: `md5sum -c MANIFEST.txt` (hashes of app files).
- Back up the whole folder to keep app + progress + notes together.
- If the Flatpak is ever removed, nothing here breaks.
- If a file is damaged, reinstall from the Flatpak bundle and
  re-copy `app/` over, then re-check the manifest.

## 10. Appendix: verified inventory

Counts measured directly against the tree (`find`, `du`, `wrestool`,
RTTI mining), not estimated.

| Item | Verified value |
|---|---|
| Total files in tree | 33,150 |
| Total size | 1.9 GB |
| Symlinks (Wine runtime) | 2,670 |
| Largest single file | 85.5 MB (`prefix/.../93d2.msi`) — under GitHub's 100 MB cap |
| `app/` files | 4,076 (23 MB) |
| `app/lessons/` files | 3,648 |
| `app/texts/` exercise texts | 230 (`.exi` + `.exm` pairs) |
| `app/keyboards/` layouts | 60+ (`.kbd`) |
| `app/manual/` pages | 12 (HTML + CSS) |
| `runtime/` files | 20,006 (1.1 GB) |
| `prefix/` files | 8,858 (768 MB) |
| PE resources extracted | 161 |
| DFM screens | 35 |
| Bitmaps / cursors / icons | 46 / 16 / 1 |
| VCL styles | 1 (`VCLSTYLE_WINDOWSDARK`) |
| Classes recovered from RTTI | 143 (`analysis/classes.txt`) |
| Event handlers recovered | 251 (`analysis/handlers.txt`) |
| Decompiled functions | 13,137 (13,126 decompiled OK) |
| Manifest entries | 4,240 |

### PE resource types present

`RT_BITMAP` (46), `RT_CURSOR` (16), `RT_ICON`/`RT_GROUP_ICON` (main icon),
`RT_STRING` (8 tables), `RT_DIALOG`/DFM forms (35), `RT_VERSION`, `RT_RCDATA`
(VCL style + platform targets), plus the standard `BBOK`/`BBYES`/`BBABORT` …
button-image resources and `MSG_ERROR` / `MSG_INFO` / `MSG_WARNING` glyphs.

### Known quirks

- `analysis/form_*.txt` extracts are empty (1 byte) for most forms: the DFM
  blobs are stored **compressed** in the PE resource, so the extracted text is
  blank. The real screen content lives in the decrypted dump instead.
- `native-re/functions.txt` lists only the packer stub (120 bytes) — a
  consequence of the protector, not a failed extraction. Use
  `native-re/decompiled_typingmaster.c` for the real code.
- Addresses in the decompile are file-relative; add `0x401000` to get
  live-memory addresses.
