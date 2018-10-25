#include <stdio.h>
int foobar(int a, int b){
    int xx = a+1;
    int yy = b+1;    
    int sum = xx+yy;
    return sum;
}

int main(){
    printf("AAAAAAAAAA");
    return foobar(10,20);
}