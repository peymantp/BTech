#include <stdlib.h>

// compile: gcc -Wall -g -o mleak2 mleak2.c
// valgrind --tool=memcheck --leak-check=yes ./mleak2

// Prototypes
void foo (void);


int main (void)
{
      foo();
      return 0;
}


void foo (void)
{
    int* x = malloc(10 * sizeof(int));
    x[10] = 0;        // problem 1: heap block overrun
}                    // problem 2: memory leak -- x not freed

  
