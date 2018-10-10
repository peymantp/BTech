%include "asm_io.inc"

segment .data
	bytes dd 06C697665h

segment .text
	global asm_main

asm_main:
	dump_mem 0, bytes, 1
	mov eax, 0AABBCCDDh
	dump_mem 1, bytes, 1
	mov [bytes], eax
	dump_mem 2, bytes, 1
	mov ebx,[bytes]
	dump_mem 3, bytes, 1
	ret