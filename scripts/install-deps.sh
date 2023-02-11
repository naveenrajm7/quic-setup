#!/bin/bash

# Update packges
sudo apt-get update

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

sudo whoami
sudo pwd 
sudo ls 

sudo echo "Install deps success!" > deps.log