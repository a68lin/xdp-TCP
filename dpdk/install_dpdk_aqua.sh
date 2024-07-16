#!/bin/bash

# Update package repositories
sudo apt update
sudo apt-get update

sudo apt upgrade -y

# Install dependencies
sudo apt install build-essential meson ninja-build python3-pyelftools libnuma-dev
sudo apt install -y build-essential linux-headers-$(uname -r) wget
sudo apt-get install pkg-config
sudo apt install libpcap-dev
sudo pip3 install meson ninja
sudo apt install libibverbs1 ibverbs-providers libibverbs-dev
sudo apt install python3-pyelftools

# Probably won't be necessary
sudo ln -s /usr/lib/x86_64-linux-gnu/libmlx4.so.1 /usr/lib/x86_64-linux-gnu/libmlx4.so
sudo ln -s /usr/lib/x86_64-linux-gnu/libibverbs.so.1 /usr/lib/x86_64-linux-gnu/libibverbs.so

# Download DPDK source code (adjust version as needed)
DPDK_VERSION="23.11"
wget http://fast.dpdk.org/rel/dpdk-${DPDK_VERSION}.tar.xz

# Extract DPDK source code
sudo tar -xf dpdk-${DPDK_VERSION}.tar.xz -C /opt
cd /opt/dpdk-${DPDK_VERSION}

# Set DPDK environment variables
export RTE_SDK=$(pwd)
export RTE_TARGET=x86_64-native-linuxapp-gcc

# Build DPDK
sudo meson build
sudo ninja -C build

cd build
sudo ninja install
sudo ldconfig

# Bind network interfaces to DPDK drivers (adjust as needed)
cd ../usertools
sudo modprobe -a ib_uverbs mlx4_en mlx4_core mlx4_ib


# Setup hugepages
#PAGE_SIZE="2M"
#TOTAL_SIZE="1G"
PAGE_SIZE="1G"
TOTAL_SIZE="24G"

sudo dpdk-hugepages.py -p ${PAGE_SIZE} --setup ${TOTAL_SIZE}

cd /etc/modprobe.d
sudo touch mlx4.conf
# sudo nano mlx4.conf
# Edit mlx4.conf and write:
# options mlx4_core log_num_mgm_entry_size=-1

# Reload mlx4
sudo modprobe -r mlx4_en
sudo modprobe -r mlx4_ib
sudo modprobe -r mlx4_core

sudo modprobe mlx4_core
sudo modprobe mlx4_ib
sudo modprobe mlx4_en

# Verify DPDK installation
echo "DPDK has been installed successfully."