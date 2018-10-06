section .data
        msg1: db "<<<<<<<<<<	##########	>>>>>>>>>>", 0x0a
        msg2: db "<<		COMP7615	        >>", 0x0a
	msg3: db "<<	     Peyman Tehrani Parsa       >>", 0x0a
        msg4: db "<<<<<<<<<<	##########	>>>>>>>>>>", 0x0a
        len_msg1: equ $-msg1
		
section .text
        global name
        
name:
        mov edx, len_msg1    ; register edx (32 bit register)
        mov ecx, msg1    ;register ecx (32 bit register)
          
        mov ebx, 1 		;file descriptor (stdout)
        mov eax, 4     ;system call number (sys_write)
        int 0x80    ;interupt call (system call)
        ret		;empty return call