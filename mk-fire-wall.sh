#!/usr/bin/env bash
set -euo pipefail

CREATOR="Madhan Kumar"
FIREWALL_NAME="MK-fire wall"
VERSION="1.0.0"

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
NC="\033[0m"

usage() {
  cat <<EOF
$FIREWALL_NAME - Advanced Kali Linux Firewall

Usage:
  sudo ./mk-fire-wall.sh --enable
  sudo ./mk-fire-wall.sh --disable
  sudo ./mk-fire-wall.sh --status
  sudo ./mk-fire-wall.sh --reload
  sudo ./mk-fire-wall.sh --reset
  sudo ./mk-fire-wall.sh --allow <port/proto|ip>
  sudo ./mk-fire-wall.sh --deny <port/proto|ip>
  sudo ./mk-fire-wall.sh --limit <port/proto>
  sudo ./mk-fire-wall.sh --help
EOF
}

banner() {
  clear
  echo -e "${CYAN}"
  cat <<'EOF'
 __  __ _  __        ______ _       _ _ 
|  \/  (_)/ _|      |  ____(_)     | | |
| \  / |_| |_ ___   | |__   _ _ __ | | |
| |\/| | |  _/ _ \  |  __| | | '__| | | |
| |  | | | ||  __/  | |    | | |  |_|_|_|
|_|  |_|_|_| \___|  |_|    |_|_|   (_|_)
EOF
  echo -e "${NC}"
  echo -e "${GREEN}Firewall Name : ${FIREWALL_NAME}${NC}"
  echo -e "${GREEN}Creator       : ${CREATOR}${NC}"
  echo -e "${GREEN}Version       : ${VERSION}${NC}"
  echo
}

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Run this script with sudo.${NC}"
    exit 1
  fi
}

install_ufw() {
  if ! command -v ufw >/dev/null 2>&1; then
    apt update
    apt install -y ufw
  fi
}

enable_fw() {
  install_ufw
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow OpenSSH
  ufw logging medium
  ufw --force enable
  echo -e "${GREEN}MK-fire wall enabled successfully.${NC}"
}

disable_fw() {
  ufw disable
  echo -e "${YELLOW}MK-fire wall disabled.${NC}"
}

status_fw() {
  ufw status verbose
}

reload_fw() {
  ufw reload
  echo -e "${GREEN}MK-fire wall reloaded.${NC}"
}

reset_fw() {
  ufw --force reset
  echo -e "${YELLOW}MK-fire wall reset completed.${NC}"
}

allow_rule() {
  local rule="${1:-}"
  if [[ -z "$rule" ]]; then
    read -r -p "Enter rule to allow (example: 80/tcp or 192.168.1.10): " rule
  fi
  ufw allow "$rule"
}

deny_rule() {
  local rule="${1:-}"
  if [[ -z "$rule" ]]; then
    read -r -p "Enter rule to deny (example: 23/tcp or 192.168.1.10): " rule
  fi
  ufw deny "$rule"
}

limit_rule() {
  local rule="${1:-}"
  if [[ -z "$rule" ]]; then
    read -r -p "Enter rule to limit (example: 22/tcp): " rule
  fi
  ufw limit "$rule"
}

menu() {
  while true; do
    banner
    echo "1) Enable firewall"
    echo "2) Disable firewall"
    echo "3) Show status"
    echo "4) Reload rules"
    echo "5) Reset all rules"
    echo "6) Allow rule"
    echo "7) Deny rule"
    echo "8) Limit rule"
    echo "9) Exit"
    echo
    read -r -p "Select option: " choice

    case "$choice" in
      1) enable_fw; read -r -p "Press Enter to continue..." ;;
      2) disable_fw; read -r -p "Press Enter to continue..." ;;
      3) status_fw; read -r -p "Press Enter to continue..." ;;
      4) reload_fw; read -r -p "Press Enter to continue..." ;;
      5) reset_fw; read -r -p "Press Enter to continue..." ;;
      6) allow_rule; read -r -p "Press Enter to continue..." ;;
      7) deny_rule; read -r -p "Press Enter to continue..." ;;
      8) limit_rule; read -r -p "Press Enter to continue..." ;;
      9) exit 0 ;;
      *) echo -e "${RED}Invalid option.${NC}"; read -r -p "Press Enter to continue..." ;;
    esac
  done
}

main() {
  require_root

  case "${1:-}" in
    --enable) enable_fw ;;
    --disable) disable_fw ;;
    --status) status_fw ;;
    --reload) reload_fw ;;
    --reset) reset_fw ;;
    --allow) allow_rule "${2:-}" ;;
    --deny) deny_rule "${2:-}" ;;
    --limit) limit_rule "${2:-}" ;;
    --help|-h) usage ;;
    "") menu ;;
    *) echo -e "${RED}Unknown option.${NC}"; usage; exit 1 ;;
  esac
}

main "$@"
