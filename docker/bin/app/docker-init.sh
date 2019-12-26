#!/bin/bash
echo 'WebApp container for LARA7 started'
echo "UID : $UID"
sudo /usr/sbin/apache2ctl -D FOREGROUND # Starts apache service