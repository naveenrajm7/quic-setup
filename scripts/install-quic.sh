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


# Instal OpenSSL 
git clone --depth 1 -b OpenSSL_1_1_1s+quic https://github.com/quictls/openssl
cd openssl
# For Linux
./config enable-tls1_3 --prefix=$PWD/build
make -j$(nproc)
make install_sw
cd ..

# Install nghttp3
git clone https://github.com/ngtcp2/nghttp3
cd nghttp3
autoreconf -i
./configure --prefix=$PWD/build --enable-lib-only
make -j$(nproc) check
make install
cd ..

# Install tcp2
git clone https://github.com/ngtcp2/ngtcp2
cd ngtcp2/
autoreconf -i
./configure PKG_CONFIG_PATH=$PWD/../openssl/build/lib/pkgconfig:$PWD/../nghttp3/build/lib/pkgconfig LDFLAGS="-Wl,-rpath,$PWD/../openssl/build/lib"
make -j$(nproc) check

# # Generate keys to start server
# cd ci
# ./gen-certificate.sh
# cd ..

# # Create example files to serve
# mkdir -p root
# touch hello.txt

