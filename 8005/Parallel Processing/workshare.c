#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

//Compile: gcc -Wall -o workshare workshare.c -fopenmp

#define ITERATIONS   1000000
#define PI  3.14159

int main(int argc, char **argv)
{
    int i, thread_id, nloops;
    long sum;
    double data[ITERATIONS];

    #pragma omp parallel private(thread_id, nloops, sum)
    {
        nloops = 0;

        #pragma omp for
        for (i = 0; i < ITERATIONS; i++)  // loop counter i is private to each thread
        {
            ++nloops;
            data[i] = PI;
            sum += i;
        }
        thread_id = omp_get_thread_num();
        printf("Thread %d performed %d iterations of the loop. Sum: %ld\n", thread_id, nloops, sum);
    }
    printf ("pi = %f\n", data[ITERATIONS-1]);
    exit (0);
}
