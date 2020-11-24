#Requires -RunAsAdministrator

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n=allowGlobalConfirmation
choco install firefox
choco install mysql.workbench
choco install composer nvm
choco install powertoys
choco install nmap
choco install speccy
choco install burp-suite-free-edition
choco install adb
choco install yumi
choco install telegram
choco install spotify
choco install steam
choco install epicgameslauncher
choco install teamspeak
choco install drawio
choco install adobereader
choco install qbittorrent
choco install vagrant
choco install cpu-z
choco install python3
choco install pip
choco install gpu-z
choco install iperf3
choco install visualstudio2019community
choco install exiftool
choco install nano
choco install obs-studio
choco install git
choco install openssh
choco install ccleaner
choco install nodejs-lts
choco install curl
choco install libreoffice-fresh
choco install awscli
choco install virtualbox
choco install sublimetext3
choco install postman
choco install jq
choco feature disable -n=allowGlobalConfirmation
