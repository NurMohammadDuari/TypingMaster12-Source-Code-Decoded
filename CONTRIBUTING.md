# Contributing

Thanks for your interest. Please read this before opening an issue or a pull
request.

## Scope of this repository

This is a **private research repository** documenting a reverse-engineering
study of TypingMaster 12.0.1.981. It is not a product, not a fork, and not a
distribution channel.

Contribution guidelines reflect that:

- The repository is **not accepting external contributions** by default.
- The sole maintainer is **[@NurMohammadDuari](https://github.com/NurMohammadDuari)**.
- Any accepted change is authored/committed by the maintainer.

## Hard rules (non-negotiable)

1. **No license circumvention.** Do not submit anything that cracks, patches,
   keys, or otherwise bypasses the product's licence check, nor any instructions
   to do so. Licensing may be *described structurally*; it must not be defeated.
2. **No redistribution.** Do not add proprietary binaries beyond what is
   already tracked, and do not ask for this repository to be made public.
3. **No untrusted binaries.** Do not attach executables, cracks, or installers.
4. **No personal data.** Do not commit licence IDs, keys, e-mail addresses, or
   any other real credentials. `prefix/` may contain local state — scrub it
   before proposing changes.

## What is welcome

- Corrections to the analysis (`analysis/`) with cited evidence from the tree.
- Improvements to documentation clarity, accuracy, or structure.
- Reproducibility notes and corrections to the tooling descriptions.
- Fixes to the launcher scripts that preserve behaviour.

## Before you propose a change

1. Re-verify integrity so your change is not confused with file corruption:
   ```sh
   md5sum -c MANIFEST.txt
   ```
2. If you modify any file listed in `MANIFEST.txt`, regenerate its matching
   entry so the manifest stays truthful, and say so in your message.
3. Keep changes small and focused; one topic per change.
4. Never run the target application with network access enabled while
   experimenting.

## Commit / author conventions

- Author and committer are always the maintainer identity:
  `NurMohammadDuari <NurMohammadDuari@users.noreply.github.com>`.
- Use clear, present-tense messages describing *what* changed.

## Reporting problems

Use the issue templates under `.github/ISSUE_TEMPLATE/`. For anything
security-sensitive, follow `SECURITY.md` instead of opening a public issue.

## Legal

By proposing any change you confirm you created it, or that it is lawfully
available, and that it does not violate the rules above. See `LICENSE` and
`NOTICE.md`.
