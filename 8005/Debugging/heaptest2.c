#include <stdio.h>
#include <stdlib.h>

// gcc -Wall -g -o heaptest2 heaptest2.c
// valgrind --tool=massif --time-unit=B ./heaptest

// Function prototypes
char *foo (void);
char *bar (void);

#define SIZE 		1024
#define ELEMENTS	10

int main (void)
{
  int i;
  int *dElements[ELEMENTS];
  char *fElements, *bElements;
  
  for (i = 0; i < ELEMENTS; i++)
    dElements[i] = malloc(SIZE);
  
  fElements = foo ();
  bElements = bar ();

  for (i = 0; i < ELEMENTS; i++) 
    free (dElements[i]);
  free (fElements);  
  free (bElements);
  return 0;
}

char *foo (void)
{
  char *fElements;
  char *bElements;
  
  fElements = malloc(SIZE*2);
  bElements = bar ();
  free (bElements);
  return fElements;
}

char *bar (void)
{
  char *bElements;
  
  bElements = malloc(SIZE*4);
  return bElements;
}
