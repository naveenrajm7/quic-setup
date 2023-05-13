#!/bin/bash

# Ubuntu as lighttpd running, stop it to free up port for apache
sudo service lighttpd stop

# Install Apache
sudo apt install apache2 -y

# Install http2 module
sudo a2enmod http2

# Install ssl module
sudo a2enmod ssl

# Install Header module
sudo a2enmod headers

# Disable Deflate module
sudo a2dismod deflate -f

# Create TLS cert
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -config /proj/FEC-HTTP/long-quic/long-look-quic/tcp/leaf.cnf

# Install wgsi packages
sudo apt-get install libapache2-mod-wsgi-py3

# Make sure flask-app.wsgi is present

# Make sure python virtual env is present

# Make sure flask is installed in python virtual env

### THIS command is PROJECT specific ### 
# Create apache virtual host file 
sudo cp /proj/FEC-HTTP/long-quic/long-look-quic/tcp/flask.conf /etc/apache2/sites-available/flask.conf

# Check config
sudo apachectl -t

# Enable flask site
sudo a2ensite flask.conf

# Give permission to home directory
sudo chmod 755  /proj/FEC-HTTP/

# Activate new configuration
sudo systemctl reload apache

# Enable and start apache
sudo systemctl enable apache2 && sudo systemctl start apache2

# Check status
sudo systemctl status apache2