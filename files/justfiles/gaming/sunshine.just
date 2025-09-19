# vim: set ft=make :

# Manage Sunshine Game Streaming service autostart
[group("gaming")]
setup-sunshine ACTION="":
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh

    OPTION={{ ACTION }}

    SERVICE_STATE="$(systemctl is-enabled --user sunshine.service 2>/dev/null || true)"
    case "$SERVICE_STATE" in
        enabled)
            SERVICE_MSG="${green}${b}Enabled${n}"
            ;;
        disabled)
            SERVICE_MSG="${red}${b}Disabled${n}"
            ;;
        *)
            SERVICE_MSG="${yellow}${b}${SERVICE_STATE:-Unknown}${n}"
            ;;
    esac

    if [[ "${OPTION,,}" == "help" ]]; then
        cat <<'USAGE'
Usage: ujust setup-sunshine <option>
  <option>: Specify the quick option to skip the prompt
  Use 'enable' to enable the Sunshine service
  Use 'disable' to disable the Sunshine service
  Use 'portal' to open the Sunshine management portal
  Use 'exit' to exit without making changes
USAGE
        exit 0
    fi

    if [[ -z "$OPTION" ]]; then
        echo "Sunshine service autostart is $SERVICE_MSG."
        OPTION=$(Choose "Enable" "Disable" "Open Portal" "Exit")
    fi

    OPTION_LOWER="${OPTION,,}"

    if [[ "$OPTION_LOWER" =~ ^enable ]]; then
        systemctl --user enable --now sunshine.service
    elif [[ "$OPTION_LOWER" =~ ^(disable|remove|uninstall) ]]; then
        systemctl --user disable --now sunshine.service || true
    elif [[ "$OPTION_LOWER" =~ ^(portal|open) ]]; then
        echo "Opening Sunshine management portal..."
        if command -v xdg-open >/dev/null 2>&1; then
            xdg-open https://localhost:47990 >/dev/null 2>&1 &
        else
            echo "xdg-open not available; open https://localhost:47990 manually."
        fi
    elif [[ "$OPTION_LOWER" =~ ^exit ]]; then
        echo "Exiting without making changes."
        exit 0
    else
        echo "Unknown option: $OPTION"
        exit 1
    fi
