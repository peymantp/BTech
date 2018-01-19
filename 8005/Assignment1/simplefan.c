/********************************************************************************
* This program creates a fan of processes, where n is a command-line
* argument.
* The processes are labelled by the value of i at the time they leave the loop.
* The original process creates n-1 children. 
********************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <gmp.h>
#include <time.h>
#include <pthread.h>
#define MAX_FACTORS	1024
// Globals
mpz_t dest[MAX_FACTORS]; // must be large enough to hold all the factors! 
pthread_mutex_t printfLock = PTHREAD_MUTEX_INITIALIZER;

int decompose (mpz_t n, mpz_t *o) 
{
	int i = 0;
  	mpz_t tmp, d;
 
	mpz_init(tmp);
  	mpz_init(d);
 
  	while (mpz_cmp_si (n, 1)) 
	{
    		mpz_set_ui(d, 1);
    		do 
		{
      			mpz_add_ui(tmp, d, 1);
      			mpz_swap(tmp, d);
    		} while(!mpz_divisible_p(n, d));
    		mpz_divexact(tmp, n, d);
    		mpz_swap(tmp, n);
    		mpz_init(o[i]);
    		mpz_set(o[i], d);
    		i++;
  	}
  	return i;
}

void task(char* prime){
	struct timespec start, finish;
	clock_gettime(CLOCK_MONOTONIC, &start);
	double elapsed;
	mpz_t n;
	int i, l;
	mpz_init_set_str(n, prime, 10);
	l = decompose(n, dest);

	for(i=0; i < l; i++) 
	{
		pthread_mutex_lock(&printfLock);
		gmp_printf("%s%Zd", i?" * ":"", dest[i]);
		pthread_mutex_unlock(&printfLock);
		mpz_clear(dest[i]);
	}
	clock_gettime(CLOCK_MONOTONIC, &finish);
	elapsed = (finish.tv_sec - start.tv_sec);
	elapsed += (finish.tv_nsec - start.tv_nsec) / 1000000000.0;
	pthread_mutex_lock(&printfLock);
	printf("\nspent: %lf secs \n",elapsed);
	pthread_mutex_unlock(&printfLock);
}

int main (int argc, char *argv[]) 
{
	pid_t childpid = 0; 
   	int i, n;
 
   	if (argc != 3)
	{   /* check for valid number of command-line arguments */ 
      		fprintf(stderr, "Usage: ./<file> <processes> <number to be factored>");
      		return 1; 
   	}     
   	n = atoi(argv[1]);  
	char* arg2 = argv[2];
   	for (i = 1; i < n; i++)
		if ((childpid = fork()) <= 0)
			break;
 	task(arg2);
   	//fprintf(stderr, "i:%d  process ID:%ld  parent ID:%ld  child ID:%ld\n",
    //       i, (long)getpid(), (long)getppid(), (long)childpid);
   	return 0; 
}
