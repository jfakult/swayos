#!/bin/bash
#
# This script installs SwayOS on a pre-installed arch linux
# A user with sudo permissions and a live network connection is needed
#

echo "This file (setup_arch.sh) assumes you have already cloned the sway-os repo manually"
echo "And are running this script manually"

# Set up logging
exec 1> >(tee "swayos_setup_out")
exec 2> >(tee "swayos_setup_err")

log(){
    echo "*********** $1 ***********"
    now=$(date +"%T")
    echo "$now $1" >> ~/swayos_setup_log
}

check(){
    if [ "$1" != 0 ]; then
	echo "$2 error : $1" | tee -a ~/swayos_setup_log
	exit 1
    fi
}

log "Refreshing package db"
sudo pacman -Syu
check "$?" "pacman"


log "Installing git"
sudo pacman -S --noconfirm --needed git


#log "Cloning swayOS repo"
#git clone https://github.com/swayos/swayos.github.io.git
#cd swayos.github.io


log "Installing needed official packages"
sudo pacman -S --needed - < packages/packages.txt
yay -S --needed - < packages/packages_aur.txt
check "$?" "pacman"


#log "Copying settings to home folder"
#cp -f -R home/. ~/
#check "$?" "cp"


log "Starting services"
sudo systemctl enable iwd --now
sudo systemctl enable bluetooth --now
sudo systemctl enable cups --now


#log "Installing aur packages"
#cat pacs/arch/aur | while read line 
#do
#    log "Installing $line"
#    git clone https://aur.archlinux.org/$line.git
#    cd $line
#    makepkg -si --skippgpcheck --noconfirm
#    check "$?" "makepkg"
#    sudo pacman -U --noconfirm *.pkg.tar.zst
#    check "$?" "pacman -U"
#    cd ..
#done


#log "Cleaning up"
#cd ..
#rm -f -R swayos.github.io
#check "$?" "rm"


#log "Changing shell to zsh"
chsh -s /bin/zsh
#check "$?" "chsh"


log "Setup is done, please log out and log in back again ( type exit )"