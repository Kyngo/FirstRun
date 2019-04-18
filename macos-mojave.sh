#!/bin/bash

PACKAGES="git node htop"
CASKS="visual-studio-code postman google-chrome firefox telegram iterm2 "
NODEPKGS="yarn npx gtop nodemon react-native-cli"

echo "=========================================="
echo " First Run Scripts - macOS Mojave Edition "
echo "=========================================="
echo ""
echo "WARNING: This script hasn't been yet tested."
echo ""
echo "Running this in a non-compatible OS could damage it and leave it unfunctional."
echo "Use at your own risk."
echo ""

if [ $EUID -eq 0 ]; then
    echo "This script must NOT be run as root or with sudo!"
    echo "Root password will be asked once it is needed."
    exit 1
fi

# homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask

# packages
for idx in $PACKAGES; do
    echo "Installing package $idx ..."
    brew install $idx
done

# casks
for idx in $CASKS; do
    echo "Installing cask $idx ..."
    brew install $idx
done

# apache2
echo "Installing apache dependencies..."
brew install openldap libiconv openssl
echo "Creating certificates and Diffie-Hellman key..."
cd /usr/local/etc/httpd
openssl dhparam -out /etc/ssl/dhparams.pem 2048
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
sudo apachectl stop
echo "Installing apache..."
brew install httpd
cp /usr/local/etc/httpd/httpd.conf /usr/local/etc/httpd/httpd.conf.bkp
cp /usr/local/etc/httpd/extra/httpd-ssl.conf /usr/local/etc/httpd/extra/httpd-ssl.conf.bkp

echo "Configuring apache..."
sudo sed -i -e 's|/usr/local/var/www|'"$HOME"'/Sites|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|Listen 8080|Listen 80|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|AllowOverride None|AllowOverride All|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|# LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|User daemon|User '"$USER"'|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|Group daemon|Group staff|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|#ServerName www.example.com:8080|ServerName localhost' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|DirectoryIndex index.html|DirectoryIndex index.php index.html|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|#LoadModule socache_shmcb_module lib/httpd/modules/mod_socache_shmcb.so|LoadModule socache_shmcb_module lib/httpd/modules/mod_socache_shmcb.so|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|#LoadModule ssl_module lib/httpd/modules/mod_ssl.so|LoadModule ssl_module lib/httpd/modules/mod_ssl.so|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|#Include /usr/local/etc/httpd/extra/httpd-ssl.conf|Include /usr/local/etc/httpd/extra/httpd-ssl.conf|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|#Include /usr/local/etc/httpd/extra/httpd-vhosts.conf|Include /usr/local/etc/httpd/extra/httpd-vhosts.conf|g' /usr/local/etc/httpd/httpd.conf
sudo sed -i -e 's|Listen 8443|Listen 443|g' /usr/local/etc/httpd/extra/httpd-ssl.conf
sudo sed -i -e 's|DocumentRoot "/usr/local/var/www"|#DocumentRoot "/usr/local/var/www"|g' /usr/local/etc/httpd/extra/httpd-ssl.conf
sudo sed -i -e 's|ServerName www.example.com:8443|#ServerName www.example.com:8443|g' /usr/local/etc/httpd/extra/httpd-ssl.conf

cat >> /usr/local/etc/httpd/httpd.conf << EOF
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>

SSLHonorCipherOrder	    On
Header			        always set Strict-Transport-Security "max-age=63072000; includeSubdomains; preload"
SSLCipherSuite		    ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
SSLProtocol		        -All +TLSv1.2
SSLProxyProtocol	    -All +TLSv1.2
SSLCompression		    Off
SSLSessionTickets	    Off
SSLOpenSSLConfCmd	    DHParameters "/etc/ssl/dhparams.pem"
ServerTokens		    Prod
ServerSignature		    Off
Header			        always append X-Frame-Options SAMEORIGIN
Header			        set Access-Control-Allow-Origin "*"

LoadModule php5_module /usr/local/opt/php@5.6/lib/httpd/modules/libphp5.so
#LoadModule php7_module /usr/local/opt/php@7.0/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.1/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.2/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.3/lib/httpd/modules/libphp7.so
EOF

cat > /usr/local/etc/httpd/extra/httpd-vhosts.conf << EOF
<VirtualHost *:80>
    DocumentRoot "$HOME/Sites"
    ServerName localhost
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot "$HOME/Sites"
    ServerName localhost
    SSLEngine on
    SSLCertificateFile "/usr/local/etc/httpd/server.crt"
    SSLCertificateKeyFile "/usr/local/etc/httpd/server.key"
</VirtualHost>
EOF

mkdir -pv ~/Sites
echo "<h1>Hello world!</h1>" > ~/Sites/index.html
echo "<?php phpinfo();" > ~/Sites/info.php

# php
echo "Installing and configuring PHP..."
brew tap exolnet/homebrew-deprecated
brew install php@5.6
brew install php@7.0
brew install php@7.1
brew install php@7.2
brew install php@7.3
brew unlink php@7.3 && brew link --force --overwrite php@5.6

sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /usr/local/etc/php/5.6/php.ini
sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /usr/local/etc/php/7.0/php.ini
sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /usr/local/etc/php/7.1/php.ini
sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /usr/local/etc/php/7.2/php.ini
sudo sed -i -e 's|;date.timezone =|date.timezone = Europe/Madrid|g' /usr/local/etc/php/7.3/php.ini

curl -L https://gist.githubusercontent.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2/raw > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp
sudo brew services start httpd

# mariadb
echo "Installing and configuring MariaDB..."
brew install mariadb
brew services start mariadb
/usr/local/bin/mysql_secure_installation

# dnsmasq
echo "Installing and configuring dnsmasq..."
brew install dnsmasq
echo 'address=/.test/127.0.0.1' > /usr/local/etc/dnsmasq.conf
sudo brew services start dnsmasq
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'

# finished setup
echo "Apache Installation finished. The settings file will be opened now, in case you want to edit it."
code /usr/local/etc/httpd/httpd.conf