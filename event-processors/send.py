#!/usr/bin/env python3
import random
import socket
import sys
import time

# sudo apt-get install python3-scapy
from scapy.all import IP, UDP, TCP, Ether, get_if_hwaddr, get_if_list, send, sendp, sr1, srp, srp1, Raw


def get_if():
    ifs=get_if_list()
    iface=None # "h1-eth0"
    for i in get_if_list():
        #if "enp130s0" in i:
        if "enp130s0" in i:
            iface=i
            break
    if not iface:
        print("Cannot find eth0 interface")
        exit(1)
    return iface

def main():

    if len(sys.argv)<4:
        print('pass 2 arguments: <destination IP> <source port> "<message>"')
        exit(1)

    addr = socket.gethostbyname(sys.argv[1])
    src_port = int(sys.argv[2])
    #src_port = 1
    message = sys.argv[3]
    iface = get_if()

    print("sending on interface %s to %s" % (iface, str(addr)))
    #while(src_port < 999):

    # green04
    #ether_info  = Ether(src=get_if_hwaddr(iface), dst='f4:52:14:26:8b:20')
    #ether_info  = Ether(src=get_if_hwaddr(iface))
    # green02
    #ether_info  = Ether(src=get_if_hwaddr(iface), dst='f4:52:14:48:94:b0')
    # aqua07
    ether_info  = Ether(src=get_if_hwaddr(iface), dst='f4:52:14:48:92:30')
    ip_info     = IP(dst=addr)
    trans_info  = TCP(dport=230, sport=231, flags="SA", ack=1)
    
    pkt = ether_info / ip_info / trans_info / message
    #pkt = ip_info / trans_info

    pkt.show2()

    #response = srp1(pkt, timeout=1)
    #response = sr1(pkt, timeout=1)
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