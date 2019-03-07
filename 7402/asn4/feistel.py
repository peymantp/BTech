#!/bin/python3
import sys, argparse, os

ROUNDS = 8
k = [6,8,7,3,4,5,6,7]
#ensure data is the correct length
def pkcs7_pad(x):
    padding = 16 - ((len(x) % 16 != 0) * (len(x) % 16))
    return x + bytes([padding]) * padding

#remove and check the padding
def pkcs7_strip(x):
    for i in range(x[-1]):
        if x[-(i + 1)] != x[-1]:
            raise ValueError('Input is not padded or padding is corrupt')
    return x[:-x[-1]]

#This is completely arbitrary, and bad
#dont use this f
def f(i, k, x):
    for elem in x:
        elem *= i
        elem <<= k
    return x

def round(i, k, L, R):
    return R, [a ^ b for (a,b) in zip(L, f(i, k, R))]

def process_block(B, rounds, subkeys):
    #Split the block
    L, R = B[:8], B[8:]
    for j in rounds:
        L, R = round(j, subkeys[j], L, R)
    return R + L

parser = argparse.ArgumentParser(description='COMP 7402 Assignment 4')
parser.add_argument( "-e", dest='e',action='store_true', help="Encode the file")
parser.add_argument( "-d", dest='d',action='store_true', help="Decode the file")
parser.add_argument(dest='input_path', help="Path of the file you want to encrypt or decrypt")
parser.add_argument(dest='output_path', help="Output path of the decrypted or encrypted file")
 
args = parser.parse_args()

if(args.e):
    P = pkcs7_pad(bytearray(open(args.input_path, 'rb').read()))
    #i is block num
    for i in range(len(P) // 16):
        start_block = i * 16
        end_block = start_block + 16
        #Grab the block
        B = P[start_block : end_block]
        B = process_block(B, range(ROUNDS), k)
        #Write the block back
        P[start_block : end_block] = B
    with open(args.output_path, 'wb') as out:
        out.write(P)
elif (args.d):
    P = bytearray(open(args.input_path, 'rb').read())
    if len(P) % 16 != 0:
        raise ValueError('Ciphertext is not a valid length, it must be corrupted')
    #i is block num
    for i in range(len(P) // 16):
        start_block = i * 16
        end_block = start_block + 16
        #Grab the block
        B = P[start_block : end_block]
        B = process_block(B, reversed(range(ROUNDS)), k)
        #Write the block back
        P[start_block : end_block] = B
    P = pkcs7_strip(P)
    with open(args.output_path, 'wb') as out:
        out.write(P)
else:
    print("unknown directive {}".format(sys.argv[1]))