#!/usr/bin/env bash
set -euo pipefail

# Asserts that the Hugo on PATH is the one named in .hugo-version.
#
# The version is pinned in three places that must agree: this repository, the
# CI workflow, and the Pages build image. CI and the deploy build read the same
# file; a local machine does not, because package managers upgrade Hugo on their
# own schedule. Without this check a local build quietly produces a different
# site from the one CI approved and the one visitors receive.
#
# Run scripts/install-hugo.sh to fetch the pinned build into .bin/, which this
# check prefers when it exists.

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"

EXPECTED=$(tr -d ' \n\r\t' < "$ROOT/.hugo-version")
[[ -n $EXPECTED ]] || { echo "check-hugo-version: .hugo-version is empty" >&2; exit 1; }

if [[ -x "$ROOT/.bin/hugo" ]]; then
  PATH="$ROOT/.bin:$PATH"
  export PATH
fi

if ! command -v hugo >/dev/null 2>&1; then
  echo "check-hugo-version: hugo is not on PATH; run scripts/install-hugo.sh" >&2
  exit 1
fi

actual=$(hugo version)
if [[ $actual != *"v$EXPECTED"* ]]; then
  echo "check-hugo-version: expected Hugo $EXPECTED, got: $actual" >&2
  echo "  run scripts/install-hugo.sh to fetch the pinned build" >&2
  exit 1
fi

echo "check-hugo-version: hugo $EXPECTED"
