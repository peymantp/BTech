nasm -f elf32 -d ELF_TYPE asm_io.asm
nasm -f elf32 -d ELF_TYPE div.asm
gcc -o div -m32 driver.c div.o asm_io.asm
./div