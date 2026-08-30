---
title: Stampla
description: >-
  A complete toolset for photo and video archives: a desktop app, a
  Lightroom Classic plugin and an automation-friendly engine — built
  around verifiable, chronological file naming.
tagline: Your photo archive, verifiable for decades.
lede: >-
  Stampla stamps every photo and video with its own identity: when it
  was captured, and what it contains — a name **derived purely from the
  file itself**. Nothing to maintain, nothing to lose: the archive can
  prove its own integrity at any time.
desktop_intro: >-
  The desktop app covers the whole workflow: import cards, check the
  archive's health, fix names, undo anything. Every action is a preview
  first — nothing changes until you say so.
screenshots:
  - src: /images/app-import.png
    alt: >-
      The Import view after copying a card: a green banner reads "Card
      fully accounted for — safe to format", above the list of copied
      files with their new names.
    caption: >-
      Import ends in a verdict, not a guess — every copy is re-hashed at
      its destination before the card is cleared for formatting.
  - src: /images/app-verify.png
    alt: >-
      The Verify view: findings grouped by meaning with plain-language
      explanations — a date disagreement shown with the old time in red
      and the corrected time in green.
    caption: >-
      Verify explains findings in plain language, worst first — and
      tells corruption apart from ordinary edits.
  - src: /images/app-relocate.png
    alt: >-
      The Relocate view: two files planned to move, each shown as its
      current folder and the folder its name says it belongs in.
    caption: >-
      Names carry their own filing: Relocate puts files back where
      their name says they belong — and hands Lightroom-managed
      folders to Lightroom.
desktop_features:
  - Safe by default — previews everywhere, one Apply, journaled changes
    with one-click Undo, and Resume for interrupted runs.
  - Built for real archives — live progress with a Stop button, tested
    against hundreds of thousands of files.
  - Nothing hidden — every action can show the exact terminal command
    it stands for.
  - Grows with the archive — file event shoots into their own folders,
    or change the naming scheme with a guided, verifiable migration.
lrc_blurb: >-
  Shooting through Lightroom Classic? The publish plugin keeps a plain
  folder tree in step with your catalog — and the archive tools respect
  what Lightroom manages, handing renames to it instead of breaking
  its links.
properties:
  - title: Everything on one timeline
    body: >-
      Sorting by name is sorting by capture time — across every camera,
      phone and scanner. `IMG_0001 (2).jpg` never happens again.
  - title: Verifiable
    body: >-
      The name is reproducible from the file, so the whole archive can be
      re-checked at any time: corruption is told apart from legitimate
      edits, and duplicates identify themselves.
  - title: Groups stay whole
    body: >-
      A RAW file, its sidecars and its edits form one group — everything
      shares the master's name and is renamed together, atomically.
advanced_aside: >-
  The engine is a dependency-free Python package —
  [`stampla` on PyPI](https://pypi.org/project/stampla/)
  (Python 3.11+, [ExifTool](https://exiftool.org/) on `PATH`). `--json`
  and `--json-stream` make every command scriptable; the
  [command guide](https://github.com/stampla/stampla-python/blob/main/docs/commands.md)
  has the details.
---

Every tool is a dry run unless explicitly applied. Applies are
validated as a whole before anything is touched, journaled before the
first change, applied atomically per file group, resumable after an
interruption and revertable afterwards — undo re-verifies content
before deleting anything. A file whose capture time cannot be resolved
is reported, never renamed. Nothing is ever overwritten.
