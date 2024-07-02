# Install packages
sudo apt install clang llvm libelf-dev libpcap-dev build-essential libc6-dev-i386 m4
sudo apt install linux-tools-$(uname -r)
sudo apt install linux-headers-$(uname -r)
sudo apt install linux-tools-common linux-tools-generic
sudo apt install tcpdump

# Download bpftool 7.2.0
wget https://github.com/libbpf/bpftool/releases/download/v7.2.0/bpftool-v7.2.0-amd64.tar.gz

# Remove older version of bpftool
sudo rm /usr/sbin/bpftool

# Replace with new version
sudo tar -xzvf bpftool-v7.2.0-amd64.tar.gz -C /usr/sbin/

#sudo chmod +x /usr/sbin/bpftool

# Creates a link between the two includes (solve asm/types.h error)
#sudo ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/asm

#./configure

#make