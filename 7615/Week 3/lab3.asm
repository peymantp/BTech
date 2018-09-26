SECTION .data
	tmp	dd -1
	pixels db 	0FFh, 0FEh, 0FDh, 0FDh
	i dw 0
	message db "H", "e", "llo", 0
	buffer times 8 db 0
	max dd 254