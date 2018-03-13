#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <net/if.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>


int main (int argc,char** argv)
{
	int sd, i;
 	struct sockaddr_in *addrp;
	struct ifreq ifrcopy;
	char *interface = "wlp4s0";
	unsigned char mac_address[7];
	
	
	if ((sd = socket( PF_INET, SOCK_DGRAM, 0 )) < 0)
 	{
  		printf("Cannot create socket :%s\n", strerror(errno));
  		return (1);
 	}

 	memset (&ifrcopy,0,sizeof( struct ifreq ) );
 	strncpy (ifrcopy.ifr_name, interface, IFNAMSIZ); //IFNAMSIZ is defined in "if.h"

 	if( ioctl (sd, SIOCGIFADDR, &ifrcopy) < 0 )
 	{
  		printf("Cannot obtain IP address of '%s' :%s\n", interface, strerror(errno));
  		close(sd);
  		return (2);
 	}
 	else
	{
		addrp = (struct sockaddr_in *)&(ifrcopy.ifr_addr);
		printf ("The IP Address of '%s' is '%s'\n", interface, inet_ntoa(addrp->sin_addr));
	}
	// Get the hardware address
	if ((ioctl (sd, SIOCGIFHWADDR, &ifrcopy)) < 0)
	{
		  perror ("ioctl SIOCGIFHWADDR: \n");
		  exit(1);
	}
	else
	{
		// copy the HW address
		//memcpy (mac_address, ifrcopy.ifr_hwaddr.sa_data, 6);
		mac_address[7] = '\0';
		printf("The MAC Address of '%s' is :", interface); 
		for (i = 0; i < 6; ++i)
		  printf(" %02x", (unsigned char) ifrcopy.ifr_addr.sa_data[i]);
		puts("\n");
	}
		 	
	close(sd);

 	return(0);
}
