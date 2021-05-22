;read n sectors after boot sector, where n is stored in AL and location of memory to 
; put data into is stored in ES:BX
read:
    pusha ;push all registers to stack
    push ax ;we will check al after our read to make sure we got correct amount of sectors
    mov ah, 0x02 ;value for reading disk
    mov ch, 0x0 ;cylinder 0
    mov cl, 0x02 ;begin at the second sector, after the boot sector
    mov dh, 0x0 ;head 0
    int 0x13 ;perform interrupt

    jc disk_error1 ;if carry flag set, print error and hang

    pop dx ;get our old requsted sector numbers from al on the stack
    cmp al, dl ;compare our read amount of sectors in al to our requested in dx
    jne disk_error2
    jmp .done

    .done:
        popa ;get all old registers back
        ret ;get ip of callee

disk_error1:
    mov si, disk_error_message1
    call print_string
    jmp $

disk_error2:
    mov si, disk_error_message2
    call print_string
    jmp $

disk_error_message1:
    db "Disk Error: Carry Flag!" , 0x0d, 0xa, 0x0

disk_error_message2:
    db "Disk Error: Incorrect Size!" , 0x0d, 0xa, 0x0