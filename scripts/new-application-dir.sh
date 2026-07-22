#!/usr/bin/env bash
# new-application-dir.sh — create a dated, slugged application folder under <data-dir>/applications/
# Usage: new-application-dir.sh <data-dir> <company> <role>
# Prints the absolute path of the created directory on stdout.
set -euo pipefail

DATA_DIR="${1:?usage: new-application-dir.sh <data-dir> <company> <role>}"
COMPANY="${2:-company}"
ROLE="${3:-role}"

slug() {
  # lowercase, spaces/punct -> hyphens, collapse repeats, trim, cap length
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -e 's/[^a-z0-9]\+/-/g' -e 's/^-\+//' -e 's/-\+$//' \
    | cut -c1-40
}

DATE="$(date +%Y-%m-%d)"
NAME="${DATE}-$(slug "$COMPANY")-$(slug "$ROLE")"
APP_DIR="${DATA_DIR%/}/applications/${NAME}"

# Avoid clobbering an existing folder for the same day/company/role
if [ -d "$APP_DIR" ]; then
  i=2
  while [ -d "${APP_DIR}-${i}" ]; do i=$((i+1)); done
  APP_DIR="${APP_DIR}-${i}"
fi

mkdir -p "$APP_DIR"
printf '%s\n' "$APP_DIR"
