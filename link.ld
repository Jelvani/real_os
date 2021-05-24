OUTPUT_FORMAT("elf32-i386");
ENTRY(main);
SECTIONS
{
    . = 0x1200;

    .text.main : SUBALIGN(0) {
        *(.text.bootstrap);
        *(.text.*);
    }

    .data.main : SUBALIGN(4) {
        *(.data);
        *(.rodata*);
    }

    .bss : SUBALIGN(4) {
        __bss_start = .;
        *(.COMMON);
        *(.bss)
    }
    . = ALIGN(4);
    __bss_end = .;

    __bss_sizel = ((__bss_end)-(__bss_start))>>2;
    __bss_sizeb = ((__bss_end)-(__bss_start));

    /DISCARD/ : {
        *(.eh_frame);
        *(.comment);
    }
}