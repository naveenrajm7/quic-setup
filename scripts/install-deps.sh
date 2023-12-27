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

# Install Bazel ( for building quiche)
sudo apt install apt-transport-https curl gnupg -y
sudo curl -fsSL https://bazel.build/bazel-release.pub.gpg | sudo gpg --dearmor >/tmp/bazel-archive-keyring.gpg
sudo mv /tmp/bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && sudo apt install bazel -y


## Certutil for adding certs to OS chain
# Install libnss3-tools
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss3-tools


# Install screen , to schedule experiment runs
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y screen

sudo echo "$PROJECT"
echo "Install deps success!"