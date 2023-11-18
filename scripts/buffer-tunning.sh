#!/bin/bash

# switch to root
sudo su

echo "10000000 30000000 50000000" > /proc/sys/net/ipv4/tcp_wmem
echo "10000000 30000000 50000000" > /proc/sys/net/ipv4/tcp_rmem
echo "10000000 30000000 50000000" > /proc/sys/net/ipv4/tcp_mem

echo 30000000 > /proc/sys/net/core/wmem_default
echo 50000000 > /proc/sys/net/core/wmem_max
echo 30000000 > /proc/sys/net/core/rmem_default
echo 50000000 > /proc/sys/net/core/rmem_max

# exit root
exit