	.file	"mystery.c"
	.intel_syntax noprefix
	.section	.rodata
.LC0:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR [rbp-12], 0
	mov	DWORD PTR [rbp-8], 1
.L2:
	mov	eax, DWORD PTR [rbp-12]
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC0
	mov	eax, 0
	call	printf
	mov	edx, DWORD PTR [rbp-12]
	mov	eax, DWORD PTR [rbp-8]
	add	eax, edx
	mov	DWORD PTR [rbp-4], eax
	mov	eax, DWORD PTR [rbp-8]
	mov	DWORD PTR [rbp-12], eax
	mov	eax, DWORD PTR [rbp-4]
	mov	DWORD PTR [rbp-8], eax
	cmp	DWORD PTR [rbp-12], 254
	jle	.L2
	mov	eax, 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
