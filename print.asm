;prints a null-terminated string pointed to by si
print_string:
    pusha ;push all registers to stack
    mov ah, 0xe ;TELETYPE OUTPUT
    mov bl, 0x0 ;foreground color for graphics mode

    .loop:
        lodsb ;loads byte from SI into AL, and increments SI
        cmp al, 0 ;compare char to null terminator
        je .done ;if equal, we return from the routine
        int 0x10 ;otherwise, we call interrupt to print char to screen
        jmp .loop
    .done:
        
        popa ;get all registers back from stack
        ret ;ret will pop the previous instruction from the stack to the ip
