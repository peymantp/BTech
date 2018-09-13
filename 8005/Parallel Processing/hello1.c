#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

// gcc -Wall -o hello1 hello1.c -fopenmp

int main(int argc, char *argv[]) 
{
    int thread_num = 0, num_core = 1;

    // parallel region with default number of threads
    #pragma omp parallel private(thread_num, num_core)
    {
        num_core = omp_get_num_threads();
        thread_num = omp_get_thread_num();
        printf("Hello World: thread %d of %d\n", thread_num, num_core);
    } // end of parallel region
    exit(0);
}
