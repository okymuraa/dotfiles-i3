#!/usr/bin/env bash

# Obtener estado de WiFi
wifi_status=$(nmcli radio wifi)

if [ "$wifi_status" == "enabled" ]; then
    # WiFi está encendido, mostrar redes disponibles
    notify-send "Escaneando redes WiFi..." -t 2000
    
    # Escanear redes
    nmcli device wifi rescan
    
    # Obtener lista de redes (SSID)
    wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?//g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")
    
    # Agregar opción para apagar WiFi
    wifi_list="  Apagar WiFi\n$wifi_list"
    
    # Mostrar menú con rofi
    selected_network=$(echo -e "$wifi_list" | rofi -dmenu -i -p "Selecciona red WiFi" -theme-str 'window {width: 400px;}')
    
    if [ -n "$selected_network" ]; then
        if [ "$selected_network" = "  Apagar WiFi" ]; then
            nmcli radio wifi off
            notify-send "WiFi desactivado"
        else
            # Extraer solo el SSID (sin el icono de candado)
            ssid=$(echo "$selected_network" | sed 's/^.//g' | xargs)
            
            # Verificar si la red necesita contraseña
            if [[ "$selected_network" =~ "" ]]; then
                # Red con contraseña
                password=$(rofi -dmenu -p "Contraseña para $ssid" -password)
                if [ -n "$password" ]; then
                    nmcli device wifi connect "$ssid" password "$password"
                fi
            else
                # Red abierta
                nmcli device wifi connect "$ssid"
            fi
        fi
    fi
else
    # WiFi está apagado, preguntar si encender
    option=$(echo -e "  Encender WiFi" | rofi -dmenu -i -p "WiFi está apagado")
    if [ "$option" = "  Encender WiFi" ]; then
        nmcli radio wifi on
        notify-send "WiFi activado"
    fi
fi
