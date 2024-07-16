#!/bin/bash

# Update package repositories
sudo apt update
sudo apt-get update

sudo apt upgrade -y

# Install dependencies
sudo apt install -y build-essential linux-headers-$(uname -r) wget
sudo apt-get install pkg-config

sudo apt install -y build-essential meson ninja-build pkg-config libnuma-dev

#sudo pip3 install meson ninja

#sudo apt install python3-pyelftools

cd /opt

# Download DPDK source code (adjust version as needed)
#DPDK_VERSION="23.11"
DPDK_VERSION="24.03"
wget http://fast.dpdk.org/rel/dpdk-${DPDK_VERSION}.tar.xz

# Extract DPDK source code
#sudo tar -xf dpdk-${DPDK_VERSION}.tar.xz -C /opt
tar -xf dpdk-24.03.tar.xz
cd dpdk-${DPDK_VERSION}

# Set DPDK environment variables
#export RTE_SDK=$(pwd)
#export RTE_TARGET=x86_64-native-linuxapp-gcc

# Build DPDK
#sudo meson build
sudo meson setup build
#cd build
#sudo ninja install
#sudo ldconfig
sudo ninja -C build
sudo ninja -C build install

# Set DPDK environment variables
echo "export DPDK_DIR=/usr/local/share/dpdk" >> ~/.bashrc
echo "export PATH=\$PATH:\$DPDK_DIR/tools" >> ~/.bashrc
source ~/.bashrc

# Bind network interfaces to DPDK drivers (adjust as needed)
cd ../usertools
#sudo modprobe -a ib_uverbs mlx4_en mlx4_core mlx4_ib
sudo modprobe vfio-pci

INTERFACE0_ID="enp59s0f1np0"
INTERFACE1_ID="enp59s0f1np1"
sudo ip link set dev ${INTERFACE0_ID} down
sudo ip link set dev ${INTERFACE1_ID} down
INTERFACE0_PCI="0000:3b:00.0"
INTERFACE1_PCI="0000:3b:00.1"
sudo dpdk-devbind.py -u ${INTERFACE0_PCI}
sudo dpdk-devbind.py -u ${INTERFACE1_PCI}
sudo dpdk-devbind.py -b vfio-pci ${INTERFACE0_PCI} ${INTERFACE1_PCI}

# If you face a problem when binding vfio-pci:
sudo nano /etc/default/grub
# Add intel_iommu=on to GRUB_CMDLINE_LINUX_DEFAULT
sudo update-grub
sudo reboot
# And try again

# Setup hugepages
#PAGE_SIZE="2M"
#TOTAL_SIZE="1G"
PAGE_SIZE="1G"
TOTAL_SIZE="24G"

sudo dpdk-hugepages.py -p ${PAGE_SIZE} --setup ${TOTAL_SIZE}

# Verify DPDK installation
echo "DPDK has been installed successfully."

