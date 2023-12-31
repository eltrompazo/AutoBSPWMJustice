#!/bin/bash

# AUTOR
echo '
====================================================================================================================


      ██╗██╗   ██╗███████╗████████╗██╗ ██████╗███████╗              ██████╗ ███████╗ █████╗ ██████╗ ███████╗██████╗ 
      ██║██║   ██║██╔════╝╚══██╔══╝██║██╔════╝██╔════╝              ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗
      ██║██║   ██║███████╗   ██║   ██║██║     █████╗      █████╗    ██████╔╝█████╗  ███████║██████╔╝█████╗  ██████╔╝
 ██   ██║██║   ██║╚════██║   ██║   ██║██║     ██╔══╝      ╚════╝    ██╔══██╗██╔══╝  ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
 ╚█████╔╝╚██████╔╝███████║   ██║   ██║╚██████╗███████╗              ██║  ██║███████╗██║  ██║██║     ███████╗██║  ██║
  ╚════╝  ╚═════╝ ╚══════╝   ╚═╝   ╚═╝ ╚═════╝╚══════╝              ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
                                                                                                            
                                                                                                            
====================================================================================================================
'

# COMPROBACIÓN DE USUARIO
if [ "$(id -u)" != "0" ]; then
    echo -e "\e[31m[*]\e[0m Por favor, ejecuta este script con sudo."
    exit 1
fi

# OBTENEMOS EL DIRECTORIO ACTUAL
directorio_instalacion=$(pwd)

# OBTENEMOS EL USUARIO
echo -e "\e[33m[*]\e[0m Este script configurará el sistema en base al usuario proporcionado y al usuario root.\n"

while true; do
    read -p "$(echo -e "\e[33m[*]\e[0m Por favor, introduce el nombre del usuario sobre el cual se aplicarán los cambios: ")" input_username
    if id "$input_username" &>/dev/null; then
        echo -e "\e[32m[*]\e[0m El usuario $input_username es válido.\n"
        
        while true; do
            read -p "$(echo -e "\e[33m[*]\e[0m ¿Es $input_username el nombre de usuario correcto? (SI/NO): ")" confirmation
            confirmation=$(echo "$confirmation" | tr '[:upper:]' '[:lower:]')
            
            if [ "$confirmation" = "si" ] || [ "$confirmation" = "s" ]; then
                echo ""
                break 2
            elif [ "$confirmation" = "no" ] || [ "$confirmation" = "n" ]; then
                echo ""
                break 
            else
                echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
            fi
        done
    else
        echo -e "\e[31m[*]\e[0m El usuario $input_username no es válido o no existe.\n"
    fi
done

# ACTUALIZAMOS EL SISTEMA
while true; do
    read -p "$(echo -e "\e[33m[*]\e[0m ¿Deseas realizar un 'apt update' en el sistema? (SI/NO): ")" respuesta_update
    respuesta_update=$(echo "$respuesta_update" | tr '[:upper:]' '[:lower:]')

    if [ "$respuesta_update" = "si" ] || [ "$respuesta_update" = "s" ]; then
        echo -e "\e[32m[*]\e[0m Ejecutando 'apt update' ...\n"
        apt update &>/dev/null
        break
    elif [ "$respuesta_update" = "no" ] || [ "$respuesta_update" = "n" ]; then
        echo -e "\e[31m[*]\e[0m Operación 'apt update' cancelada.\n"
        break
    else
        echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
    fi
done

# UPGRADEAMOS EL SISTEMA
while true; do
    read -p "$(echo -e "\e[33m[*]\e[0m ¿Deseas realizar un 'full-upgrade' en el sistema? (SI/NO): ")" respuesta_upgrade
    respuesta_upgrade=$(echo "$respuesta_upgrade" | tr '[:upper:]' '[:lower:]')

    if [ "$respuesta_upgrade" = "si" ] || [ "$respuesta_upgrade" = "s" ]; then
        echo -e "\e[32m[*]\e[0m Ejecutando 'apt full-upgrade' ...\n"
        apt full-upgrade -y &>/dev/null
        break
    elif [ "$respuesta_upgrade" = "no" ] || [ "$respuesta_upgrade" = "n" ]; then
        echo -e "\e[31m[*]\e[0m Operación 'apt full-upgrade' cancelada.\n"
        break
    else
        echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
    fi
done

# INSTALAMOS LAS DEPENDENCIAS NECESARIAS
echo -e "\e[32m[*]\e[0m Instalando las dependencias necesarias ...\n"
apt install imagemagick brightnessctl feh xclip bspwm sxhkd wmname polybar betterlockscreen bat lsd fzf flameshot picom rofi kitty zsh -y &>/dev/null

# ELIMINAMOS LAS ANTIGUAS CONFIGURACIONES
rm -rf /home/$input_username/.zshrc &>/dev/null &>/dev/null
rm -rf /home/$input_username/.p10k.zsh &>/dev/null
rm -rf /root/.zshrc &>/dev/null
rm -rf /root/.p10k.zsh &>/dev/null
rm -rf /root/.config/kitty &>/dev/null
rm -rf /root/.config/nvim &>/dev/null
rm -rf /opt/*nvim* &>/dev/null 
rm -rf /home/$input_username/.config/kitty &>/dev/null
rm -rf /home/$input_username/.config/polybar &>/dev/null
rm -rf /home/$input_username/.config/picom &>/dev/null
rm -rf /home/$input_username/.config/bspwm &>/dev/null
rm -rf /home/$input_username/.config/nvim &>/dev/null
rm -rf /home/$input_username/.config/sxhkd &>/dev/null

# CREAMOS NUEVAS CONFIGURACIONES
mkdir /root/.config &>/dev/null
mkdir /home/$input_username/.config &>/dev/null

# EDITOR DE CÓDIGO
while true; do
    read -p "$(echo -e "\e[33m[*]\e[0m ¿Qué editor de código deseas utilizar? (NVIM/VSCODE): ")" code_editor
    code_editor=$(echo "$code_editor" | tr '[:upper:]' '[:lower:]')

    if [ "$code_editor" = "nvim" ]; then
        # INSTALANDO NVIM
        echo -e "\e[32m[*]\e[0m Instalando neovim ..."
        apt install npm -y &>/dev/null 
        api_url="https://api.github.com/repos/neovim/neovim/releases/latest"
        download_url=$(curl -s $api_url | grep "browser_download_url.*nvim-linux64" | cut -d : -f 2,3 | tr -d '," ')
        wget $download_url &>/dev/null 
        tar -xf nvim-linux64.tar.gz &>/dev/null 
        mv nvim-linux64 /opt &>/dev/null 
        chown -R root:root /opt/nvim-linux64

        # INSTALANDO NVCHAD
        echo -e "\e[32m[*]\e[0m Instalando nvchad ..."
        mkdir /home/$input_username/.config/nvim &>/dev/null 
        mkdir /root/.config/nvim &>/dev/null 
        git clone https://github.com/NvChad/NvChad /home/$input_username/.config/nvim --depth 1 &>/dev/null 
        git clone https://github.com/NvChad/NvChad /root/.config/nvim --depth 1 &>/dev/null 

        # CREANDO LINK SIMBÓLICO ENTRE LOS ARCHIVOS DE CONFIGURACIÓN DE NVIM DEL USUARIO ELEGIDO Y DE ROOT
        echo -e "\e[32m[*]\e[0m Creando link simbólico en los archivos de configuración de nvim ..."
        ln -s -f /home/$input_username/.config/nvim /root/.config/nvim &>/dev/null 

        # INSERTAMOS EL ALIAS DE NVIM EN LA ZSHRC
        echo -e "\e[32m[*]\e[0m Insertando alias de nvim en la zshrc ...\n"
        sed -i "/alias icat='kitty +kitten icat'/a alias nvim='\/opt\/nvim-linux64\/bin\/nvim'" $directorio_instalacion/zshrc &>/dev/null 
        sed -i "/alias icat='kitty +kitten icat'/a # nvim" $directorio_instalacion/zshrc &>/dev/null 
        sed -i '/alias icat='\''kitty +kitten icat'\''/{G;}' $directorio_instalacion/zshrc &>/dev/null 
        sed -i "/alias icat='kitty +kitten icat'/a alias nvim='\/opt\/nvim-linux64\/bin\/nvim'" $directorio_instalacion/.zshrc &>/dev/null 
        sed -i "/alias icat='kitty +kitten icat'/a # nvim" $directorio_instalacion/.zshrc &>/dev/null 
        sed -i '/alias icat='\''kitty +kitten icat'\''/{G;}' $directorio_instalacion/.zshrc &>/dev/null 
        break
    elif [ "$code_editor" = "vscode" ]; then
        echo -e "\e[32m[*]\e[0m Instalando vscode ...\n"
        wget  https://vscode.download.prss.microsoft.com/dbazure/download/stable/0ee08df0cf4527e40edc9aa28f4b5bd38bbff2b2/code_1.85.1-1702462158_amd64.deb &>/dev/null 
        apt install ./code_1.85.1-1702462158_amd64.deb &>/dev/null 
        break
    else
        echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
    fi
done

# DRIVERS PROPIETARIOS NVIDIA
while true; do
    read -p "$(echo -e "\e[33m[*]\e[0m ¿Estás usando kali linux en nativo y instalar los drivers propietarios de nvidia? (SI/NO): ")" drivers_nvidia
    drivers_nvidia=$(echo "$drivers_nvidia" | tr '[:upper:]' '[:lower:]')

    if [ "$drivers_nvidia" = "si" ] || [ "$drivers_nvidia" = "s" ]; then
        echo -e "\e[32m[*]\e[0m Instalando los drivers propietarios de nvidia ...\n"
        apt install nvidia-detect nvidia-smi nvidia-driver nvidia-cuda-toolkit -y &>/dev/null 
        break
    elif [ "$drivers_nvidia" = "no" ] || [ "$drivers_nvidia" = "n" ]; then
        echo -e "\e[31m[*]\e[0m Los drivers propietarios de nvidia no han sido instalados.\n"
        break
    else
        echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
    fi
done

# SUSTITUIMOS USER_REPLACE POR EL USUARIO ELEGIDO
echo -e "\e[32m[*]\e[0m Configurando ficheros ...\n"
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/polybar/* &>/dev/null 
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/polybar/scripts/* &>/dev/null 
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/bspwm/* &>/dev/null 
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/bspwm/scripts* &>/dev/null 
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/sxhkd/* &>/dev/null 
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/p10k.zsh &>/dev/null 
sed -i "s/user_replace/$input_username/g" $directorio_instalacion/zshrc &>/dev/null 

# OBTENEMOS LAS INTERFACES DE RED
interfaces=$(ip -o link show | awk -F': ' '{print $2}')

wifi_interface=""
for interface in $interfaces; do
    if [[ $interface == *"wl"* ]]; then
        wifi_interface=$interface
        break
    fi
done

ethernet_interface=""
for interface in $interfaces; do
    if [[ $interface == *"en"* || $interface == *"eth"* ]]; then
        ethernet_interface=$interface
        break
    fi
done

# SUSTITUIMOS LAS INTERFACES DE RED EN LOS SCRIPTS DE LA POLYBAR
sed -i "s/ethernet_replace/$ethernet_interface/g" "$directorio_instalacion/polybar/scripts/*" &>/dev/null 
sed -i "s/wifi_replace/$wifi_interface/g" "$directorio_instalacion/polybar/scripts/*" &>/dev/null 

# SUSTITUIMOS LA BATERÍA Y EL ADAPTADOR
battery="$(ls -1 /sys/class/power_supply/ | cut -d'/' -f8- | tail -n 1)"
adapter="$(ls -1 /sys/class/power_supply/ | cut -d'/' -f8- | head -n 1)"
sed -i "s/battery_replace/$battery/g" "$directorio_instalacion/polybar/config.ini" &>/dev/null 
sed -i "s/adapter_replace/$adapter/g" "$directorio_instalacion/polybar/config.ini" &>/dev/null 

# CONFIGURANDO FONTS
echo -e "\e[32m[*]\e[0m Configurando fonts ...\n"
cp -r fonts /usr/local/share 

# CONFIGURANDO WALLPAPERS
echo -e "\e[32m[*]\e[0m Configurando wallpapers ...\n"
cp -r Wallpapers /home/$input_username

# CONFIGURANDO BETTERLOCKSCREEN
echo -e "\e[32m[*]\e[0m Configurando betterlockscreen ...\n"
betterlockscreen -u /home/$input_username/Wallpapers &>/dev/null 

# CONFIGURANDO SXHKD
echo -e "\e[32m[*]\e[0m Configurando sxhkd ...\n"
cp -r sxhkd /home/$input_username/.config

# CONFIGURANDO KITTY
echo -e "\e[32m[*]\e[0m Configurando kitty ...\n"
cp -r kitty /home/$input_username/.config
cp -r kitty /root/.config

# CREAMOS UN LINK SIMBÓLICO ENTRE LOS ARCHIVOS DE CONFIGURACIÓN DE LA KITTY DEL USUARIO ELEGIDO Y LOS DE ROOT
echo -e "\e[32m[*]\e[0m Creando link simbólico en kitty.conf y kitty.color ...\n"
ln -s -f /home/$input_username/.config/kitty /root/.config/kitty

# CONFIGURANDO PICOM
echo -e "\e[32m[*]\e[0m Configurando picom ...\n"
cp -r picom /home/$input_username/.config

# CONFIGURANDO PLUGIN SUDO ZSH
echo -e "\e[32m[*]\e[0m Configurando plugin zsh-sudo ...\n"
cp -r zsh-sudo /usr/share

# CONFIGURANDO BSPWM
echo -e "\e[32m[*]\e[0m Configurando bspwm ...\n"
cp -r bspwm /home/$input_username/.config
cd /home/$input_username/.config/bspwm 
chmod +x bspwmrc  
cd /home/$input_username/.config/bspwm/scripts 
chmod +x * 
cd "$directorio_instalacion"

# CONFIGURANDO ROFI
echo -e "\e[32m[*]\e[0m Configurando rofi ...\n"
cp -r rofi /home/$input_username/.config 
cd /home/$input_username/.config/rofi  
cd launcher  
chmod +x launcher.sh 
cd ../powermenu 
chmod +x powermenu.sh
cd "$directorio_instalacion"

# CONFIGURANDO POLYBAR
echo -e "\e[32m[*]\e[0m Configurando polybar ...\n"
cp -r polybar /home/$input_username/.config
cd /home/$input_username/.config/polybar/scripts 
chmod +x *
mkdir /home/$input_username/.config/bin &>/dev/null 
touch /home/$input_username/.config/bin/target &>/dev/null 
cd "$directorio_instalacion"

# CONFIGURANDO POWERLEVEL10K
echo -e "\e[32m[*]\e[0m Configurando powerlevel10k del usuario $input_username ...\n"
rm -rf /home/$input_username/powerlevel10k &>/dev/null 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$input_username/powerlevel10k &>/dev/null 
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>/home/$input_username/.zshrc &>/dev/null 
mv zshrc .zshrc &>/dev/null 
mv p10k.zsh .p10k.zsh &>/dev/null 
cp .p10k.zsh /home/$input_username
cp .zshrc /home/$input_username

# CONFIGURANDO POWERLEVEL10K DE ROOT
echo -e "\e[32m[*]\e[0m Configurando powerlevel10k del usuario root ...\n"
rm -rf /root/powerlevel10k &>/dev/null 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k &>/dev/null 
sh -c "echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> /root/.zshrc" &>/dev/null 
cp .p10k.zsh /root 
cp .zshrc /root

# CREAMOS UN LINK SIMBÓLICO ENTRE LA ZSHRC DEL USUARIO ELEGIDO Y LA ZSHRC DE ROOT
echo -e "\e[32m[*]\e[0m Creando link simbólico en la zshrc ...\n"
ln -s -f /home/$input_username/.zshrc /root/.zshrc

# CREAMOS UN LINK SIMBÓLICO ENTRE LA P10K DEL USUARIO ELEGIDO Y EL P10K DE ROOT
echo -e "\e[32m[*]\e[0m Creando link simbólico en el archivo p10k.zsh ...\n"
ln -s -f /home/$input_username/.p10k.zsh /root/.p10k.zsh

# LE ASIGNAMOS EL PROPIETARIO CORRECTO A LOS ARCHIVOS
echo -e "\e[32m[*]\e[0m Asignando el propietario correcto a los archivos de configuración ...\n"
chown -R $input_username:$input_username /home/$input_username

# ACTIVACIÓN CLIPBOARD BIDIRECCIONL
while true; do
    read -p "$(echo -e "\e[33m[*]\e[0m ¿Estas usando VmWare y deseas activar la clipboard bidireccional? (SI/NO): ")" respuesta_clipboard
    respuesta_clipboard=$(echo "$respuesta_clipboard" | tr '[:upper:]' '[:lower:]')

    if [ "$respuesta_clipboard" = "si" ] || [ "$respuesta_clipboard" = "s" ]; then
        echo -e "\e[32m[*]\e[0m La clipboard bidireccional ha sido configurada con éxito.\n"
        echo -e '\n#clipboard bidireccional\nvmware-user-suid-wrapper &' >> /home/$input_username/.config/bspwm/bspwmrc
        break
    elif [ "$respuesta_clipboard" = "no" ] || [ "$respuesta_clipboard" = "n" ]; then
        echo -e "\e[31m[*]\e[0m La clipboard bidireccional no ha sido activada.\n"
        break
    else
        echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
    fi
done

# ELIMINAMOS LOS PAQUETES QUE NO SON NECESARIOS
echo -e "\e[32m[*]\e[0m Eliminando paquetes apt innecesarios ...\n"
apt autoremove -y &>/dev/null 

# ELIMINAMOS LOS ARCHIVOS DE CACHÉ
echo -e "\e[32m[*]\e[0m Limpiando caché de paquetes apt ...\n"
apt clean 

# ENTORNO BSPWM CONFIGURADO CON ÉXITO
echo -e "\e[32m[*]\e[0m ¡El entorno bspwm ha sido instalado con éxito!\n"

# REINICIO DE BSPWM
while true; do
    echo -e "\e[32m[*]\e[0m Se requiere volver a iniciar sesión para que cargue correctamente\n"
    read -p "$(echo -e "\e[33m[*]\e[0m ¿Desea hacerlo ahora? (SI/NO): ")" reboot_bspwm
    reboot_bspwm=$(echo "$reboot_bspwm" | tr '[:upper:]' '[:lower:]')

    if [ "$reboot_bspwm" = "si" ] || [ "$reboot_bspwm" = "s" ]; then
        echo -e "\e[32m[*]\e[0m Reiniciando entorno bspwm ...\n"
        bspc -quit
        break
    elif [ "$reboot_bspwm" = "no" ] || [ "$reboot_bspwm" = "n" ]; then
        echo -e "\e[31m[*]\e[0m No se reiniciará el entorno bspwm.\n"
        break
    else
        echo -e "\e[31m[*]\e[0m Respuesta no válida. Por favor, responde 'SI' o 'NO'.\n"
    fi
done

