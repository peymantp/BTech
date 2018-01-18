#include <stdlib.h>
#include <stdio.h>

// compile: gcc -Wall -g -o initerr initerr.c
// valgrind --tool=memcheck --leak-check=yes ./initerr

// Prototypes
void foo (int);

int main (void)
{
    int var1;
    
    foo(var1);
    return 0;
}

void foo (int var2)
{
    int bar = 42;
    
    if (var2 < bar)
      printf ("var2 is less than bar: %d\n", var2);
}

  
