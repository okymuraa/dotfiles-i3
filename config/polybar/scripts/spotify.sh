#!/bin/bash

# Jugador a monitorear
PLAYER="spotify"

# Obtener estado
STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)

if [ "$STATUS" = "Playing" ]; then
    ICON=""
elif [ "$STATUS" = "Paused" ]; then
    ICON=""
else
    echo ""
    exit 0
fi

# Obtener metadata
ARTIST=$(playerctl --player=$PLAYER metadata artist 2>/dev/null)
TITLE=$(playerctl --player=$PLAYER metadata title 2>/dev/null)

# Limitar longitud
MAX_LENGTH=40
TEXT="$ARTIST - $TITLE"

if [ ${#TEXT} -gt $MAX_LENGTH ]; then
    TEXT="${TEXT:0:$MAX_LENGTH}..."
fi

echo "$ICON $TEXT"
