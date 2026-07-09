---
title: Stampla
description: >-
  Deterministic, verifiable naming for photo and video archives — every
  file renamed to its capture time plus a content-hash slice.
tagline: Deterministic, verifiable naming for photo and video archives.
lede: >-
  `stampla` renames every photo and video to an identity derived
  **purely from the file itself** — the capture time plus a slice of the
  content hash. No rolling counters, no guesswork, nothing to keep in a
  database.
how_aside: >-
  Import copies — the card is never written to. Every copy is re-hashed
  at its destination, and exit code 0 certifies the whole card is
  accounted for. RAW masters travel with their sidecars, atomically.
install_aside: >-
  Python 3.11+ and [ExifTool](https://exiftool.org/) on `PATH`; no other
  dependencies. MIT licensed.
properties:
  - title: Chronological by construction
    body: >-
      Sorting by name is sorting by capture time — across every camera,
      phone and scanner. `IMG_0001 (2).jpg` never happens again.
  - title: Verifiable
    body: >-
      The name is reproducible from the file, so the whole archive can be
      re-checked at any time: corruption is told apart from legitimate
      edits, and duplicates identify themselves.
  - title: Family-safe
    body: >-
      RAW masters travel with their XMP/PP3 sidecars and editor
      derivatives — everything shares the master's prefix and is renamed
      together, atomically.
tools:
  - name: stampla
    body: >-
      The command-line tool and engine: import, verify, rename, organize —
      journaled, resumable, undoable.
    url: https://github.com/stampla/stampla
    link_label: GitHub · also on PyPI
  - name: stampla-desktop
    body: >-
      The desktop app: the same engine with live progress, plain-language
      findings and one-click undo — and every action shows its terminal
      equivalent.
    url: https://github.com/stampla/stampla-desktop
    link_label: GitHub
  - name: stampla-publisher
    body: >-
      Lightroom Classic publish plugin: publish photos and videos into a
      plain folder tree that mirrors the archive.
    url: https://github.com/stampla/stampla-publisher
    link_label: GitHub
---

Every command is a dry run unless explicitly applied. Applies are
validated as a whole before anything is touched, journaled before the
first change, applied atomically per file family, resumable after an
interruption and revertable afterwards — undo re-verifies content
before deleting anything. A file whose capture time cannot be resolved
is reported, never renamed. Nothing is ever overwritten.
