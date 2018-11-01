/*---------------------------------------------------------------------------------------
--	Source File:	dgram.c -  Contains the main funtion used by pscan.c
--
--	DATE:			June 3, 2011
--
--	REVISIONS:		(Date and nic_description)
--			
--
--	DESIGNERS:		Aman Abdulla
--				
--
--	PROGRAMMER:		Aman Abdulla
--
--	Functions:	SendDatagram 
--
--	Interface: 	int SendDatagram (struct AddrInfo *UserAddr)
			    struct AddrInfo: contains all of the addressing components
				RawSocket: raw socket descriptor 
				*DstHost: Destination host IP
				*SrcHost: Source host IP
				dport: Destination port
				sport: Source port
--				
--	Description:  	This function will craft the TCP and IP header fields based on the user-supplied
--			information. 
--
--	Returns:  	0 - Success; -1 - Failure
--
--
--	NOTES:
--	The function makes use of a public domain checksum function (chksum.c)
--
---------------------------------------------------------------------------------------*/

#include "tscan.h"

int SendDatagram (struct AddrInfo *UserAddr)
{
    char datagram[PKT_SIZE]; 	// set the Datagram (packet) size
    struct iphdr *iph = (struct iphdr *) datagram;	 //IP header
    struct tcphdr *tcph = (struct tcphdr *) (datagram + sizeof (struct ip));	//TCP header
    struct sockaddr_in sin;
    pseudo_header psh;
  
    sin.sin_family = AF_INET;
    sin.sin_port = htons (UserAddr->dport);
    sin.sin_addr.s_addr = inet_addr (UserAddr->DstHost); 
 
    memset (datagram, 0, PKT_SIZE); // zero out the buffer where the datagram will be stored
 
    //IP Header Fields
    iph->ihl = 5;		// IP Header Length
    iph->version = 4;		// Version 4
    iph->tos = 0;
    iph->tot_len = sizeof (struct ip) + sizeof (struct tcphdr);	// Calculate the total Datagram size
    iph->id = htonl (DEFAULT_IP_ID); 	//IP Identification Field
    iph->frag_off = 0;
    iph->ttl = DEFAULT_TTL;		// Set the TTL value
    iph->protocol = IPPROTO_TCP;
    iph->check = 0;      	//Initialize to zero before calculating checksum
    iph->saddr = inet_addr (UserAddr->SrcHost);  //Source IP address
    iph->daddr = sin.sin_addr.s_addr;
 
    iph->check = csum ((unsigned short *) datagram, iph->tot_len >> 1);
 
    //TCP Header Fields
    tcph->source = htons (UserAddr->sport); // TCP source port
    tcph->dest = htons (UserAddr->dport);	// TCP destination port
    tcph->seq = 0;
    tcph->ack_seq = 0;
    tcph->doff = 5;      // Data Offset is set to the TCP header length 
    tcph->fin=0;
    tcph->syn=1;	// Set the SYN bit
    tcph->rst=0;
    tcph->psh=0;
    tcph->ack=0;
    tcph->urg=0;
    tcph->window = htons (WIN_SIZE); 	// Maximum allowable window size 
    tcph->check = 0;			// Initialize the checksum to zero
					// The kernel's IP stack will fill in the correct checksum during transmission 
    tcph->urg_ptr = 0;
   
    // calcluate the IP checksum
    psh.source_address = inet_addr(UserAddr->SrcHost);
    psh.dest_address = sin.sin_addr.s_addr;
    psh.placeholder = 0;
    psh.protocol = IPPROTO_TCP;
    psh.tcp_length = htons(20);
 
    memcpy(&psh.tcp , tcph , sizeof (struct tcphdr));
 
    tcph->check = csum( (unsigned short*) &psh , sizeof (pseudo_header));
 
    //IP_HDRINCL to stop the kernel from building the packet headers 
    {
        int one = 1;
        const int *val = &one;
        if (setsockopt (UserAddr->RawSocket, IPPROTO_IP, IP_HDRINCL, val, sizeof (one)) < 0)
            perror ("setsockopt");
    }
 
    //Send the packet
    if (sendto (UserAddr->RawSocket, datagram, iph->tot_len, 0, (struct sockaddr *) &sin, sizeof (sin)) < 0)
    {
	perror ("sendto");
	return -1;
    }
    else	//Data sent successfully
    {
	printf ("Datagram Sent!\n");
	return 0;
    }
}
    
   

