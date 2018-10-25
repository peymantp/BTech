#include <stdio.h>

int main(){
    int a = 0;
    int b = 1;
    while(a <= 254){
        printf("%d\n",a);
        int c = a + b;
        a = b;
        b = c;
    }
    return 0;
}