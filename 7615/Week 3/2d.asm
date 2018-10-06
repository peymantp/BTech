%include "asm_io.inc"

segment .data
	var1 dd 179
	var2 db 0A3h, 017h, 012h
	var3 dd "bca"

segment .text
	global asm_main

asm_main:
	dump_mem 0, var1, 1
	dump_regs 0
	
	mov eax, var1
	
	dump_mem 1, var1, 1
	dump_regs 0

	add eax, 3
	
	dump_mem 2, var1, 1
	dump_regs 0

	mov ebx, [eax]
	
	dump_mem 3, var1, 1
	dump_regs 0

	add ebx, 5

	dump_mem 4, var1, 1
	dump_regs 0

	mov [var1], ebx
	
	dump_mem 5, var1, 1
	dump_regs 0
	ret