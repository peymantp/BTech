barcode: mult_asm.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE mult_asm.asm
	gcc -o prog -m32 driver.c mult_asm.o asm_io.o -o mult_asm
