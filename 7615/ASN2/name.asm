section .data
        left: db "<", 20
        left_len: equ $-left
        right: db ">", 20
        right_len: equ $-right
        course: db "COMP7615", 20
        course_len: equ $-course
		peyman: db "Peyman Tehrani Parsa", 20
        peyman_len: equ $-peyman
		
section .text
        global name
        
name:
        ;mov is an instruction (Move value of len into edx which is a register)
        mov edx, msg_len    ; register edx (32 bit register)
        mov ecx, msg    ;register ecx (32 bit register)
        
        mov ebx, 1 		;file descriptor (stdout)
        mov eax, 4     ;system call number (sys_write)
        int 0x80    ;interupt call (system call)
        ret		;empty return call