How to compile:

Give permission for script
chmod +x update_bpftool.sh

Script that updates the bpftool version
./update_bpftool.sh

Set permission:
sudo chmod +x /usr/sbin/bpftool

Fix error of asm/types.h link:
sudo ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/asm

Install clang-16 and llc-16 (Ubuntu 22.04):
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main"
sudo apt install clang-16
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-16 100
sudo apt install llvm-16
sudo update-alternatives --install /usr/bin/llc llc /usr/bin/llc-16 100

CLANG=clang-16 LLC=llc-16 ./configure
make

Note:
In NICs with ice driver, libxdp might complaint about the MTU size being too big.
We can set a limit of 1500 with:
sudo ip link set dev enp59s0f1np1 mtu 1500