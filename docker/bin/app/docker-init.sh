#!/bin/bash
echo 'WebApp container for LARA7 started'

# Import our environment variables into Apache/PHP
sudo sed -i '$a export DB_CONNECTION='"$DB_CONNECTION" /etc/apache2/envvars
sudo sed -i '$a export DB_HOST='"$DB_HOST" /etc/apache2/envvars
sudo sed -i '$a export DB_PORT='"$DB_PORT" /etc/apache2/envvars
sudo sed -i '$a export DB_USERNAME='"$DB_USERNAME" /etc/apache2/envvars
sudo sed -i '$a export DB_PASSWORD='"$DB_PASSWORD" /etc/apache2/envvars

sudo /usr/sbin/apache2ctl -D FOREGROUND # Starts apache service