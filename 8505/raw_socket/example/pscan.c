/*---------------------------------------------------------------------------------------
--	SOURCE FILE:		pscan.c -   A simple raw sockets example - port scanner
--
--	FUNCTIONS:		SendDatagram - dgram.c
--
--	DATE:			June 3, 2011
--
--	REVISIONS:		(Date and nic_description)
--			
--				
--
--	DESIGNERS:		Aman Abdulla
--				
--
--	PROGRAMMER:		Aman Abdulla
--
--	NOTES:
--	The program illustrates the use of raw sockets to craft header fields. The application 
-- 	scans a port on a remote system using addressing information supplied by the user. 
--	User must at least supply the remote port number. Optionally the source/destination
--	IP addresses, and the source port can also be supplied by the user. 
--	
--	To compile run the makefile provided:
--			make
---------------------------------------------------------------------------------------*/

#include <pthread.h>
#include "tscan.h"
 
int main (int argc, char **argv)
{
    struct AddrInfo UserInfo;
    struct AddrInfo *Addr_Ptr;
    int arg, opt;
    pthread_t ThreadID;

 
    if (argc < 2)
    {
	usage(argv);
    }
    
    Addr_Ptr = &UserInfo;
    // Set the default values
    Addr_Ptr->SrcHost = DEFAULT_SRC_IP;		// Deafult Source IP
    Addr_Ptr->DstHost = NULL;			// Must be specified by user!
    Addr_Ptr->dport = DEFAULT_DST_PORT;		// Default Destination Port
    Addr_Ptr->sport = DEFAULT_SRC_PORT;		// Default Source Port
    
    // Process command line options
    while ((opt = getopt (argc, argv, OPTIONS)) != -1)
    {
	switch (opt)
	{
	    case 'h': 
	      Addr_Ptr->SrcHost = optarg;
	    break;
		
	    case 'd':
	      Addr_Ptr->DstHost = optarg;		// Destination Host name
	    break;
	  
	    case 'p':
	      Addr_Ptr->dport = atoi (optarg);
	    break;
		
	    case 's':
	      Addr_Ptr->sport = atoi (optarg);
	    break;
		
	    default:
	      case '?':
	      usage (argv);
	    break;
	}
    }
    
    if (Addr_Ptr->DstHost == NULL)
	usage (argv);

        
    //Create a raw socket
    Addr_Ptr->RawSocket = socket (PF_INET, SOCK_RAW, IPPROTO_TCP);
    
    // Set SO_REUSEADDR so that the port can be resused for further invocations of the application
    arg = 1;
    if (setsockopt (Addr_Ptr->RawSocket, SOL_SOCKET, SO_REUSEADDR, &arg, sizeof(arg)) == -1) 
	perror("setsockopt");
    
    // Spawn a new thread for the scanner
    pthread_create (&ThreadID, NULL, SendDatagram, (void*)Addr_Ptr);
    pthread_join (ThreadID, NULL);
    exit (0);
}

// Usage Message

void usage (char **argv)
{
      fprintf(stderr, "Usage: %s -d <Destination IP> -p [Destination Port] -h [Source IP] -s [Source Port]\n", argv[0]);
      fprintf(stderr, "You must specify the destination address!\n");
      exit(1);
}