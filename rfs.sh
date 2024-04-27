#!/bin/bash

YELLOW='\033[1;33m'
NOCOLOR='\033[0m'

# Checks if script is ran as root
if [[ $EUID -ne 0 ]]; then
clear
echo -e "${YELLOW}You must be a root user to run this script, please run sudo${NOCOLOR}"
exit 0
fi

# Dependencies
packages=("ffmpeg" "toilet" "ffmpeg-free" "wget")

package_installed_apt() {

    dpkg -s "$1" &> /dev/null
}

package_installed_rpm() {

    rpm -q "$1" &> /dev/null
}

# Downloads packages if they aren't installed already
for pkg in "${packages[@]}"; do
    if [ -f /etc/debian_version ]; then
        if ! package_installed_apt "$pkg"; then
        apt install "$pkg" -y
        fi 
    elif [ -f /etc/fedora-release ]; then
        if ! package_installed_rpm "$pkg"; then
        dnf install "$pkg" -y
        fi 
    else
        echo "Install script only works in Debian and Fedora"
        exit 0
    fi 
done

# Downloads main script
wget "https://raw.githubusercontent.com/Mystic3945/random_song/main/random_song"

# Places script in correct directories and assigns proper permissions
mv random_song /usr/local/bin/
chmod +x /usr/local/bin/random_song
username=${SUDO_USER:-$(whoami)}
chown "$username" /usr/local/bin/random_song

# If nemo is file manager add script to right click menu
if ps -ef | grep -q '[n]emo'; then
echo '#!/bin/bash
gnome-terminal -- /bin/bash -c "/usr/local/bin/random_song"' > /home/"$username"/.local/share/nemo/scripts/Play\ Random\ Song
chmod +x /home/"$username"/.local/share/nemo/scripts/Play\ Random\ Song
chown "$username" /home/"$username"/.local/share/nemo/scripts/Play\ Random\ Song
nemo_info="Or right click inside of any directory and 
click ${YELLOW}Play Random Song${NOCOLOR} under ${YELLOW}Scripts${NOCOLOR} "
fi

clear

# Displayus some info about the script before exiting
echo -e "





Simply naviagte to any directory and 
type  ${YELLOW}random_song${NOCOLOR}  to play random audio files

${nemo_info}





"
exit 0
