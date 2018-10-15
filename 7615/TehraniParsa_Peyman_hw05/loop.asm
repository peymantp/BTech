%include "asm_io.inc"

segment .data
Message db "Count up to: ", 0

segment .bss
Limit resd 1

extern printf ;let's the program know this line is from outside, aka the C driver

segment .text
        global  asm_main

asm_main:
 	enter   0,0               ; setup routine
	pusha

	mov     eax,  Message
	call    print_string
	
	call    read_int             ; scanf("%u", & limit );
	mov     [Limit], eax

	mov     eax, 2               ; printf("2\n");
	call    print_int
	
	l1:
	mov [num], eax
	mov eax, 4
	mov ebx, 1
	push ecx

	mov ecx, num        
	mov edx, 1        
	int 0x80

	mov eax, [num]
	sub eax, '0'
	inc eax
	add eax, '0'
	pop ecx
	loop l1

	mov eax,1             ;system call number (sys_exit)
	int 0x80              ;call kernel

section	.bss
num resb 1
