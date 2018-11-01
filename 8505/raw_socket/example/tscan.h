#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include<netinet/tcp.h>   	// TCP Header definitions
#include<netinet/ip.h>    	// IP Header definitions
#include <sys/types.h>
#include <unistd.h>

#define PKT_SIZE		4096
#define WIN_SIZE		5840
#define DEFAULT_TTL		255
#define DEFAULT_IP_ID		12345
#define DEFAULT_DST_PORT	8080
#define DEFAULT_SRC_PORT	11234
#define DEFAULT_SRC_IP		"192.168.1.5"
#define OPTIONS 		"?h:d:s:p:"

// Globals
typedef struct    //needed for checksum calculation - see notes
{
    unsigned int source_address;
    unsigned int dest_address;
    unsigned char placeholder;
    unsigned char protocol;
    unsigned short tcp_length;
    struct tcphdr tcp;
}pseudo_header;

struct AddrInfo
{
    int RawSocket;
    char *DstHost;
    char *SrcHost;
    int dport;
    int sport;
};


// Function Prototypes
int SendDatagram (struct AddrInfo *UserAddr);
void usage (char **argv);
unsigned short csum (unsigned short *, int);
