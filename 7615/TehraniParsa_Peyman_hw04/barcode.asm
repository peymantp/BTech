%include "asm_io.inc"
;MAXARGS		equ	12; 1 = program path, 2 = first arg, 3 = second arg, etc

section .data
;for now the digits are set as data in addresses
num1	dd 0
num2	dd 0
num3	dd 0
num4	dd 0
num5	dd 0
num6	dd 0
num7	dd 0
num8	dd 0
num9	dd 0
num10	dd 0
num11	dd 0
input	times 11 db 0

msg: db "Your barcode is: %d%d%d%d%d%d%d%d%d%d%d%d", 10,0 ;%d (decimal) is a variable that is pushed to the stack

section .text

extern printf ;let's the program know this line is from outside, aka the C driver
global asm_main

asm_main:
	; grab user input
	mov     eax, 3          ; sys_read syscall
	mov     ebx, 0          ; std_in
	mov     ecx, input      ; output to username
	mov     edx, 11         ; accept 16 bytes
	int     80h

	;do while loop start
	;set up loop counters
	mov			ebx,  0 ;mem offest
	mov			edx,	0;loop counter i
loop1:
	cmp				edx, 11	;compare counter
	jg loop_end
	movzx			eax, byte[input+edx] ;load byte from input
	sub				eax, 48	;convert byte to int
	mov				[num1+ebx], eax
	add				ebx, 4	;increment counter
	add				edx, 1	;increment counter
	jmp loop1
loop_end:

	;do while loop end
done:
	pusha;set the registers state
	mov 	ebp, esp ;moving the stack pointer to ebp
	sub	esp, 4
	;sum the even numbers
	mov eax, [num2]
	add eax, [num4]
	add eax, [num6]
	add eax, [num8]
	add eax, [num10]
	mov ecx, eax ;store sum of evens on ecx, so we can use eax

	;sum the odd numbers
	mov eax, [num1]
	add eax, [num3]
	add eax, [num5]
	add eax, [num7]
	add eax, [num9]
	add eax, [num11]

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
	push dword [num11]
	push dword [num10]
	push dword [num9]
	push dword [num8]
	push dword [num7]
	push dword [num6]
	push dword [num5]
	push dword [num4]
	push dword [num3]
	push dword [num2]
	push dword [num1]
	push 	msg ;push the message we want to the stack, all the %d will be filled now
	call 	printf; show on terminal the completed message
	;these lines are to exit from the program without dying to segment faults
	mov eax, 1
	mov ebx, 0
	int 80h
