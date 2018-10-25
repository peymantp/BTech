#include <stdio.h>
extern int mult_asm(int, int);
int main(){
    int c;
    c = mult_asm(3,-4);
    printf ("Result is %d \n", c);
}