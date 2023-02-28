#!/bin/bash

# Compile quic
# Usage: compile-quic.sh <path-to-src-dir>

# take src path as argument
echo "I will compile in the path: $1"

# Get to the src path
cd $1

# TODO : test below steps, with hard coded repo names 
# If using private repo , make sure your github keys are in the nodes, 
# to be able to pull without auth

# # Instal OpenSSL 
# # Git clone if you want to fresh or do git pull if you want to fetch updates
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

# Install ngtcp2
git clone https://github.com/ngtcp2/ngtcp2
cd ngtcp2/
autoreconf -i
./configure PKG_CONFIG_PATH=$PWD/../openssl/build/lib/pkgconfig:$PWD/../nghttp3/build/lib/pkgconfig LDFLAGS="-Wl,-rpath,$PWD/../openssl/build/lib"
make -j$(nproc) check
