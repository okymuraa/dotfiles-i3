#!/bin/bash

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Auto-instalador dotfiles i3wm - okymuraa
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${BLUE}"
cat << "EOF"
╔════════════════════════════════════════════════════╗
║                                                    ║
║     ██╗██████╗ ██╗    ██╗███╗   ███╗              ║
║     ██║╚════██╗██║    ██║████╗ ████║              ║
║     ██║ █████╔╝██║ █╗ ██║██╔████╔██║              ║
║     ██║ ╚═══██╗██║███╗██║██║╚██╔╝██║              ║
║     ██║██████╔╝╚███╔███╔╝██║ ╚═╝ ██║              ║
║     ╚═╝╚═════╝  ╚══╝╚══╝ ╚═╝     ╚═╝              ║
║                                                    ║
║          Auto-instalador por okymuraa             ║
║                                                    ║
╚════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Verificar que es Arch/Manjaro
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}❌ Este script solo funciona en Arch Linux / Manjaro${NC}"
    exit 1
fi

echo -e "${YELLOW}⚠️  Este script va a:${NC}"
echo "  • Instalar paquetes necesarios"
echo "  • Copiar configuraciones a tu sistema"
echo "  • Configurar servicios"
echo "  • Cambiar tu shell a zsh"
echo ""
read -p "¿Continuar? (s/n): " respuesta

if [ "$respuesta" != "s" ]; then
    echo -e "${RED}Instalación cancelada${NC}"
    exit 0
fi

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. ACTUALIZAR SISTEMA
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}[1/8]${NC} Actualizando sistema..."
sudo pacman -Syu --noconfirm

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 2. INSTALAR PAQUETES
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}[2/8]${NC} Instalando paquetes..."

# WM y componentes visuales
sudo pacman -S --needed --noconfirm \
    i3-gaps \
    polybar \
    rofi \
    picom \
    dunst \
    nitrogen \
    feh

# Terminal y shell
sudo pacman -S --needed --noconfirm \
    alacritty \
    zsh \
    zsh-completions

# Gestores de archivos
sudo pacman -S --needed --noconfirm \
    ranger \
    thunar \
    thunar-volman \
    thunar-archive-plugin

# Network y conectividad
sudo pacman -S --needed --noconfirm \
    networkmanager \
    network-manager-applet \
    blueman \
    bluez \
    bluez-utils

# Audio
sudo pacman -S --needed --noconfirm \
    pavucontrol \
    pulseaudio \
    pulseaudio-alsa \
    playerctl

# Seguridad y keyring
sudo pacman -S --needed --noconfirm \
    gnome-keyring \
    libsecret \
    seahorse \
    polkit-gnome

# Utilidades del sistema
sudo pacman -S --needed --noconfirm \
    xbindkeys \
    brightnessctl \
    maim \
    xclip \
    xdotool \
    xorg-xrandr \
    xorg-xev \
    arandr

# Herramientas de monitoreo
sudo pacman -S --needed --noconfirm \
    htop \
    btop \
    neofetch \
    lm_sensors

# Fuentes
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-firacode-nerd \
    noto-fonts \
    noto-fonts-emoji

# Utilidades básicas
sudo pacman -S --needed --noconfirm \
    git \
    curl \
    wget \
    unzip \
    zip



echo -e "${GREEN}✅ Paquetes instalados${NC}"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 3. INSTALAR YAY (AUR Helper)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if ! command -v yay &> /dev/null; then
    echo -e "${BLUE}[3/8]${NC} Instalando yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
else
    echo -e "${BLUE}[3/8]${NC} yay ya está instalado"
fi

yay -S spotify --noconfirm

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 4. COPIAR CONFIGURACIONES
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}[4/8]${NC} Copiando configuraciones..."

# Crear directorios necesarios
mkdir -p ~/.config/{i3,polybar,picom,rofi,dunst,ranger}
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/Wallpapers

# Copiar configs
cp -r config/i3/* ~/.config/i3/
cp -r config/polybar/* ~/.config/polybar/
cp -r config/picom/* ~/.config/picom/
cp -r config/rofi/* ~/.config/rofi/
cp -r config/dunst/* ~/.config/dunst/ 2>/dev/null
cp -r scripts/* ~/.local/bin/
cp .zshrc ~/
cp .xbindkeysrc ~/

# Copiar wallpapers
cp -r wallpapers/* ~/Pictures/Wallpapers/ 2>/dev/null

# Hacer ejecutables
chmod +x ~/.local/bin/*
chmod +x ~/.config/polybar/scripts/*
chmod +x ~/.config/polybar/launch.sh

echo -e "${GREEN}✅ Configuraciones copiadas${NC}"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 5. CONFIGURAR SERVICIOS
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}[5/8]${NC} Configurando servicios..."

# Habilitar NetworkManager
sudo systemctl enable --now NetworkManager

# Habilitar Bluetooth
sudo systemctl enable --now bluetooth

# Configurar sensors
sudo sensors-detect --auto

echo -e "${GREEN}✅ Servicios configurados${NC}"

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 6. INSTALAR OH MY ZSH
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ ! -d ~/.oh-my-zsh ]; then
    echo -e "${BLUE}[6/8]${NC} Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Restaurar .zshrc
    cp .zshrc ~/
else
    echo -e "${BLUE}[6/8]${NC} Oh My Zsh ya está instalado"
fi

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 7. INSTALAR ATUIN
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if ! command -v atuin &> /dev/null; then
    echo -e "${BLUE}[7/8]${NC} Instalando atuin..."
    sudo pacman -S --noconfirm atuin
    
    # Agregar a zshrc si no existe
    if ! grep -q "atuin init zsh" ~/.zshrc; then
        echo 'eval "$(atuin init zsh)"' >> ~/.zshrc
    fi
else
    echo -e "${BLUE}[7/8]${NC} atuin ya está instalado"
fi

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 8. CONFIGURACIONES FINALES
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}[8/8]${NC} Configuraciones finales..."

# Cambiar shell a zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
    echo -e "${GREEN}✅ Shell cambiado a zsh${NC}"
fi

# Crear directorio de backups
mkdir -p ~/Backups

echo -e "${GREEN}"
cat << "EOF"

╔════════════════════════════════════════════════════╗
║                                                    ║
║         ✅ INSTALACIÓN COMPLETADA                 ║
║                                                    ║
╚════════════════════════════════════════════════════╝

EOF
echo -e "${NC}"

echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo ""
echo "1. ${GREEN}Cierra sesión${NC}"
echo "2. ${GREEN}En el login manager, selecciona 'i3'${NC}"
echo "3. ${GREEN}Inicia sesión${NC}"
echo ""
echo -e "${BLUE}⌨️  Atajos importantes:${NC}"
echo "  • Mod+Enter           Terminal"
echo "  • Mod+Space           Rofi launcher"
echo "  • Mod+Shift+q         Cerrar ventana"
echo "  • Mod+1-9             Cambiar workspace"
echo "  • Mod+Left/Right      Workspace anterior/siguiente"
echo "  • Mod+Shift+e         Power menu"
echo "  • Mod+r               Modo resize"
echo ""
echo -e "${YELLOW}🔧 Configuración WiFi:${NC}"
echo "  Edita: /etc/NetworkManager/system-connections/TU_RED.nmconnection"
echo "  Agrega: psk-flags=0"
echo "  Y tu contraseña: psk=TU_CONTRASEÑA"
echo ""
echo -e "${GREEN}¡Disfruta tu nuevo setup i3wm!${NC}"
echo ""
