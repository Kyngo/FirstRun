#!/bin/bash

# variables
SNAPS="spotify"
PACKAGES="nodejs npm chromium-browser google-chrome-stable vlc build-essential terminator variety git"
NODEPKGS="yarn npx gtop nodemon"

echo "===================================="
echo " First Run Scripts - Ubuntu Edition "
echo "===================================="
echo ""
echo "Running this in a non-compatible OS could damage it and leave it unfunctional."
echo "Use at your own risk."

# update system
function Update {
    sudo apt autoremove -y
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-upgrade -y
    sudo apt autoremove -y
}

cd /tmp

Update

# curl
if [ -f `which curl` ]; then 
    echo "no curl installation found"
    sudo apt install curl -y
else
    echo "curl found, skipping installation"
fi

# vscode
if [ `which code` == "" ]; then 
    echo "no vscode installation found"
    rm vscode.deb
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
    sudo dpkg -i vscode.deb
else
    echo "code found, skipping installation"
fi

# chrome
if [ -f /etc/apt/sources.list.d/google-chrome.list ]; then
    echo "chrome repo seems to be already present, skipping"
else
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
fi

# nodejs
if [ `which code` == "" ]; then 
    echo "no node installation found"
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
else
    echo "node installation found, skipping"
fi

# variety
sudo add-apt-repository ppa:peterlevi/ppa

Update

# snaps
for idx in $SNAPS; do
    echo "Installing snap $idx ..."
    sudo snap install $idx
done

# packages
for idx in $PACKAGES; do
    echo "Installing package $idx ..."
    sudo apt install $idx -y
done

# node global packages
for idx in $NODEPKGS; do
    echo "Installing module $idx ..."
    npm i -g $idx
done