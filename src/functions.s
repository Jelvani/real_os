/*This assembly code implements all our bios calls*/

#standard print null terminated string
print_string:
    pusha 
    mov ah, 0xe /*VIDEO - TELETYPE OUTPUT*/
    mov bl, 0x0 

    .loop:
        lodsb
        cmp al, 0 
        je .done 
        int 0x10 
        jmp .loop
    .done:
        
        popa 
        ret 


set_background:
    pusha
    mov ah, 0x0 /*VIDEO - SET VIDEO MODE*/
    mov al, 0x03 /*80X25 text mode*/
    int 0x10

    mov ah, 0x0b /*VIDEO - SET BACKGROUND/BORDER COLOR*/
    mov bh, 0x00
    int 0x10

    popa
    ret


clear_screen:
    pusha
    mov ah, 0x06 /*VIDEO - SCROLL UP WINDOW*/
    mov al, 0x00 /*entire screen*/
    mov bh, 0xd1 /*first hex is background color, second is text*/
    mov cx, 0x0000  
    mov dh, 25
    mov dl, 80
    int 0x10
    popa
    ret

reset_cursor:
    pusha
    mov ah, 0x02 /*VIDEO - SET CURSOR POSITION*/
    mov bh, 0x0 #page 0
    mov dx, 0x0 #col and row 0
    int 0x10
    popa
    ret