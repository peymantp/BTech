%include "asm_io.inc"

segment .data
	first db 00h, 04h, 012h, 0A4h
	second dw 165
	third db "adf"

segment .text
	global asm_main

asm_main:
	mov eax, first
	
	dump_mem 0, first, 1
	dump_regs 0
	inc eax

	dump_mem 0, first, 1
	dump_regs 0
	mov ebx, [eax]

	dump_mem 0, first, 1
	dump_regs 0
	mov [second], ebx

	dump_mem 0, first, 1
	dump_regs 0
	mov byte [third], 11o


	dump_mem 0, first, 1
	dump_regs 0
	ret