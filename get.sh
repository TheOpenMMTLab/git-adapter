#!/bin/bash

# Script zum Auschecken eines Git-Projekts, Datei kopieren und Repo löschen.

set -e  # Stoppe das Skript bei Fehlern

# --- Parameter prüfen ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --repo) REPO_URL="$2"; shift ;;
        --input-path) INPUT_PATH="$2"; shift ;;
        --output-path) OUTPUT_PATH="$2"; shift ;;
        --ref) REF="$2"; shift ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$REPO_URL" ] || [ -z "$INPUT_PATH" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Benutzung: get.sh --repo <repo-url> --input-path <pfad> --output-path <pfad> [--ref <commit|tag|branch>]"
    exit 1
fi

# --- Temp-Verzeichnis ---
TMP_DIR="/tmp/repo_$(date +%s)"
mkdir -p "$TMP_DIR"

# --- Klonen ---
if [ -n "$GIT_TOKEN" ]; then
    # Token nicht in die URL schreiben (Sonderzeichen), sondern per HTTP Header senden.
    CLEAN_REPO_URL="${REPO_URL#https://git@}"
    CLEAN_REPO_URL="${CLEAN_REPO_URL#https://}"
    FULL_REPO_URL="https://${CLEAN_REPO_URL}"
    AUTH_B64="$(printf 'git:%s' "$GIT_TOKEN" | base64 | tr -d '\r\n')"
    echo "Klone Repository mit Token..."
else
    FULL_REPO_URL="$REPO_URL"
    echo "Klone Repository ohne Token..."
fi

if [ -n "$REF" ]; then
    # Full clone to reliably allow checkout of arbitrary commit/tag/branch.
    if [ -n "$GIT_TOKEN" ]; then
        git -c "http.extraHeader=Authorization: Basic $AUTH_B64" clone "$FULL_REPO_URL" "$TMP_DIR"
    else
        git clone "$FULL_REPO_URL" "$TMP_DIR"
    fi
    echo "Wechsle auf Ref: $REF"
    git -C "$TMP_DIR" checkout "$REF"
else
    if [ -n "$GIT_TOKEN" ]; then
        git -c "http.extraHeader=Authorization: Basic $AUTH_B64" clone --depth 1 "$FULL_REPO_URL" "$TMP_DIR"
    else
        git clone --depth 1 "$FULL_REPO_URL" "$TMP_DIR"
    fi
fi

# --- Datei kopieren ---
echo "Kopiere Datei..."
cp "$TMP_DIR/$INPUT_PATH" "$OUTPUT_PATH"

# --- Aufräumen ---
echo "Lösche Repository..."
rm -rf "$TMP_DIR"

echo "✅ Datei erfolgreich kopiert nach: $OUTPUT_PATH"
