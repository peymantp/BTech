#include <stdio.h>
extern int asm_main(void);

int main()
{
	int c;
	c = mult_asm();
	printf("Result is %d \n",c);
}
