%include "asm_io.inc"
SECTION .data
	result dd 0;

SECTION .text

global mult_asm

mult_asm:
	enter 0,0
	pusha
	mov eax, [ebp + 8]
	imul eax, [ebp + 12]
	mov [result], eax
	call print_int
	call print_nl

	popa
	mov eax, [result]
	leave
	ret