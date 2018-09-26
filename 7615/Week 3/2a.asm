%include "asm_io.inc"

segment .data
	bytes dd 06C697665h
	end db 0

segment .text
	global asm_main

asm_main:
	dump_mem 0, bytes, 1
	dump_regs 0
	enter 0,0
	pusha
	mov eax,bytes
	call print_string
	call print_nl
	mov eax, [bytes]
	dump_mem 1, bytes, 1
	dump_regs 0
	pusha
	popa
	mov eax, 0
	dump_mem 2, bytes, 1
	dump_regs 0
	leave
	ret