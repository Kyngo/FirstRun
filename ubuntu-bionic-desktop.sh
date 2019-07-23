#!/bin/bash

# variables
SNAPS="spotify"
PACKAGES="nodejs npm chromium-browser google-chrome-stable vlc build-essential terminator variety git neofetch python3 python3-pip subnetcalc cockpit"
NODEPKGS="yarn npx gtop nodemon react-native-cli"
PYTHONPKGS="cheat"

echo "===================================="
echo " First Run Scripts - Ubuntu Edition "
echo "===================================="
echo ""
echo "Running this in a non-compatible OS could damage it and leave it unfunctional."
echo "Use at your own risk."
echo ""

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root or with sudo!"
    exit 1
fi

# update system
function __Update {
    sudo apt autoremove -y
    sudo apt update
    sudo apt upgrade -y
    sudo apt dist-upgrade -y
    sudo apt autoremove -y
}

cd /tmp

__Update

# curl
if [ -f `which curl` ]; then 
    echo "no curl installation found"
    sudo apt install curl -y
else
    echo "curl found, skipping installation"
fi

# vscode
if [ -z `which code` ]; then 
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
if [ -z `which node` ]; then 
    echo "no node installation found"
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
else
    echo "node installation found, skipping"
fi

# variety
if [ -z `which variety` ]; then 
    echo "no variety setup found, adding keys"
    yes | sudo add-apt-repository ppa:peterlevi/ppa
else
    echo "variety found, skipping"
fi

# php
if [ -z `which php` ]; then
    echo "no php found, installing"
    sudo apt install -y php7.2 php7.2-cli php7.2-fpm php7.2-mysql php7.2-xml php7.2-curl php7.2-opcache php7.2-pdo php7.2-gd php7.2-apcu php7.2-mbstring php7.2-imap php7.2-redis php7.2-memcached php7.2-mysqli php7.2-mysqlnd
else
    echo "php found, skipping"
fi

# composer
if [ -z `which composer` ]; then
    echo "no composer found, installing"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/bin/composer
    sudo chmod +x /usr/bin/composer
else
    echo "composer found, skipping"
fi

# telegram
if [ -z `which telegram` ]; then
    echo "no telegram found, installing"
    wget https://telegram.org/dl/desktop/linux -O telegram.tar.xz
    tar xf telegram.tar.xz
    sudo cp -r Telegram/ /opt/telegram
    sudo ln -s /opt/telegram/Telegram /usr/bin/telegram
else
    echo "telegram found, skipping"
fi

__Update

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

# python global packages
for idx in $PYTHONPKGS; do
    echo "Installing Python module $idx ..."
    python3 -m pip install $idx
done