#!/bin/bash

# Define log file for reporting errors
LOGFILE="/var/log/RocketPanel_setup.log"
exec > >(tee -a $LOGFILE) 2>&1

# Function to check the last command's exit status and log errors
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error occurred while executing: $1"
        echo "Please check the log file: $LOGFILE"
        exit 1
    fi
}

echo "Starting RocketPanel Installation..."

# Update and upgrade system packages
echo "Updating system..."
sudo apt update && sudo apt upgrade -y
check_status "system update"

# Install basic system dependencies
echo "Installing basic system dependencies..."
sudo apt install -y ufw fail2ban openssh-server
check_status "installing basic system dependencies"

# Configure UFW firewall
echo "Configuring UFW Firewall..."
sudo ufw allow OpenSSH
sudo ufw enable
check_status "configuring UFW"

# Install Apache and configure it
echo "Installing Apache..."
sudo apt install -y apache2
check_status "installing Apache"

# Change Apache ports from 80 and 443 to 8080 and 8443 respectively
echo "Configuring Apache ports..."
sudo sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-enabled/000-default.conf
sudo sed -i 's/Listen 443/Listen 8443/' /etc/apache2/sites-enabled/000-default.conf
sudo systemctl restart apache2
check_status "configuring Apache ports"

# Install Nginx and configure it
echo "Installing Nginx..."
sudo apt install -y nginx
systemctl restart nginx
check_status "installing Nginx"

# Install Phusion Passenger
echo "Installing Phusion Passenger module..."
# sudo apt install libnginx-mod-http-passenger
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y passenger
check_status "installing Phusion Passenger"

#Install Nginx RTMP
echo "Installing Nginx RTMP module..."
sudo apt install libnginx-mod-rtmp
systemctl restart nginx
check_status "installing Nginx RTMP module"

# Install PHP and dependencies
echo "Installing PHP and related packages..."
sudo apt install -y php php-fpm php-mysql php-pgsql php-xml php-curl php-zip php-mbstring
check_status "installing PHP"

# Install MariaDB
echo "Installing MariaDB..."
sudo apt install -y mariadb-server
check_status "installing MariaDB"

# Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt install -y postgresql
check_status "installing PostgreSQL"

# Install phpMyAdmin
# server, 
# echo "Installing phpMyAdmin..."
# sudo apt install -y phpmyadmin
# check_status "installing phpMyAdmin"

# Install FTP server
echo "Installing FTP server..."
sudo apt install -y vsftpd
check_status "installing FTP server"

# Install Postfix and Dovecot for email
# echo "Installing Postfix and Dovecot..."
# sudo apt install -y postfix dovecot-core dovecot-imapd dovecot-pop3d
# check_status "installing Postfix and Dovecot"

# # Install webmail clients
# echo "Installing Roundcube and Horde..."
# sudo apt install -y roundcube horde
# check_status "installing webmail clients"

# # Install SpamAssassin
# echo "Installing SpamAssassin..."
# sudo apt install -y spamassassin
# check_status "installing SpamAssassin"

# Install web analytics tools
echo "Installing Webalizer and AWStats..."
sudo apt install -y webalizer awstats
check_status "installing Webalizer and AWStats"

# Install ClamAV
echo "Installing ClamAV..."
sudo apt install -y clamav
check_status "installing ClamAV"

# Install Certbot and Cloudflare DNS plugin
echo "Installing Certbot and Cloudflare DNS plugin..."
sudo apt install -y certbot python3-certbot-dns-cloudflare
check_status "installing Certbot and Cloudflare DNS plugin"

# Install Node.js
echo "Installing Node.js..."
sudo apt install -y nodejs npm
check_status "installing Node.js"

# Install Ruby
echo "Installing Ruby..."
sudo apt install -y ruby
check_status "installing Ruby"

# Install Git
echo "Installing Git..."
sudo apt install -y git
check_status "installing Git"

# Install Python
# echo "Installing Python..."
# sudo add-apt-repository ppa:deadsnakes/ppa
# sudo apt update
# sudo apt install python3.12
# check_status "Installing Python"

# Install BIND for DNS (if needed)
echo "Installing BIND for DNS..."
sudo apt install -y bind9
check_status "installing BIND"

# Install SSL for localhost
echo "Installing SSL for localhost..."
sudo mkdir /var/www/SSL
sudo mkdir /var/www/SSL/RocketPanel
sudo chown root:www-data /var/www/SSL
sudo chown root:www-data /var/www/SSL/RocketPanel
sudo chmod 750 /var/www/SSL
sudo chmod 750 /var/www/SSL/RocketPanel
# Set up self-signed certificate for 127.0.0.1
sudo mkdir -p /etc/ssl/selfsigned
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /var/www/SSL/RocketPanel/localhost.key -out /var/www/SSL/RocketPanel/localhost.crt -subj "/CN=127.0.0.1"
sudo chown root:www-data /var/www/SSL/RocketPanel/localhost.crt
sudo chown root:www-data /var/www/SSL/RocketPanel/localhost.key
sudo chmod 640 /var/www/SSL/RocketPanel/localhost.crt
sudo chmod 640 /var/www/SSL/RocketPanel/localhost.key




# # Start the RocketPad Node.js application
# echo "Create the RocketPanel Service"
# cat <<EOF > /etc/systemd/system/rocketpanel.service
# [Unit]
# Description=RocketPanel Node.js Application
# After=network.target

# [Service]
# ExecStart=/usr/bin/node /var/www/RocketPanel/Application/RocketPanel.js
# WorkingDirectory=/var/www/RocketPanel/Application
# Restart=always
# User=www-data
# Group=www-data

# [Install]
# WantedBy=multi-user.target
# EOF

# # Reload systemd and start RocketPad service
# ech "Reload RocketPanel Service..."
# systemctl daemon-reload
# systemctl start rocketpanel
# systemctl enable rocketpanel

# sudo apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev
# sudo apt-get install libcurl4-openssl-dev 
# sudo apt-get install -y ruby-dev
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
# sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger jammy main > /etc/apt/sources.list.d/passenger.list'
# sudo apt-get update
# sudo apt-get install -y passenger
# sudo apt-get install -y passenger-dev
# git clone https://github.com/phusion/passenger.git
# cd passenger
# ./bin/passenger-install-nginx-module


# install in /usr/sbin/nginx



# echo "Installation completed successfully. Please check the log file: $LOGFILE"

# passenger start --port 3000 --app-type node --startup-file /var/www/RocketPanel/Application/RocketPanel.js


# Install Node.JS Dependencies
cd /var/www/RocketPanel
sudo npm install

# Create the Passenger Service and Start RocketPanel
echo "Create the Passenger Service"
cat <<EOF > /etc/systemd/system/passenger.service
[Unit]
Description=Phusion Passenger Standalone
After=network.target

[Service]
ExecStart=/usr/bin/passenger start --port 3000 --app-type node --startup-file /var/www/RocketPanel/Application/RocketPanel.js
Restart=always
User=www-data
Group=www-data
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable passenger
sudo systemctl start passenger
# Configure Nginx to serve a Node.js application
echo "Configuring RocketPanel"
sudo chown www-data:www-data /var/www/RocketPanel/Application/RocketPanel.js
sudo chmod 755 /var/www/RocketPanel/Application/RocketPanel.js
cat <<EOF > /etc/nginx/sites-available/RocketPanel
server {
    listen 443 ssl;
    server_name 127.0.0.1;
    ssl_certificate /var/www/SSL/RocketPanel/localhost.crt;
    ssl_certificate_key /var/www/SSL/RocketPanel/localhost.key;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable and restart Nginx
echo "Restarting NGINX Server..."
ln -s /etc/nginx/sites-available/RocketPanel /etc/nginx/sites-enabled/
systemctl restart nginx


# SSL
echo "Setting up SSL Directories..."
sudo mkdir /var/www/SSL/LetsEncrypt
cat <<EOF > /var/www/SSL/LetsEncrypt/set-permissions.sh
chmod 644 /etc/letsencrypt/live/*/fullchain.pem
chmod 644 /etc/letsencrypt/live/*/privkey.pem
chmod 755 /etc/letsencrypt/live
EOF
sudo chmod +x /var/www/SSL/LetsEncrypt/set-permissions.sh


# sudo ln -s /path/to/new/certificates/live/aldebaran.host-0001 /etc/letsencrypt/live/aldebaran.host-0001
# cat <<EOF > /var/www/SSL/LetsEncrypt/CloudFlare.ini
# dns_cloudflare_api_key = YOUR_CLOUDFLARE_API_KEY
# EOF
# sudo chmod 600 /var/www/SSL/LetsEncrypt/CloudFlare.ini

# sudo certbot register --update-registration --email yournewemail@example.com
# sudo certbot -a dns-cloudflare -i nginx -d "*.domain.com" -d "*.server.domain.com" --dns-cloudflare-credentials /etc/ssl/cloudflare.ini --dry-run

cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
enabled = true
bantime = 86400
ignoreip = 127.0.0.1 10.0.2.2 24.70.82.157
EOF
sudo systemctl restart fail2ban
