#!/bin/bash

# Install Apache
sudo apt install apache2 -y

# Install http2 module
sudo a2enmod http2

# Install ssl module
sudo a2enmod ssl

# Create TLS cert
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -config /proj/FEC-HTTP/long-quic/long-look-quic/tcp/leaf.cnf

# Install wgsi packages
sudo apt-get install libapache2-mod-wsgi-py3

# Make sure flask-app.wsgi is present

# Make sure python virtual env is present

# Make sure flask is installed in python virtual env

# Create apache virtual host file 
sudo cp /proj/FEC-HTTP/long-quic/long-look-quic/tcp/flask.conf /etc/apache2/sites-available/flask.conf

# Enable flask site
sudo a2ensite flask.conf

# Check config
sudo apachectl -t

# Give permission to home directory
sudo chmod 755  /proj/FEC-HTTP/

# Enable and start apache
sudo systemctl enable apache2 && sudo systemctl start apache2

# Check status
sudo systemctl status apache2