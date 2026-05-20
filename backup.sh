#!/usr/bin/env bash
# backup.sh — tar + timestamp backup tool
set -euo pipefail

SOURCE="${1:-}"
DEST="${2:-$HOME/backups}"
if [[ -z "$SOURCE" ]]; then
  echo "Usage: backup.sh <source_dir> [dest_dir]"; exit 1
fi
[[ ! -d "$SOURCE" ]] && echo "Source not found: $SOURCE" && exit 1
mkdir -p "$DEST"

NAME="$(basename "$SOURCE")"
STAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE="$DEST/${NAME}_${STAMP}.tar.gz"

echo "📦 Backing up: $SOURCE"
echo "   → $ARCHIVE"
tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$NAME"
SIZE=$(du -sh "$ARCHIVE" | cut -f1)
echo "✅ Done! Archive size: $SIZE"

# Keep only last 7 backups
ls -t "$DEST/${NAME}_"*.tar.gz 2>/dev/null | tail -n +8 | while read old; do
  echo "🗑  Removing old backup: $(basename "$old")"
  rm "$old"
done
