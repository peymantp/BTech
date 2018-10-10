%include "asm_io.inc"
;MAXARGS		equ	12; 1 = program path, 2 = first arg, 3 = second arg, etc

section .data
;for now the digits are set as data in addresses
b1	dd 0
b2	dd 5
b3	dd 5
b4	dd 5
b5	dd 7
b6	dd 7
b7	dd 1
b8	dd 0
b9	dd 2
b10	dd 5
b11	dd 7

msg: db "Your barcode is: %d%d%d%d%d%d%d%d%d%d%d%d", 10,0 ;%d (decimal) is a variable that is pushed to the stack

section .text

extern printf ;let's the program know this line is from outside, aka the C driver
global asm_main

asm_main:
	pusha;set the registers state
	mov 	ebp, esp ;moving the stack pointer to ebp
	sub	esp, 4
	;sum the even numbers
	mov eax, [b2]
	add eax, [b4]
	add eax, [b6]
	add eax, [b8]
	add eax, [b10]
	mov ecx, eax ;store sum of evens on ecx, so we can use eax

	;sum the odd numbers
	mov eax, [b1]
	add eax, [b3]
	add eax, [b5]
	add eax, [b7]
	add eax, [b9]
	add eax, [b11]

	mov ebx, 3 ; the number we will multiply eax
	mul ebx ;multiply the eax by this number, then store inside eax
	add eax, ecx ; adding our even sum to the multiplied odd sum
	mov edx, 0 ;moving the even sum to here, div uses edx and adds it to eax before dividing by your register
	mov ebx, 10 ; changing our divisor to 10
	div ebx ;dividing (edx + eax) by ebx. I know, div is weird
	;note that edx will contain the remainder after the division

	cmp edx, 0;comparision to see if our modulus/remainder is greater than 0
	jmp .checkNum;if it is, go to checkNum
	;if not greater than 0, continue down to this part
	push 0;basically make the last digit of the barcode 0
	jmp	.done;jump to the done label, so we don't just continue down into .checkNum

.checkNum:;local label
	mov eax, edx ;move the remainder to eax so we can work on it
	sub ebx, eax ;subtract 10 (which we set to ebx and used earlier) by the remainder
	push ebx ;put it on the stack
	jmp	.done ;jump to done label


.done: ;local label
	;here we push the rest of the barcode numbers to the stack in reverse order cause of little indian
	push dword [b11]
	push dword [b10]
	push dword [b9]
	push dword [b8]
	push dword [b7]
	push dword [b6]
	push dword [b5]
	push dword [b4]
	push dword [b3]
	push dword [b2]
	push dword [b1]
	push 	msg ;push the message we want to the stack, all the %d will be filled now
	call 	printf; show on terminal the completed message
	;these lines are to exit from the program without dying to segment faults
	mov eax, 1
	mov ebx, 0
	int 80h
