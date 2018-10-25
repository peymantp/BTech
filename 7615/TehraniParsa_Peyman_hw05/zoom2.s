	.file	"zoom2.c"
	.intel_syntax noprefix
	.text
	.globl	foobar
	.type	foobar, @function
foobar:
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	DWORD PTR -20[rbp], edi
	mov	DWORD PTR -24[rbp], esi
	mov	eax, DWORD PTR -20[rbp]
	add	eax, 1
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	add	eax, 1
	mov	DWORD PTR -8[rbp], eax
	mov	edx, DWORD PTR -12[rbp]
	mov	eax, DWORD PTR -8[rbp]
	add	eax, edx
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	foobar, .-foobar
	.section	.rodata
.LC0:
	.string	"AAAAAAAAAA"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	lea	rdi, .LC0[rip]
	mov	eax, 0
	call	printf@PLT
	mov	esi, 20
	mov	edi, 10
	call	foobar
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
