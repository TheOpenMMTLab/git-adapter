#!/bin/bash
# put.sh: Commit a file to a remote git repository
# Usage:
#   ./put.sh --repo <repo-url> --input-path <local-file> --output-path <remote-path> --commit-message <message>

set -e

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --repo)
      REPO_URL="$2"
      shift; shift
      ;;
    --input-path)
      INPUT_PATH="$2"
      shift; shift
      ;;
    --output-path)
      OUTPUT_PATH="$2"
      shift; shift
      ;;
    --commit-message)
      COMMIT_MESSAGE="$2"
      shift; shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$REPO_URL" || -z "$INPUT_PATH" || -z "$OUTPUT_PATH" || -z "$COMMIT_MESSAGE" ]]; then
  echo "Usage: $0 --repo <repo-url> --input-path <local-file> --output-path <remote-path> --commit-message <message>"
  exit 1
fi

if [ -z "$GIT_TOKEN" ]; then
    echo "Fehler: GIT_TOKEN Umgebungsvariable nicht gesetzt."
    exit 2
fi

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# --- Klonen ---
# Entfernt https:// und optionales git@ aus der URL
CLEAN_REPO_URL="${REPO_URL/https:\/\/git@/}"
CLEAN_REPO_URL="${CLEAN_REPO_URL/https:\/\//}"

FULL_REPO_URL="https://git:${GIT_TOKEN}@${CLEAN_REPO_URL}"

echo "Klone Repository..."

git clone "$FULL_REPO_URL" "$TMP_DIR"
cp "$INPUT_PATH" "$TMP_DIR/$OUTPUT_PATH"
cd "$TMP_DIR"
git add "$OUTPUT_PATH"

# Prüfe, ob es Änderungen gibt
if git status --porcelain | grep .; then
  git config user.name "Automated Commit"
  git config user.email "auto@frittenburger.de"
  git commit -m "$COMMIT_MESSAGE"
  git push origin HEAD
  echo "✅ Datei erfolgreich commitet nach: $OUTPUT_PATH"
else
  echo "ℹ️  Keine Änderungen zum Commit. Datei ist identisch oder unverändert."
fi

# --- Aufräumen ---
echo "Lösche Repository..."
rm -rf "$TMP_DIR"

echo "✅ Datei erfolgreich commitet nach: $OUTPUT_PATH"