Script install_dpdk can be used to install DPDK version 24.03
and its dependancies.

Note that it was specifically created to be used in paper cluster.
If you use it somewhere else, modify it before using.

Run (also specific to paper cluster):
sudo ./build/basicfwd -c FF -n 4 -m 16384 -a 0000:3b:00.1