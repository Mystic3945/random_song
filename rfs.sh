#!/bin/bash

YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

# Dependencies
packages=("ffmpeg" "toilet" "ffmpeg-free" "wget" "mplayer")

echo -e "${YELLOW}Checking for packages${NOCOLOR}"
sudo apt update

package_installed_apt() {

    sudo dpkg -s "$1" &> /dev/null
}

package_installed_rpm() {

    sudo rpm -q "$1" &> /dev/null
}

# Downloads packages if they aren't installed already
for pkg in "${packages[@]}"; do
    if [ -f /etc/debian_version ]; then
        if ! package_installed_apt "$pkg"; then
        sudo apt install "$pkg" -y
        fi 
    elif [ -f /etc/fedora-release ]; then
        if ! package_installed_rpm "$pkg"; then
        sudo dnf install "$pkg" -y
        fi 
    else
        echo "Install script only works in Debian and Fedora"
        exit 0
    fi 
done

# Downloads main script
wget "https://raw.githubusercontent.com/Mystic3945/random_song/main/random_song"

# Places script in correct directories and assigns proper permissions
sudo mv random_song /usr/local/bin/
sudo chmod +x /usr/local/bin/random_song
username=$(whoami)
sudo chown "$username" /usr/local/bin/random_song

# If nemo is file manager, add script to right click menu
if ps -ef | grep -q '[n]emo'; then
echo '#!/bin/bash
gnome-terminal -- /bin/bash -c "/usr/local/bin/random_song"' > /home/"$username"/.local/share/nemo/scripts/Play\ Random\ Song
chmod +x /home/"$username"/.local/share/nemo/scripts/Play\ Random\ Song
chown "$username" /home/"$username"/.local/share/nemo/scripts/Play\ Random\ Song
nemo_info="Or right click inside of any directory and 
click ${YELLOW}Play Random Song${NOCOLOR} under ${YELLOW}Scripts${NOCOLOR} "
fi

# If running in WSL, add script to right click menu
if [ -n "$WSL_DISTRO_NAME" ]; then
wget "https://raw.githubusercontent.com/Mystic3945/random_song/main/wsl_rightclick.bat"
cmd.exe /c wsl_rightclick.bat
windows_info="Or right click inside of any folder and 
click ${YELLOW}Play Random Song${NOCOLOR}"
sudo sed -i '72,75s/^/#/' /usr/local/bin/random_song
fi

# Displayus some info about the script before exiting
echo -e "





Simply naviagte to any directory and 
type  ${YELLOW}random_song${NOCOLOR}  to play random audio files

${nemo_info}${windows_info}"

exit 0
