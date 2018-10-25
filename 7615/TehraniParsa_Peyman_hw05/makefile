all: barcode masm

barcode: barcode.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE barcode.asm
	gcc -m32 driver.c barcode.o asm_io.o -o prog

masn: zoom1.c zoom2.c
	gcc -masm=intel -S zoom1.c -o zoom1.s
	gcc -masm=intel -S zoom2.c -o zoom2.s