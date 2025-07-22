#!/bin/bash

# Script zum Auschecken eines Git-Projekts, Datei kopieren und Repo löschen.

set -e  # Stoppe das Skript bei Fehlern

# --- Parameter prüfen ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --repo) REPO_URL="$2"; shift ;;
        --input-path) INPUT_PATH="$2"; shift ;;
        --output-path) OUTPUT_PATH="$2"; shift ;;
        *) echo "Unbekannter Parameter: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$REPO_URL" ] || [ -z "$INPUT_PATH" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Benutzung: get.sh --repo <repo-url> --input-path <pfad> --output-path <pfad>"
    exit 1
fi

if [ -z "$GIT_TOKEN" ]; then
    echo "Fehler: GIT_TOKEN Umgebungsvariable nicht gesetzt."
    exit 2
fi

# --- Temp-Verzeichnis ---
TMP_DIR="/tmp/repo_$(date +%s)"
mkdir -p "$TMP_DIR"

# --- Klonen ---
# Entfernt https:// und optionales git@ aus der URL
CLEAN_REPO_URL="${REPO_URL/https:\/\/git@/}"
CLEAN_REPO_URL="${CLEAN_REPO_URL/https:\/\//}"

FULL_REPO_URL="https://git:${GIT_TOKEN}@${CLEAN_REPO_URL}"

echo "Klone Repository..."
git clone --depth 1 "$FULL_REPO_URL" "$TMP_DIR"

# --- Datei kopieren ---
echo "Kopiere Datei..."
cp "$TMP_DIR/$INPUT_PATH" "$OUTPUT_PATH"

# --- Aufräumen ---
echo "Lösche Repository..."
rm -rf "$TMP_DIR"

echo "✅ Datei erfolgreich kopiert nach: $OUTPUT_PATH"
