# Contributing

**Everyone is welcome to help.** This project is a reverse-engineering study of
TypingMaster 12.0.1.981, and there is far more work than one person can do.
Reports, corrections, testing, documentation, translations and tooling are all
genuinely useful — you do not need to be a reverse engineer to contribute.

Maintainer: **[@NurMohammadDuari](https://github.com/NurMohammadDuari)**.

> Read this page, then jump to [**Ways to contribute**](#ways-to-contribute).

---

## Ways to contribute

Pick whatever matches your skills. Anything from a one-line typo fix to a
full function analysis is valuable.

### 🐞 Reporting & triage
- Report bugs in the launcher scripts or documentation.
- Reproduce someone else's report and confirm/deny it.
- Add missing detail (OS, error output, `md5sum -c MANIFEST.txt` result).

### 🔬 Analysis
- Correct or extend `analysis/` with **cited evidence** (file + offset,
  function address, resource id, byte range).
- Help close the known **decompiler gaps** listed in `ROADMAP.md` and
  `analysis/ANALYSIS-DEEP.md`.
- Recover readable names for heavily-referenced `FUN_*` functions.
- Confirm or refute inferred data-structure layouts.

### 🧪 Testing
- Run `./run-standalone.sh` on **different Linux distributions** and report
  what works: Ubuntu, Debian, Fedora, Arch, Gentoo, NixOS, openSUSE, etc.
- Test on different desktop environments, DPI settings, and keyboard layouts.
- Verify `md5sum -c MANIFEST.txt` on a fresh clone and report anomalies.

### 📖 Documentation
- Fix unclear wording, broken links, or wrong statements.
- Add worked examples ("how do I …?") and screenshots of your run.
- Improve the file-format notes (`.kbd`, `.exi`/`.exm`, `.cnt`, `.hdr`, `.wzd`).
- Translate documentation into other languages.

### ⌨️ Domain knowledge
- Explain a keyboard layout or national variant in `app/keyboards/`.
- Describe what a lesson/course file is meant to teach.
- Confirm UI behaviour against the official manual.

### 🛠️ Tooling
- Scripts that verify a claim automatically.
- Better extraction/parsing helpers.
- Improvements to the CI workflows.

### 💬 Community
- Answer questions in Issues and Discussions.
- Triage incoming issues and apply labels.
- Turn a solved discussion into a documentation fix.

---

## Your first contribution

1. Look for issues labelled
   [**`good first issue`**](https://github.com/NurMohammadDuari/TypingMaster-Source/labels/good%20first%20issue)
   or [**`help wanted`**](https://github.com/NurMohammadDuari/TypingMaster-Source/labels/help%20wanted).
2. Comment on the issue that you would like to take it — this avoids
   duplicated effort.
3. Make your change (see the workflow below).
4. Open a pull request and fill in the template.

If you are unsure where to start, open a
[Discussion](https://github.com/NurMohammadDuari/TypingMaster-Source/discussions)
and say what you are good at — you will be pointed at something useful.

---

## Workflow

```sh
# 1. Fork the repository on GitHub, then clone your fork
git clone https://github.com/<your-username>/TypingMaster-Source.git
cd TypingMaster-Source

# 2. Add the upstream remote
git remote add upstream https://github.com/NurMohammadDuari/TypingMaster-Source.git

# 3. Create a focused branch
git switch -c fix/manifest-note-typo

# 4. Make your change. Keep it small and single-purpose.

# 5. Verify integrity
md5sum -c MANIFEST.txt

# 6. Commit and push
git add -A
git commit -m "docs: fix typo in manifest note"
git push -u origin fix/manifest-note-typo
```

Then open a pull request against `main` and complete the template.

### Commit messages

Present tense, imperative, one topic per commit:

```
analysis: map TStatisticsStg handler at 0x7A2F60
docs: clarify .kbd field offsets
fix: correct LD_LIBRARY_PATH order in run-standalone.sh
ci: pin actions/checkout to a released major
```

Prefixes used here: `analysis`, `docs`, `fix`, `feat`, `ci`, `chore`,
`integrity`.

---

## Rules (non-negotiable)

These keep the project legal and trustworthy:

1. **No licence circumvention.** Do not submit cracks, keygens, patches,
   activation tools, or instructions for defeating the product's licence
   check. Licensing may be *described structurally*; it must not be defeated.
2. **No redistribution.** Do not add proprietary binaries beyond what is
   already tracked, and do not ask for this repository to be made public.
   See `NOTICE.md`.
3. **No untrusted binaries.** Do not attach executables, installers or
   archives containing them.
4. **No secrets or personal data.** Never commit licence IDs, keys, e-mail
   addresses, or other real credentials. Scrub local state before submitting.
5. **Cite your evidence.** Analysis claims must point at something in the
   tree. Remember: addresses in `native-re/decompiled_typingmaster.c` are
   file-relative — live address = file offset + `0x401000`.

Pull requests that break these rules are closed without discussion.

---

## Evidence standards for analysis changes

A claim without evidence cannot be reviewed. Include, where applicable:

- the file and byte offset, or a byte range;
- the function name/address (`FUN_xxxxxxxx`) and which build it came from;
- the PE resource id;
- a short command someone else can run to reproduce your finding.

If you are inferring rather than proving, **say so** — mark it as an
inference.

---

## Labels you will encounter

| Label | Meaning |
|---|---|
| `good first issue` | Small, well-scoped, good starting point |
| `help wanted` | Maintainer would welcome outside help |
| `analysis` | Reverse-engineering content |
| `documentation` | Docs and wording |
| `launcher` | `run*.sh` / `launcher.sh` |
| `runtime` | Wine runtime or prefix |
| `integrity` | `MANIFEST.txt` / hashing |
| `ci` | GitHub Actions and automation |
| `governance` | Licensing and policy files |
| `triage` | Awaiting initial review |
| `question` | Needs more information |
| `security` | Security-related (report privately — see `SECURITY.md`) |

---

## Review & response expectations

- This is a volunteer project with a single maintainer. There is no SLA.
- Small, focused pull requests are reviewed fastest.
- If a change needs rework you will get concrete, kind feedback — that is not
  a rejection.
- Accepted contributions are credited in the pull request and, where
  significant, in the release notes.

## Recognition

All contributors are listed via GitHub's contributor graph. Significant or
recurring contributors can be added to `AUTHORS.md` on request.

## Security

Never report a vulnerability in a public issue — follow `SECURITY.md`.

## Code of Conduct

By participating you agree to abide by `CODE_OF_CONDUCT.md`.

## Legal

By proposing a change you confirm you created it, or that it is lawfully
available to you, and that it complies with the rules above. See `LICENSE`
and `NOTICE.md`.
