all: name fruits

fruits: fruits.asm fruits.c
	nasm -f elf32 fruits.asm -o fruits.o
	gcc -m32 fruits.c fruits.o -o fruit

name: name.asm name.c
	nasm -f elf32 name.asm -o name.o
	gcc -m32 name.c name.o -o name

remove:
	rm name fruit fruits.o name.o