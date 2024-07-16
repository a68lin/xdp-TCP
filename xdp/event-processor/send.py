#!/usr/bin/env python3
import random
import socket
import sys
import time

# sudo apt-get install python3-scapy
from scapy.all import *


def get_if():
    ifs=get_if_list()
    iface=None
    for i in get_if_list():
        if "enp1s0f1np1" in i:
            iface=i
            break
    if not iface:
        print("Cannot find eth0 interface")
        exit(1)
    return iface

def main():
    id = int(sys.argv[1])
    ack = 0
    if(id == 3):
        ack = int(sys.argv[2])
    message = '12345'
    iface = get_if()
    print("sending on interface %s to %s" % (iface, "64:9d:99:ff:f0:53"))
    ether_info  = Ether(src=get_if_hwaddr(iface), dst='64:9d:99:ff:f0:53')
    ip_info     = IP(dst="192.168.42.221", id=id)
    trans_info  = TCP(dport=1025, sport=1024, flags="SA", ack=ack)
    pkt = ether_info / ip_info / trans_info / message
    pkt.show2()
    sendp(pkt, iface = iface)

        #src_port += 1

    """if response:
        seq_num = response[TCP].seq
        ack_num = response[TCP].ack
        trans_ack = TCP(dport=684, sport=src_port, flags="A", seq=ack_num, ack=seq_num + 1)
        sendp(ether_info / ip_info / trans_ack)

        seq_num = response[TCP].ack
        #ack_num = response[TCP].seq + 1

        data = "testing"
        while 1:
            time.sleep(1)
            trans_info = TCP(dport=1234, sport=src_port, flags="PA", seq=seq_num)
            pkt = ether_info / ip_info / trans_info / Raw(load=data)
            pkt.show2()
            srp1(pkt, timeout=2, verbose=False)
            seq_num += len(data)
            #ack_num = seq_num + 1
    else:
        print("Syn packet wasn't answered")"""


if __name__ == '__main__':
    main()