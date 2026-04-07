#!/bin/bash
echo "========================================================="
echo "==!! This is a testing framework - Use at your own risk!!!=="
echo "==!! There will be a full planned rewrite testing different forms!!=="
echo "========================================================="
echo ""
DNS_DOMAIN_NAME="$1"
SSL_CERT_EMAIL="$2"
if [[ -z "$DNS_DOMAIN_NAME" ]]; then
    echo "Set a valid Private DNS Domain Name"
    exit 1
fi

if [[ -z "$SSL_CERT_EMAIL" ]]; then
    echo "Set a valid Email Address To Get Certificate From Let's Encrypt"
    exit 1
fi
#
#
#
# Setting Up Ubuntu To Fetch PHP7.0 Source
#
#
# Requesting User To Provide A Valid Domain Name For Android Private DNS
#
echo ""
echo "=============================="
echo "Setting Nginx To Use The Given Domain Name"
echo "=============================="
echo ""
sudo touch /etc/nginx/sites-available/pihole
echo "server {
            listen 80;
            listen [::]:80;
            root /var/www/html;
            server_name {dns_domain_name};
            autoindex off;
            index pihole/index.php index.php index.html index.htm;
            location / {
                    expires max;
                    try_files $uri $uri/ =404;
            }
            location ~ \.php$ {
                    include snippets/fastcgi-php.conf;
                    fastcgi_pass unix:/run/php/php7.0-fpm.sock;
            }
            location /*.js {
                    index pihole/index.js;
            }
            location /admin {
                    root /var/www/html;
                    index index.php index.html index.htm;
            }
            location ~ /\.ht {
                    deny all;
            }
    }" > /etc/nginx/sites-available/pihole
sudo sed -i 's/{dns_domain_name}/'$DNS_DOMAIN_NAME'/g' /etc/nginx/sites-available/pihole
sudo ln -s /etc/nginx/sites-available/pihole /etc/nginx/sites-enabled/pihole 
sudo nginx -t
sudo systemctl reload nginx
echo "=============================="
echo "Below Details are used to request for an SSL"
echo "Email : $SSL_CERT_EMAIL"
echo "Domain : $DNS_DOMAIN_NAME"
echo "=============================="
sudo certbot --nginx -m "$SSL_CERT_EMAIL" -d "$DNS_DOMAIN_NAME" -n --agree-tos --no-eff-email --preferred-chain="ISRG Root X1" --nginx
#
# Starting All Required Services
#
sudo service php7.0-fpm start
sudo service nginx start
echo ""
echo "=============================="
echo "Setting Up Nginx To Run A DNS Stream For Android Private DNS Feature"
echo "=============================="
echo ""
sudo service nginx restart
#
# All Done Now
#
echo ""
echo ""
echo ""
echo ""
echo "======================================================================================="
echo "Congrats Pi-Hole With Android Private DNS is configured."
echo ""
echo "Private DNS Domain : $DNS_DOMAIN_NAME"
echo ""
echo "Now you can use the domain name in your android phone to block adds"
echo "======================================================================================="
