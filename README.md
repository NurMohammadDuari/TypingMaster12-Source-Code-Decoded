# TypingMaster 12.0.1.981 — Reversed Source Tree

Complete working copy, reverse-engineering artifacts and documentation for
**TypingMaster 12.0.1.981** (x86, 32-bit Windows / Delphi VCL), as delivered in
the Flatpak package `com.typingmaster.TypingMaster`.

> **Status:** runnable and fully documented offline. Private repository — the
> program files are commercial and proprietary, so this tree is not licensed
> for redistribution.

---

## What is in here

| Path | Size | Files | Contents |
|---|---:|---:|---|
| `app/` | 23 MB | 4,076 | Original program tree: `TypingMaster.exe`, 3,648 lesson/course files, 115 exercise texts, 60+ keyboard layouts, sounds, images, manuals, INI/config |
| `runtime/` | 1.1 GB | 20,006 | Wine engine + platform system libraries, copied from the Flatpak so versions match exactly |
| `prefix/` | 768 MB | 8,858 | Wine user area: registry, settings, saved progress (created/updated on first run) |
| `native-re/` | 12 MB | 3 | Ghidra decompilation of the unpacked image — `decompiled_typingmaster.c` (13,137 functions) |
| `unpacked/` | 5.8 MB | 3 | Live-memory dump of the decrypted code + PE headers (see *Key finding* below) |
| `resources/` | 3.9 MB | 161 | PE resources extracted with `wrestool`: 35 DFM forms, 46 bitmaps, 16 cursors, icon, VCL style, version info |
| `analysis/` | 152 KB | 37 | Class map, event-handler map, per-form extracts, deep analysis report |
| `MANIFEST.txt` | 284 KB | — | MD5 of all 4,240 original files — proves nothing was altered |

Top-level scripts:

| Script | Purpose |
|---|---|
| `run-standalone.sh` | **Run the app from this folder only** — no Flatpak required |
| `run.sh` | Run through the Flatpak's Wine (backup path) |
| `launcher.sh` | The original Flatpak launcher (prefix setup, DPI scaling, file sync) |

Documentation:

| File | Contents |
|---|---|
| `DOCUMENTATION.md` | Full write-up: what it is, how it was examined, how it works, legal boundary |
| `analysis/ANALYSIS-DEEP.md` | Detailed technical analysis of the decompiled code, data formats and screens |
| `README.md` | This file |
| `CHANGELOG.md` | Version history |
| `CITATION.cff` | Citation metadata |

Repository policy and metadata:

| File | Purpose |
|---|---|
| `LICENSE` | All Rights Reserved + third-party component notes |
| `NOTICE.md` | Upstream attribution (TypingMaster, Wine, Freedesktop runtime) |
| `CONTRIBUTING.md` | Contribution rules — including the ban on licence-bypass changes |
| `CODE_OF_CONDUCT.md` | Contributor Covenant v2.1 |
| `SECURITY.md` | How to report a problem privately |
| `.github/` | Issue templates, PR template, `CODEOWNERS`, manifest-verification workflow |
| `.gitattributes` | Line-ending protection + Linguist settings |
| `.gitignore` | Keeps transient Wine/runtime junk out |

---

## Key finding: the executable is packed

`app/TypingMaster.exe` is a 4 MB PE32 that carries only a **97 KB loader stub**
on disk:

* junk-jump obfuscation, just 5 DLL imports (including `crypt32`);
* 2.8 MB encrypted overlay past the section table — **entropy 8.000**, no UPX /
  ASPack / any known packer marker ⇒ a **custom protector**;
* static disassembly of the file is useless: only **3 functions** are visible.

Real code (6.6 MB virtual) plus all resources are decrypted at run time.

## Method: live memory dump

Rather than fight the protector statically, the running application was
inspected:

1. `flatpak run com.typingmaster.TypingMaster` → window "Typing Master 12".
2. Decrypted image located in an anonymous `rwxp` mapping `00401000-009b7000`
   (5 MB).
3. `gdb -p <pid> -batch -ex "dump memory ..."` — 3 regions, process kept running.
4. Result in `unpacked/`:
   * `code_401000.bin` — 5.9 MB, entropy drops **8.000 → 6.5** = real code
   * `headers_400000.bin` — PE headers
   * `data_a63000.bin` — data segment

That dump was then decompiled with **Ghidra 12.1.4 headless**
(`native-re/decompiled_typingmaster.c` — 13,137 functions, 13,126 OK).

> **Address mapping:** addresses inside `decompiled_typingmaster.c` are
> *file-relative*. Live-memory address = file offset **+ 0x401000**.

## Application shape

* **Framework:** Delphi VCL — 35 DFM screens, VCL styles (`VCLSTYLE_WINDOWSDARK`),
  `T*Stg` / `T*Dlg` class naming convention.
* **143 classes** recovered from RTTI — `analysis/classes.txt`
  (e.g. `TCourseViewStg`, `TBubbleStg`, `TTrisStgFrm`, `TStatisticsStg`,
  `TProductKeyDlg`, `TAnimateThread`).
* **251 event handlers** recovered from RTTI — `analysis/handlers.txt`
  (`OKBtnClick`, `LicenseBtnClick`, `FormShow`, `RaceTimer`, …).
* **35 screens**, grouped in `analysis/ANALYSIS-DEEP.md`.

### Screen inventory (35 DFM forms)

| Area | Forms |
|---|---|
| Startup / shell | `TSPLASH`, `TWELCOMESTG`, `TLOGONFRM`, `TLOGINVIEWSTG`, `TLOGFORM` |
| Courses / lessons | `TCOURSEVIEWSTG`, `TCOURSELISTVIEWSTG`, `TLESSONVIEWSTG`, `TBOOKFORMEX`, `TPREVIEWFORM`, `TDEMOVIEWSTG` |
| Tests & typing | `TTESTVIEWSTG`, `TCUSTOMIZETESTFORM`, `TBUILDERSTG`, `TCHOOSEAPPLICATIONS` |
| Results | `TRESULTVIEWSTG`, `TTEXTRESULTVIEWSTG`, `TREVIEWRESULTVIEWSTG`, `TTOPTENVIEWSTG`, `TSTATISTICSSTG` |
| Games | `TGAMESSTG`, `TBUBBLESTG`, `TTRISSTGFRM` |
| Review / analysis | `TREVIEW…`, `TBIGRAMDETAILFORM`, `TFRMBIGRAMHEATMAP`, `TWRONGKEYBOARDVIEWSTG` |
| Satellite (multi-seat) | `TSATELLITESTG`, `TSATELLITESTATSTG`, `TSATELLITEWIZSTG` |
| Options / dialogs | `TOPTIOSTG`, `TPRODUCTKEYDLG`, `TABOUTSTORAGE`, `TCLOSEDLG`, `TMYMSGFORM`, `TLOGFORM`, `TEVENTSSTG` |

---

## Running it

```sh
./run-standalone.sh
```

It points `PATH` / `LD_LIBRARY_PATH` at this folder's Wine, sets `WINEPREFIX`
to `prefix/`, syncs `app/` in, verifies the exe hash and starts the program.
First run builds the prefix (about a minute). No internet needed.

### Verify integrity

```sh
md5sum -c MANIFEST.txt
```

---

## Tools used

| Tool | Used for |
|---|---|
| `file`, `objdump -p`, `strings`, Python PE parser | Identifying format, imports, overlay, entropy |
| rizin (MCP) | Triage: format, entry point, strings, stub decompilation |
| Ghidra 12.1.4 headless | Batch decompilation of the dumped image (custom `DumpAll.java`) |
| `wrestool` | Extracting PE resources (DFM forms, bitmaps, cursors, style, version) |
| `gdb` / `gcore` | Live memory dump of the decrypted image |
| Flatpak + Wine | Running the application |

IDA Free 9.4 was installed and licensed, but its Linux build cannot run scripts,
so it served for manual browsing only.

---

## Contributing

**Community help is welcome** — reports, analysis corrections, cross-distro
testing, documentation, translations and tooling.

- Start with [`CONTRIBUTING.md`](CONTRIBUTING.md) — it lists every way to help.
- See [`docs/COMMUNITY.md`](docs/COMMUNITY.md) for the most-needed tasks.
- Good starting points are issues labelled **`good first issue`** and
  **`help wanted`**.
- Questions and results go in
  [Discussions](https://github.com/NurMohammadDuari/TypingMaster-Source/discussions).

## Legal

The program, its lessons, sounds, images and the decoded listing are the
property of the respective copyright holder. This repository exists for private
study and verification. Do not redistribute, sell, or use it to bypass licensing.
