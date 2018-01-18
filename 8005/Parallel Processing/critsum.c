#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

//gcc -Wall -o critsum critsum.c -fopenmp

#define PI  3.141592653589793238462

/*----------- Function Prototypes ------------------------*/
long delay (struct timeval t1, struct timeval t2);

int main (int argc, char *argv[])
{
    long i, Total_Loops;
    double Global_Sum, Private_Sum;
    struct  timeval start, end;
    double *Data;
    
    if (argc != 2)  // check for valid number of command-line arguments 
    {   
        fprintf(stderr, "Usage: %s array size\n", argv[0]);
      	exit (1); 
    }     
      
    Total_Loops = atol(argv[1]);;
    Global_Sum = 0.0;
    Private_Sum = 0.0;
    
     gettimeofday(&start, NULL); // start delay measure
    
    if ((Data = malloc (Total_Loops * sizeof (double))) == NULL)
    {
        perror ("malloc : ");
        exit (1);
    }
    
    // initialize the data array
    #pragma omp for
    for (i = 0; i < Total_Loops; i++)  
    {
            Data[i] = PI;
    }
    
    // parallelize the following code block
    #pragma omp parallel shared(Total_Loops, Data, Global_Sum) private(Private_Sum)
    {
        Private_Sum = 0;
        
        // parallelize this for loop
        #pragma omp for
        for (i = 0; i < Total_Loops; ++i)
            Private_Sum += Data[i];     // per-thread sum
        
        // calculation of the global sum is a critical section
        #pragma omp critical
        {
            Global_Sum += Private_Sum;  // get the global sum
        }
    }
    gettimeofday (&end, NULL); // end delay measure
    printf ("\nTotal Elapsed Time = %ld ms.\n", delay(start, end));
    printf ("Global Sum = %f\n\n", Global_Sum);
    free (Data);
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
