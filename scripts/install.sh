#!/bin/bash

# This script automates some of the tedious parts of installing my OS from a clean slate.
# It's very specific to me, so I wouldn't recommend trying it for anyone else looking at this·

cRed="\e[0;91m"
cBlue="\e[0;94m"
cGreen="\e[0;92m"
fBold="\e[1m"
fReset="\e[0m"

## ------------- INITIAL STEPS -------------##

# check if this is a laptop
read -p "Is this a laptop? [y/n]: " isDeviceLaptop

# get my current email address
read -p "Your email address:" myEmailAddress

# get my github user name
read -p "Your GitHub username:" githubUserName

## ------------- MISC -------------##

# setup ssh for github
echo -e "${cRed}${fBold}>> Setting up ssh for GitHub... ${fReset}"
ssh-keygen -t ed25519 -C myEmailAddress
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo $(cat ~/.ssh/id_ed25519.pub) >> ~/Desktop/SSH_Key.txt

# put bios access issues fix doc on desktop
if [[ $isDeviceLaptop == "y" ]]; then
# put battery tip guide on desktop
echo "Battery life tips. These have to be done for good battery life.
1) Turn off HiDPI deamon and other HiDPI settings in setings > display.
2) Change display refresh rate to 60hz. Make sure it persists after a reboot.
3) Turn down brightness.
4) Turn off bluetooth.
5) Ensure Graphics mode is on integrated.
6) Ensure CPU scheduler is not set to performance.
7) Add this as a startup task to startup applications: rfkill block bluetooth or... edit the
bluetooth auto-on setting. So when you turn it off, it'll stay off until you turn it back on again.
    sudo nano /etc/bluetooth/main.conf
    change AutoEnable=true > AutoEnable=false
" >> ~/Desktop/Battery_Life_TODO_List.txt

# remove unwanted programs
echo -e "${cRed}${fBold}>> Removing unwanted pre-installed software... ${fReset}"
sudo apt remove firefox thunderbird -y

## ------------- PROGRAMS -------------##

# setup some repositories
sudo add-apt-repository -y ppa:linuxuprising/apps
sudo add-apt-repository ppa:lutris-team/lutris --yes

# Fix dependencies
echo -e "${cRed}${fBold}>> Fixing dependencies... ${fReset}"
sudo apt install -f -y

# install PIA
echo -e "${cRed}${fBold}>> Installing .run packages... ${fReset}"
./*.run

# install other stuff from apt
echo -e "${cRed}${fBold}>> Installing stuff from apt... ${fReset}"

# add keys for albert
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null

# setup unity hub source
sudo sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
wget -qO - https://hub.unity3d.com/linux/keys/public | sudo apt-key add -

# setup dotnet sdk
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# setup appimage launcher
sudo add-apt-repository ppa:appimagelauncher-team/stable -y

# update apt AFTER all repositories have been added
sudo apt update -y

# install appimagelauncher NOW
sudo apt install appimagelauncher curl -y

# download google-chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ~/Downloads/chrome.deb

# download teamviewer
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -O ~/Downloads/teamviewer.deb

# download youtube music
curl -s https://api.github.com/repos/th-ch/youtube-music/releases/latest | grep "browser_download_url.*AppImage" | cut -d : -f 2,3 | tr -d \" | wget -qi - -O ~/Downloads/ytmusic.AppImage

# install downloaded software
sudo dpkg -i ~/Downloads/chrome.deb
sudo dpkg -i ~/Downloads/teamviewer.deb
ail-cli integrate ~/Downloads/ytmusic.AppImage

# remove downloaded suff
rm -rf ~/Downloads/*.deb
rm -rf ~/Downloads/*.AppImage

# fix any dependency errors
sudo apt install -f

# install programs etc
sudo apt install build-essential openjdk-8-jdk-headless openjdk-8-jre-headless gdb -y
sudo apt install vscode libusb-1.0-0-dev apt-transport-https -y
sudo apt install git flatpak timeshift sqlitebrowser unrar ufw -y
sudo apt install gnome-tweaks neofetch thefuck samba git autokey-gtk htop -y
sudo apt install ffmpeg dotnet-sdk-5.0 cifs-utils python3-pip -y
sudo apt install pavucontrol albert tlpui lutris trash-cli unityhub -y
sudo apt install apt-transport-https dotnet-sdk-6.0 -y

# install laptop specific software
if [[ $isDeviceLaptop == "y" ]]; then
  echo -e "${cRed}${fBold}>> Device is a Laptop, installing Laptop specific software... ${fReset}"
  sudo apt install caffeine powertop tlp -y
  sudo tlp start
  echo -e "${cRed}${fBold}>> Switching to integrated graphics... ${fReset}"
  sudo system76-power graphics integrated
fi

# install flatpaks
echo -e "${cRed}${fBold}>> Installing flatpaks... ${fReset}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo --system
flatpak install flathub com.github.tchx84.Flatseal --system -y
flatpak install flathub io.github.prateekmedia.appimagepool --system -y
flatpak install flathub com.uploadedlobster.peek --user -y
flatpak install flathub com.ultimaker.cura --user -y
flatpak install flathub com.google.AndroidStudio --user -y
flatpak install flathub com.discordapp.Discord --user -y
flatpak install flathub io.github.wereturtle.ghostwriter --user -y
flatpak install flathub org.videolan.VLC --user -y
flatpak install flathub org.shotcut.Shotcut --user -y
flatpak install flathub org.filezillaproject.Filezilla --user -y
flatpak install flathub com.valvesoftware.Steam --user -y
flatpak install flathub org.openshot.OpenShot --user -y
flatpak install flathub org.kde.kdenlive --user -y
flatpak install flathub io.github.shiftey.Desktop --user -y
flatpak install flathub com.dropbox.Client --user -y
flatpak install flathub org.qbittorrent.qBittorrent --user -y
flatpak install flathub io.github.mimbrero.WhatsAppDesktop --user -y
flatpak install flathub com.getpostman.Postman --user -y
flatpak install flathub sa.sy.bluerecorder --user -y
flatpak install flathub org.signal.Signal --user -y
flatpak install flathub org.ksnip.ksnip --user -y
flatpak install flathub org.soundconverter.SoundConverter --user -y
flatpak install flathub fr.handbrake.ghb --user -y

# install youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

## ------------- FILES/DIRECTORY RESTORATION -------------##

mkdir -p ~/Applications
mkdir -p ~/Documents/Tools
mkdir -p ~/.local/share/fonts
mkdir -p ~/Documents/Projects/Unity
mkdir -p ~/Documents/Projects/Android
mkdir -p ~/Documents/Projects/Linux
cp -r fonts/*.otf ~/.local/share/fonts/
cp -r fonts/*.ttf ~/.local/share/fonts/
cp SendSwitchPayload ~/Applications
cp fusee-primary.bin ~/Documents/Tools

# permissions
chmod +x ~/Applications/SendSwitchPayload

# set git global config
git config --global user.name githubUserName
git config --global user.email myEmailAddress

## ------------- FINISHING STEPS -------------##

# cleanup any crap
sudo apt autoremove -y

# setup aliases
printf "\n# aliases" >> ~/.bashrc
printf "\nalias cs='clear'" >> ~/.bashrc
printf "\nalias publicip='dig +short myip.opendns.com @resolver1.opendns.com'" >> ~/.bashrc
printf "\nalias bootswitch='cd ~/Applications && sudo ./SendSwitchPayload'" >> ~/.bashrc
printf "\nalias home='cd ~'" >> ~/.bashrc
printf "\nalias projects='cd ~/Documents/Projects'" >> ~/.bashrc
#printf "\nexport PATH=$PATH:/usr/share/code/" >> ~/.bashrc
printf "\neval $(thefuck --alias)" >> ~/.bashrc
printf "\n" >> ~/.bashrc

# setup links
#sudo ln -s /usr/bin/python3 /usr/local/bin/python

# update bashrc
source ~/.bashrc

# set gnome dash/panel favourite apps
gsettings set org.gnome.shell favorite-apps "['pop-cosmic-launcher.desktop', 'pop-cosmic-workspaces.desktop', 'pop-cosmic-applications.desktop', 'org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'chrome-mclfpggkokfcnkpjpnhbkmhlmgdppmoj-Default.desktop', 'chrome-jlhoajbaojeilbdnlldgecmilgppanbh-Default.desktop', 'discord.desktop', 'io.github.mimbrero.WhatsAppDesktop.desktop', 'org.signal.Signal.desktop', 'youtube-music.desktop', 'photoshop.desktop', 'org.ksnip.ksnip.desktop', 'sa.sy.bluerecorder.desktop', 'org.gnome.Calculator.desktop', 'ghostwriter.desktop', 'org.gnome.gedit.desktop', 'code.desktop', 'org.gnome.Terminal.desktop', 'unityhub.desktop', 'com.google.AndroidStudio.desktop', 'github-desktop.desktop', 'appimagekit_a487a2735412e927b14c85fdc24915a4-Cura.desktop', 'chrome-kiapgmmlgfkmgchepklkopepcddojnnd-Default.desktop']"

# enable firewall
#sudo ufw enable

echo -e "${cRed}${fBold}>> Updating system now... ${fReset}"
sudo apt update -y
sudo apt upgrade -y

echo -e "${cRed}${fBold}>> All done. Enjoy your new system! ${fReset}"

# now we need to reboot (for libvirt etc, show a countdown so it doesn't come as a surprise)
for i in {5..0}; do
  echo -en "\rRebooting in $i seconds...";
  sleep 1;
done
