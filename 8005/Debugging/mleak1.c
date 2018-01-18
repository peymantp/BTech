#include <stdio.h>
#include <stdlib.h> 

// compile: gcc -Wall -g -o mleak1 mleak1.c
//valgrind --tool=memcheck --leak-check=yes ./mleak1

int main(void)
{
  char bar;
  char *foo = malloc(10);
    
  *foo = 'a'; 
  bar = *foo; 
  printf("Buffer: %c\n", bar); 

  return 0;
}
