#!/usr/bin/env bash
set -euo pipefail

# Fetches the exact Hugo build named in .hugo-version into .bin/, so a local
# build cannot silently use whatever version the package manager last upgraded
# to. A green check from a different Hugo is a check against a different site.
#
#   scripts/install-hugo.sh      # downloads if needed, no-op if already current
#   .bin/hugo version            # confirm
#
# .bin/ is untracked. scripts/check-hugo-version.sh puts it on PATH when present.
#
# macOS releases ship only as a .pkg installer, so the binary is extracted from
# the package rather than installed: nothing touches Homebrew or /usr/local.
# The download is checked against the release's own SHA-256 list before it is
# unpacked, and nothing is written if that check fails.

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"

VERSION=$(tr -d ' \n\r\t' < "$ROOT/.hugo-version")
[[ -n $VERSION ]] || { echo "install-hugo: .hugo-version is empty" >&2; exit 1; }

BIN_DIR="$ROOT/.bin"
TARGET="$BIN_DIR/hugo"

if [[ -x $TARGET ]] && "$TARGET" version 2>/dev/null | grep -q "v$VERSION"; then
  echo "install-hugo: .bin/hugo is already $VERSION"
  exit 0
fi

os=$(uname -s)
arch=$(uname -m)
case "$os" in
  Darwin) asset="hugo_extended_${VERSION}_darwin-universal.pkg" ;;
  Linux)
    case "$arch" in
      x86_64) asset="hugo_extended_${VERSION}_linux-amd64.tar.gz" ;;
      aarch64 | arm64) asset="hugo_extended_${VERSION}_linux-arm64.tar.gz" ;;
      *) echo "install-hugo: unsupported architecture $arch" >&2; exit 1 ;;
    esac
    ;;
  *) echo "install-hugo: unsupported system $os" >&2; exit 1 ;;
esac

base="https://github.com/gohugoio/hugo/releases/download/v${VERSION}"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT INT TERM

echo "install-hugo: downloading $asset"
curl -fsSL -o "$WORK/$asset" "$base/$asset"
curl -fsSL -o "$WORK/checksums.txt" "$base/hugo_${VERSION}_checksums.txt"

expected=$(awk -v f="$asset" '$2 == f { print $1 }' "$WORK/checksums.txt")
[[ -n $expected ]] || { echo "install-hugo: no checksum listed for $asset" >&2; exit 1; }
if command -v shasum >/dev/null 2>&1; then
  actual=$(shasum -a 256 "$WORK/$asset" | awk '{print $1}')
else
  actual=$(sha256sum "$WORK/$asset" | awk '{print $1}')
fi
if [[ $expected != "$actual" ]]; then
  echo "install-hugo: checksum mismatch" >&2
  echo "  expected: $expected" >&2
  echo "  actual:   $actual" >&2
  exit 1
fi
echo "install-hugo: checksum verified"

mkdir -p "$BIN_DIR"
case "$os" in
  Darwin)
    # A flat .pkg is a xar archive; the binary sits in Payload as gzipped cpio.
    (cd "$WORK" && xar -xf "$asset")
    payload=$(find "$WORK" -name Payload | head -1)
    [[ -n $payload ]] || { echo "install-hugo: no Payload in package" >&2; exit 1; }
    # Not named "payload": macOS filenames are case-insensitive and the package
    # already contains "Payload".
    mkdir -p "$WORK/unpacked"
    (cd "$WORK/unpacked" && gunzip -dc "$payload" | cpio -i 2>/dev/null)
    found=$(find "$WORK/unpacked" -name hugo -type f | head -1)
    [[ -n $found ]] || { echo "install-hugo: no hugo binary in package" >&2; exit 1; }
    cp "$found" "$TARGET"
    ;;
  Linux)
    tar -xzf "$WORK/$asset" -C "$WORK" hugo
    cp "$WORK/hugo" "$TARGET"
    ;;
esac
chmod +x "$TARGET"

got=$("$TARGET" version)
if [[ $got == *"v$VERSION"* ]]; then
  echo "install-hugo: ready — $got"
else
  echo "install-hugo: downloaded build does not match .hugo-version: $got" >&2
  exit 1
fi
