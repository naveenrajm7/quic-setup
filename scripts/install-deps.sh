#!/bin/bash

# Update packges
sudo apt-get update

## Dependecies to build ngtcp2, nghttp3
# Install make,gcc
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y make gcc 

# Install requirements for ngtcp2
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y pkg-config autoconf autotools-dev libtool 

# Install dependencies To build sources under the examples directory
# cunit
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libcunit1 libcunit1-doc libcunit1-dev
# for C++
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y g++
# Libev
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libev-dev

# Get Cmake
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

## Network stuff
# install iperf3
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iperf3

# Install trace-cmd for managing kernel tracing (tcp-probe)
sudo apt install -y trace-cmd

## Chromium install deps

# Dependecies for running chromium ( After binary is available )
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gperf
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev

# https://support.circleci.com/hc/en-us/articles/360004086734-error-while-loading-shared-libraries-libgconf-2-so-4-cannot-open-shared-object-file-No-such-file-or-directory?utm_source=google&utm_medium=sem&utm_campaign=sem-google-dg--uscan-en-dsa-tROAS-auth-brand&utm_term=g_-_c__dsa_&utm_content=&gclid=CjwKCAjwvpCkBhB4EiwAujULMt06j8zJp2YWP6idiNv09G_n-
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libgconf-2-4

### THIS command is PROJECT specific ### 
# Chrome build scripts install deps
# sudo "/proj/$PROJECT/long-quic/chromium/src/build/install-build-deps.sh"

sudo echo "$PROJECT"
echo "Install deps success!"