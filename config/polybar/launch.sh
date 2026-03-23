#!/usr/bin/env bash

# Terminar instancias existentes
killall -q polybar

# Esperar a que los procesos terminen
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanzar Polybar en cada monitor
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main 2>&1 | tee -a /tmp/polybar-$m.log & disown
    echo "Polybar lanzado en $m"
done

echo "Todas las Polybars lanzadas"

