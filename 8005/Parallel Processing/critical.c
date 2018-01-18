#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

//gcc -Wall -o critical critical.c -fopenmp

/*----------- Function Prototypes ------------------------*/
long delay (struct timeval t1, struct timeval t2);

int main (int argc, char *argv[])
{
    int thread_id;
    long i, Total_Loops;
    long Global_Loops, Private_Loops;
    Global_Loops = 0;
    struct  timeval start, end;

    if (argc != 2)
    {   /* check for valid number of command-line arguments */ 
        fprintf(stderr, "Usage: %s processes\n", argv[0]);
      	exit (1); 
    }     
    Total_Loops = atol(argv[1]);  
    
    gettimeofday(&start, NULL); // start delay measure
    
    // parallelize the following code block
    #pragma omp parallel private(Private_Loops, thread_id)
    {
        Private_Loops = 0;
        thread_id = omp_get_thread_num();

        // share the workload between all threads
        #pragma omp for
        for (i = 0; i < Total_Loops; ++i)
        {
            ++Private_Loops;
        }

        // This is the "critical" code section
        #pragma omp critical
        {
            printf ("Thread %d has contributed (%ld) iterations; Current Sum: (%ld), ", thread_id, Private_Loops, Global_Loops);
            Global_Loops += Private_Loops;  // Add each thread's contribution to the total
            printf (" Current Total Iterations: %ld.\n", Global_Loops);
        }
    }
    gettimeofday (&end, NULL); // end delay measure
    printf ("\nTotal Elapsed Time = %ld ms.\n", delay(start, end));
    printf("Total Overall Iterations: %ld\n\n", Global_Loops);
    
    return 0;
}

// Compute the delay between tl and t2 in milliseconds 
long delay (struct timeval t1, struct timeval t2)
{
	long d;

	d = (t2.tv_sec - t1.tv_sec) * 1000;
	d += ((t2.tv_usec - t1.tv_usec + 500) / 1000);
	return(d);
}
