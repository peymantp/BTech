
/*---------------------------------------------------------------------------------------
--      Source File:            threadargs.c - A simple illustration of thread arguments
--
--      Functions:              ThreadFunc
--                              usage
--
--      Date:                   January 3, 2014
--
--      Revisions:              (Date and Description)
--                                      
--      Designer:               Aman Abdulla
--                              
--      Programmer:             Aman Abdulla
--
--      Notes:
--      This program illustrates the use of structure pointers to pass multiple arguments 
--      to a thread function. User must at least supply at least one argument and optionally 
--	all four. 
--      
--      The application spawns a single thread which will reecive the arguments, type cast the 
--	void *  to the original data types, and print the arguments.    
--
--      To compile the application:
--                      
--            gcc -Wall -o threadargs threadargs.c -lpthread

---------------------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <errno.h>


// Function Prototypes
void* ThreadFunc (void *);
void usage (char **);

// Globals
typedef struct 
{
    char *TestStr1;
    char *TestStr2;
    int Int1;
    int Int2;
}ThreadInfo;

#define OPTIONS		"?a:b:c:d:"

int main (int argc, char **argv)
{
    ThreadInfo *Info_Ptr;
    pthread_t ThreadID;
    int opt;
    
    if ((Info_Ptr = malloc (sizeof (ThreadInfo))) == NULL)
    {
        perror ("malloc");
        exit (1);
    }
    
    // Set some default values
    Info_Ptr->TestStr1 = "foo";
    Info_Ptr->TestStr2 = "bar";           
    Info_Ptr->Int1 = rand()% 9990 + 10; 	// Random value between 10 and 10000
    Info_Ptr->Int2 = rand()% 40000 + 2000;     // Random value between 2000 and 60000
    
    
    // Must supply at least one argument
    if (argc < 2)	
    {
        usage(argv);
    }

    // Set the default values
    Info_Ptr->TestStr1 = "foo";
    Info_Ptr->TestStr2 = "bar";           
    Info_Ptr->Int1 = rand()% 9990 + 10; 	// Random value between 10 and 10000
    Info_Ptr->Int2 = rand()% 40000 + 2000;     // Random value between 2000 and 60000

  
  // Process command line options
    while ((opt = getopt (argc, argv, OPTIONS)) != -1)
    {
        switch (opt)
        {
            case 'a': 
              Info_Ptr->TestStr1 = optarg;
            break;
                
            case 'b':
              Info_Ptr->TestStr2 = optarg;  
            break;
          
            case 'c':
              Info_Ptr->Int1 = atoi (optarg);
            break;
                
            case 'd':
              Info_Ptr->Int2 = atoi (optarg);
            break;
                
            default:
              case '?':
              usage (argv);
            break;
        }
    }

   // Spawn a new thread
    pthread_create (&ThreadID, NULL, ThreadFunc, (void*)Info_Ptr);
    pthread_join (ThreadID, NULL);
    free (Info_Ptr);
    exit (0);
}

// The thread function
void* ThreadFunc (void *info_ptr)
{

    ThreadInfo *UserInfo = (ThreadInfo *)info_ptr;

    printf ("String1: %s, String2: %s, Integer1: %d, Integer2: %d\n", UserInfo->TestStr1, UserInfo->TestStr2, UserInfo->Int1, UserInfo->Int2);
    return NULL;
}


// Usage Message
void usage (char **argv)
{
      fprintf(stderr, "Usage: %s -a <string 1> -b [string 2] -c [integer 1] -d [integer 2]\n", argv[0]);
      exit(1);
}

