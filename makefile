CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
BOOTLOADER_NAME = bootloader
KERNEL_NAME = real_os
DD = dd
CFLAGS = -Os -m16 -masm=intel -ffreestanding -nostartfiles -nostdlib \
	-Wall -Werror 
LDFLAGS = -melf_i386

DIR_SRC=src
DIR_BIN=bin
DIR_BUILD=build

OBJS= $(DIR_SRC)/test.o

all: $(DIR_BUILD)/$(KERNEL_NAME).img
	qemu-system-x86_64.exe -fda $<

$(DIR_BIN)/$(BOOTLOADER_NAME).bin: $(DIR_SRC)/$(BOOTLOADER_NAME).asm
	$(AS) -Werror -f bin $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@ 

$(DIR_BIN)/$(KERNEL_NAME).elf: $(OBJS)
	$(LD) $(LDFLAGS) -Tlink.ld $^ -o $@

$(DIR_BIN)/$(KERNEL_NAME).bin: $(DIR_BIN)/$(KERNEL_NAME).elf
	$(OBJCOPY) -O binary $< $@

$(DIR_BUILD)/$(KERNEL_NAME).img: $(DIR_BIN)/$(BOOTLOADER_NAME).bin $(DIR_BIN)/$(KERNEL_NAME).bin
	$(DD) if=/dev/zero of=$@ bs=1024 count=1440
	$(DD) if=$(DIR_BIN)/$(BOOTLOADER_NAME).bin of=$@ conv=notrunc
	$(DD) if=$(DIR_BIN)/$(KERNEL_NAME).bin of=$@ conv=notrunc seek=1

clean:
	rm -f src/*.o
	rm -f build/*.img
	rm -f bin/*.elf
	rm -f bin/*.bin