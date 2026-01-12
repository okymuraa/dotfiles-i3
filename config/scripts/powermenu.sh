#!/bin/bash
choice=$(echo -e "🔒 Bloquear\n🚪 Logout\n🔄 Reiniciar\n⏻ Apagar" | rofi -dmenu -p "Powermenu")

case "$choice" in
    "🔒 Bloquear") i3lock -c 000000 ;;
    "🚪 Logout") killall -q i3 && loginctl terminate-user $USER ;;  # ← CAMBIO
    "🔄 Reiniciar") systemctl reboot ;;
    "⏻ Apagar") systemctl poweroff ;;
esac

