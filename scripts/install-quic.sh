#!/bin/bash

# Install dependencies

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
# cd example
# mkdir -p root
# touch hello.txt

