# Changelog

All notable changes to this repository are recorded here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-10-09

First complete release. The full tree is published.

### Added

- **Program tree** (`app/`, 4,076 files): `TypingMaster.exe`, 3,648
  lesson/course files, 230 exercise texts, 60+ `.kbd` keyboard layouts,
  sounds, images and manual pages.
- **Wine runtime** (`runtime/`, 20,006 files): engine + platform libraries,
  copied from the Flatpak so versions match exactly; enables the offline
  standalone launcher.
- **Wine prefix** (`prefix/`, 8,858 files): registry, settings and saved
  progress.
- **Memory dump** (`unpacked/`): decrypted code image, PE headers and data
  segment recovered live from the running process.
- **Decompilation** (`native-re/decompiled_typingmaster.c`): 12.2 MB,
  13,137 functions from the unpacked image.
- **PE resources** (`resources/`, 161 items): 35 DFM screens, 46 bitmaps,
  16 cursors, icon, VCL style, version info.
- **Analysis** (`analysis/`):
  - `classes.txt` — 143 classes recovered from Delphi RTTI.
  - `handlers.txt` — 251 event handlers recovered from RTTI.
  - `ANALYSIS-DEEP.md` — 586-line deep technical report.
- **Documentation**: `README.md`, `DOCUMENTATION.md` (with table of contents
  and a verified-inventory appendix), `LICENSE`, `NOTICE.md`,
  `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`.
- **Integrity**: `MANIFEST.txt` — MD5 of all 4,240 original files.
- **Repo hygiene**: `.gitattributes` (line-ending protection so manifest
  hashes stay valid), `.gitignore`, `.github/` (issue/PR templates,
  `CODEOWNERS`, manifest-verification workflow).
- **Scripts**: `run-standalone.sh` (offline launcher), `run.sh`, `launcher.sh`.

### Changed

- `README.md` rewritten as a proper entry point: repository map, packer
  findings, live-dump method, screen inventory and tool table.
- `DOCUMENTATION.md` corrected — inventory figures replaced with measured
  values; table of contents and Appendix §10 added.

### Notes / limitations

- `app/TypingMaster.exe` is protected by a custom packer (97 KB loader stub;
  encrypted overlay, entropy 8.000). Static analysis of the file on disk is
  not useful; all results come from the live memory dump.
- Addresses inside `native-re/decompiled_typingmaster.c` are file-relative:
  live-memory address = file offset + `0x401000`.
- The decompile resolves only about 33 % of the code image by address;
  `ANALYSIS-DEEP.md` documents the gaps and the RTTI-based name recovery.
- DFM form resources could not be read from the PE (stored compressed);
  all 35 `analysis/form_*.txt` extracts are empty by nature.
- The licensing check was **mapped, not broken**. No bypass was implemented
  and none will be accepted as a contribution.

### Security / legal

- Repository contains proprietary third-party software. Keep private.
  See `LICENSE` and `NOTICE.md`.
- Bundled Wine (LGPL-2.1-or-later) and Freedesktop runtime libraries retain
  their upstream licenses.
