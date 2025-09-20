#!/usr/bin/env bash
set -euo pipefail

BASE_JUST="/usr/share/ublue-os/just/60-custom.just"
BACKUP_DIR="/usr/share/bluebuild/upstream-just"
BACKUP_JUST="${BACKUP_DIR}/bluefin.just"
IMPORT_LINE='import "/usr/share/bluebuild/upstream-just/bluefin.just"'

if [[ ! -f "${BASE_JUST}" ]]; then
    echo "Warning: ${BASE_JUST} not found; skipping Bluefin justfile preservation." >&2
    exit 0
fi

if grep -Fxq "${IMPORT_LINE}" "${BASE_JUST}"; then
    echo "Bluefin justfile already preserved; no changes needed."
    exit 0
fi

echo "Preserving original Bluefin just recipes and converting ${BASE_JUST} into an import shim."
install -Dm0644 "${BASE_JUST}" "${BACKUP_JUST}"
{
    printf '# Managed by preserve-bluefin-justfiles.sh\n'
    printf '%s\n' "${IMPORT_LINE}"
} > "${BASE_JUST}"
