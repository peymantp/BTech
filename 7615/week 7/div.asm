%include "asm_io.inc"

section .text
		gloabl asm_main
asm_main:
		mov eax, 100		;move number to eax
		mov ebx, 16			;move divisor to ebx
		sub ebx, 1			;prepare mask
		and ebx, eax		;calculate remainder
		
		mov eax, ebx		;print remainder
		call print_int
		call print_nl
		
		mov eax, 100
		shr eax, 4			;calculate quotient
		call print_int
		call print_nl
		ret