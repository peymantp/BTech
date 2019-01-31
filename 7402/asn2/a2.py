#!/usr/bin/python3
import math, sys, argparse, _thread, detectEnglish
def main (argv):
    arg_parser = argparse.ArgumentParser(prog='Transposition Cipher Decryption',description='COMP 7402 Assignment 2')
    arg_parser.add_argument('-t', dest='text', type = str, help = 'filename', required=True)
    arg_parser.add_argument('-m', dest='mode', type = str, help = 'decode/encode', required=True)
    arg_parser.add_argument('-k', dest='keysize', type = int, help = 'Key size of table',default=13,const=13, nargs='?')
    args = arg_parser.parse_args()

    text = open(args.text).read().rstrip('\n')
    mode = args.mode
    keylen = args.keysize

    if mode == "encode":
        print(encryptMessage (keylen, text))
    elif mode == "decode":
        result = bruteDecryptMessage (text)
        print("Key:"+str(result[1]))#print("\nResult:" +result[0]+"\nKey:"+str(result[1]))
    
# The transposition decrypt function will simulate the "columns" and
# "rows" of the grid that the plaintext is written on by using a list
# of strings. First, we need to calculate a few values.
def bruteDecryptMessage(message: str):
    min = 2
    max = len(message) - 1
    detectedKey = False
    for key in range(min,max):
        # Determine the number of columns
        nCols = math.ceil (len (message) / key)
        nRows = key
        # Determine the unused cells 
        nUnused = (nCols * nRows) - len(message)
        # Each string in plaintext represents a column in the grid.
        plaintext = [''] * nCols
        # row and col point to the location of the next character in the ciphertext
        row = col = 0
        for symbol in message:
            plaintext[col] += symbol
            col += 1 # point to next column
            # If it reaches the last column in the row, or at an unused cell, start processing the next row 
            if (col == nCols) or (col == nCols - 1 and row >= nRows - nUnused):
                col = 0
                row += 1
        string = ''.join(plaintext)
        if detectEnglish.isEnglish(string,50):
            detectedKey = bool(int(input(string + '\n\033[92m OK?(1=True/0=False) \033[0m\n')))
            if detectedKey: return (string, key)

    
def encryptMessage (key, message):
    # Each string in ciphertext represents a column in the grid.
    ciphertext = [''] * key
    # Iterate through each column in ciphertext.
    for col in range (key):
        pointer = col
        # process the complete length of the plaintext
        while pointer < len (message):
            # Place the character at pointer in message at the end of the
            # current column in the ciphertext list.
            ciphertext[col] += message[pointer]
            # move pointer over
            pointer += key
    # Convert the ciphertext list into a single string value and return it.
    return ''.join (ciphertext)

# main() function
if __name__ == "__main__":
    main (sys.argv[1:])
