#include <stdio.h>
#include <stdlib.h>

// Prototypes
int foo (int *);


int main (void)
{
    int *p = 0;
    return foo (p);
}

int foo (int *p)
{
    int y = *p;
    return y;
}