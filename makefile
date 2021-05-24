CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
BOOTLOADER_NAME = bootloader
KERNEL_NAME = real_os
DD = dd
CFLAGS = -Os -m16 -ffreestanding -nostartfiles -nostdlib \
	-Wall -Werror 
LDFLAGS = -melf_i386

OBJS= $(wildcard *.o)

all: $(KERNEL_NAME).img
	qemu-system-x86_64.exe -fda $<

$(BOOTLOADER_NAME).bin: $(BOOTLOADER_NAME).asm
	$(AS) -Werror -f bin $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(KERNEL_NAME).elf: test.o
	$(LD) $(LDFLAGS) -Tlink.ld $^ -o $@

$(KERNEL_NAME).bin: $(KERNEL_NAME).elf
	$(OBJCOPY) -O binary $< $@

$(KERNEL_NAME).img: $(BOOTLOADER_NAME).bin $(KERNEL_NAME).bin
	$(DD) if=/dev/zero of=$@ bs=1024 count=1440
	$(DD) if=$(BOOTLOADER_NAME).bin of=$@ conv=notrunc
	$(DD) if=$(KERNEL_NAME).bin of=$@ conv=notrunc seek=1

clean:
	rm -f *.o
	rm -f *.img
	rm -f *.elf
	rm -f *.bin
#c_code: test.c
#	gcc -c -Os -m16 -march=i686 test.c -o test.0