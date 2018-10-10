all: asm2a asm2b asm2c asm2d lab3 lab3b lab3c lab3d

asm2a: 2a.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE 2a.asm
	gcc -m32 driver.c 2a.o asm_io.o -o 2a

asm2b: 2b.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE 2b.asm
	gcc -m32 driver.c 2b.o asm_io.o -o 2b

asm2c: 2c.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE 2c.asm
	gcc -m32 driver.c 2c.o asm_io.o -o 2c

asm2d: 2d.asm
	nasm -f elf32 -d ELF_TYPE asm_io.asm
	nasm -f elf32 -d ELF_TYPE 2d.asm
	gcc -m32 driver.c 2d.o asm_io.o -o 2d

lab3: lab3.asm
	nasm -f elf64 lab3.asm -l lab3.lst

lab3b: lab3b.asm
	nasm -f elf64 lab3b.asm -l lab3b.lst

lab3c: lab3c.asm
	nasm -f elf64 lab3c.asm -l lab3c.lst

lab3d: lab3c.asm
	nasm -f elf64 lab3d.asm -l lab3d.lst

remove:
	rm asm_io.o 2b 2a 2b.o 2a.o 2c.o 2c 2d.o 2d lab3.lst lab3b.lst lab3c.lst lab3d.lst lab3.o lab3b.o lab3c.o lab3d.o 