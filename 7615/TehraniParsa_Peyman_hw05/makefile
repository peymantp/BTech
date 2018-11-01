all: loop

loop: loop.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE loop.asm
	gcc -m32 driver.c loop.o asm_io.o -o loop

clear:
	rm *.o
	
