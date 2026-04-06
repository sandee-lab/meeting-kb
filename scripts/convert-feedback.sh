#!/usr/bin/env bash
# convert-feedback.sh
# raw/feedback/ 내 바이너리 파일(xlsx, docx, pdf, pptx, csv)을
# markitdown으로 .md 변환 후 원본을 .archive/feedback/로 이동한다.
#
# 사용법:
#   bash scripts/convert-feedback.sh          # raw/feedback/ 전체 스캔
#   bash scripts/convert-feedback.sh file.xlsx # 특정 파일만 변환

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$REPO_ROOT/raw/feedback"
ARCHIVE_DIR="$REPO_ROOT/.archive/feedback"
EXTENSIONS="xlsx|docx|pdf|pptx|csv"

# Python/markitdown PATH (winget 설치 기본 경로)
export PATH="/c/Users/$USERNAME/AppData/Local/Programs/Python/Python312:/c/Users/$USERNAME/AppData/Local/Programs/Python/Python312/Scripts:$PATH"

mkdir -p "$ARCHIVE_DIR"

convert_file() {
  local src="$1"
  local basename="$(basename "$src")"
  local name="${basename%.*}"
  local ext="${basename##*.}"
  local dest_md="$RAW_DIR/${name}.md"

  # 이미 같은 이름의 .md가 있으면 충돌 방지
  if [ -f "$dest_md" ]; then
    dest_md="$RAW_DIR/${name}__converted.md"
  fi

  echo "[convert] $basename -> $(basename "$dest_md")"
  if markitdown "$src" -o "$dest_md" 2>/dev/null; then
    # 변환 성공 -> 원본을 아카이브로 이동
    mv "$src" "$ARCHIVE_DIR/$basename"
    echo "  [archive] -> .archive/feedback/$basename"
  else
    echo "  [error] 변환 실패, 원본 유지"
    rm -f "$dest_md"
    return 1
  fi
}

# --- main ---
converted=0
failed=0

if [ $# -gt 0 ]; then
  # 인자로 받은 파일만 처리
  for f in "$@"; do
    [ -f "$f" ] || { echo "[skip] $f 없음"; continue; }
    convert_file "$f" && ((converted++)) || ((failed++))
  done
else
  # raw/feedback/ 전체 스캔
  while IFS= read -r -d '' f; do
    convert_file "$f" && ((converted++)) || ((failed++))
  done < <(find "$RAW_DIR" -maxdepth 1 -type f -regextype posix-extended \
    -iregex ".*\\.($EXTENSIONS)" -print0 2>/dev/null)
fi

echo ""
echo "완료: 변환 ${converted}건, 실패 ${failed}건"
