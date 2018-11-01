
# Makefile for pscan

CC=gcc -Wall -ggdb
CLIB=-lpthread

pscan: pscan.o dgram.o chksum.o
	$(CC) -o pscan pscan.o dgram.o chksum.o $(CLIB)

clean:
	rm -f *.o core.* pscan

pscan.o:
	$(CC) -c pscan.c

dgram.o: 
	$(CC) -c dgram.c

chksum.o: 
	$(CC) -c chksum.c
