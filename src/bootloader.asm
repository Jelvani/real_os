bits 16
org 0x7c00

kernelAddr dw 0x1200 ;location where kernel will be loaded

cli ;disable interrupts for 8088 buggy processors

mov ax, cs ;cs is set by bios, to 0x7c0, 
mov ds, ax ;set all segment registers to cs for gcc
mov es, ax
mov fs, ax
mov gs, ax
;stack stuff
mov ss, ax
mov bp, [kernelAddr] ;bootloader code ends at 0x0:0x7e00 set a 4096 byte stack, stack grows down
mov sp, bp 
cld

sti ;enable interrupts
jmp short _start ;Jump over the data (the 'short' keyword makes the jmp instruction smaller)

%include "src/print.asm"
%include "src/disk_read.asm"
_start:
    mov [_BOOT_DRIVE], dl ;dl register holds boot drive number on boot
    

    ;our new code must be loaded after the stack,
    ;at address 0x7c00:0x1200
    mov bx, [kernelAddr] ;load our new code start at this address
    mov dl, [_BOOT_DRIVE] ;this is our disk number to read from
    mov al, 10 ;read 10 sectors into memory starting at bx
    call read

    mov si, msg
    call print_string

    mov ax, 0x120 ;set segments to start at where kernel is loaded
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax


    call dword 0x120:0x0 ;enter kernel with a long call, changing cs register

    ;mov si, msg
    ;call print_string
    jmp $ ;infinite loop, jump to here




;variables
_BOOT_DRIVE:
    db 0

msg:
    db "Success", 0x0d, 0xa, 0x0 ;string, carriage return, new line, null terminator

times 510-($-$$)  db 0  ;Zerofill up to 510 bytes
dw 0xaa55               ;Boot Sector signature