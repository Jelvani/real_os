org 0x7C00
bits 16

jmp short start ;Jump over the data (the 'short' keyword makes the jmp instruction smaller)

%include "print.asm"

msg:
    db "Hello World! I'm cool", 0

start:  
    mov si, msg
    call print_string ;call will push the next instructions address from ip to stack
    jmp $ ;infinite loop, jump to here


times 510-($-$$)  db 0    ;Zerofill up to 510 bytes
dw 0xaa55       ;Boot Sector signature

 ;OPTIONAL:
 ;To zerofill up to the size of a standard 1.44MB, 3.5" floppy disk
 ;times 1474560 - ($ - $$) db 0
