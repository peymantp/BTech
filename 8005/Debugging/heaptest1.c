#include <stdio.h>
#include <stdlib.h>

// gcc -Wall -g -o heaptest1 heaptest1.c
// valgrind --tool=massif --time-unit=B ./heaptest

// Function prototypes
void foo (void);
void bar (void);

#define SIZE 		1024
#define ELEMENTS	10

int main (void)
{
  int i;
  int* dElements[ELEMENTS];
  
  for (i = 0; i < ELEMENTS; i++)
    dElements[i] = malloc(SIZE);
  
  foo ();
  bar ();

  for (i = 0; i < ELEMENTS; i++) 
    free (dElements[i]);
    
  return 0;
}

void foo (void)
{
  malloc(SIZE*2);
  bar ();
}

void bar (void)
{
  malloc(SIZE*4);
}
