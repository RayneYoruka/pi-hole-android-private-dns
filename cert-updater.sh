#!/bin/bash
echo "========================================================="
echo "==!! Pi-Hole privateDNS certificate updater!=="
echo "========================================================="
echo ""

DNS_DOMAIN_NAME="$1"
SSL_CERT_EMAIL="$2"
WEB_ROOT="/var/www/html"

if [ -z "$DNS_DOMAIN_NAME" ]; then
  echo "🛑  Set a valid Private DNS Domain Name"
  exit 1
fi

if [ -z "$SSL_CERT_EMAIL" ]; then
  echo "🛑  Set a valid Email Address To Get Certificate From Let's Encrypt"
  exit 1
fi

#
#

echo ""
echo "=============================="
echo "Installing Python3 setting up virtual env and installing Certbot-nginx To Get SSL From Let's Encrypt"
echo "=============================="
echo ""
sudo apt-get -y install python3 python3-venv libaugeas0
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-nginx
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
echo ""
echo "=============================="
echo "Below Details are used to request for an SSL"
echo "Email : $SSL_CERT_EMAIL"
echo "Domain : $DNS_DOMAIN_NAME"
echo "=============================="
echo ""
sudo certbot  certonly --webroot -w "${WEB_ROOT}" --preferred-challenges http -m "$SSL_CERT_EMAIL" -d "$DNS_DOMAIN_NAME" -n --agree-tos --no-eff-email --preferred-chain="ISRG Root X1"
# You can simply set your email and domain name acordingly and simply run it with cron every 75 days.
#
# Starting All Required Services
#
echo ""
echo "=============================="
echo "Stopping Nginx's HTTP Server."
echo "=============================="
echo ""
sudo rm -rf /etc/nginx/sites-available/*
sudo rm -rf /etc/nginx/sites-enabled/*
sudo service nginx start

echo ""
echo "=============================="
echo "Setting Up Nginx To Run A DNS Stream For Android Private DNS Feature"
echo "=============================="
echo ""

if [ ! -d "/etc/nginx/streams/" ]; then
  sudo mkdir /etc/nginx/streams/
fi

sudo service nginx restart
#
# All Done Now
#
echo ""
echo ""
echo ""
echo ""
echo "======================================================================================="
echo "Congrats Pi-Hole With Android Private DNS has been updated."
echo ""
echo "Private DNS Domain : $DNS_DOMAIN_NAME"
echo "======================================================================================="
