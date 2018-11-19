#
#  EasyBMP Cross-Platform Windows Bitmap Library  
#                                                
#                                                
# description: Sample makefile for compiling with
#              the EasyBMP library. This compiles
#              the EasyBMPsample.cpp program.
#

CC = g++

# Optimization flags

CFLAGS = -O3 -pipe -fomit-frame-pointer -funroll-all-loops -s

EasyBMPTest: EasyBMP.o EasyBMPsample.o
	$(CC) $(CFLAGS) EasyBMP.o EasyBMPsample.o -o EasyBMPtest

clean: 
	rm -f *.o EasyBMPtest EasyBMPoutput*

EasyBMP.o:  
	$(CC) $(CFLAGS) -c EasyBMP.cpp

EasyBMPsample.o: 
	$(CC) -c EasyBMPsample.cpp