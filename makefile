

all: bootloader.asm
	nasm -Werror bootloader.asm -f bin -o boot.bin
	qemu-system-x86_64.exe -fda boot.bin

c_code: test.c
	gcc -c -Os -m16 -march=i686 -ffreestanding -nostartfiles -nostdlib -Wall -Werror test.c -o test.0