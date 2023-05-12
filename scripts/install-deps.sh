#!/bin/bash

# Update packges
sudo apt-get update

## Dependecies to build ngtcp2, nghttp3
# Install make,gcc
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y make gcc 

# Install requirements for tcp2
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

## Chromium install deps

# Dependecies for running chromium ( After binary is available )
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gperf
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev

### THIS command is PROJECT specific ### 
# Chrome build scripts install deps
sudo /proj/FEC-HTTP/long-quic/chromium/src/build/install-build-deps.sh

echo "$MYVAR"
echo "Install deps success!"