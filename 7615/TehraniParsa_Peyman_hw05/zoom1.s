	.file	"zoom1.c"
	.intel_syntax noprefix
	.text
	.globl	add3
	.type	add3, @function
add3:
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	DWORD PTR -20[rbp], edi
	mov	DWORD PTR -24[rbp], esi
	mov	DWORD PTR -28[rbp], edx
	mov	edx, DWORD PTR -20[rbp]
	mov	eax, DWORD PTR -24[rbp]
	add	edx, eax
	mov	eax, DWORD PTR -28[rbp]
	add	eax, edx
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	add3, .-add3
	.globl	f
	.type	f, @function
f:
.LFB1:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	edx, 5
	mov	esi, 4
	mov	edi, 3
	call	add3
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	f, .-f
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
