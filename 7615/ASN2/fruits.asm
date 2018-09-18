section .data
        msg: db "hello comp 7615", 0x0a
        msg_len: equ $-msg
		yum: db "Tastes great on EVEEYTHING!!", 0x0a
		yum_len: equ $-yum
        ;msg and len are
section .text
        global fruits
		global pinaapple
        
fruits:
        ;mov is an instruction (Move value of len into edx which is a register)
        mov edx, msg_len    ; register edx (32 bit register)
        mov ecx, msg    ;register ecx (32 bit register)
        
        mov ebx, 1 		;file descriptor (stdout)
        mov eax, 4     ;system call number (sys_write)
        int 0x80    ;interupt call (system call)
        
        ret		;empty return call

pinaapple:
		mov edx, yum_len
		mov ecx, yum
		mov ebx, 1
		mov eax, 4
		int 0x80
		ret
		