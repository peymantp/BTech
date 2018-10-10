all: barcode

barcode: barcode.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE barcode.asm
	gcc -m32 driver.c barcode.o asm_io.o -o barcode
