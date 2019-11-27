#!/bin/bash
echo 'WebApp container for LARA7 started'
# You can define custom scripts/commands here when container starts
/usr/sbin/apache2ctl -D FOREGROUND # Starts apache service
