all: test.asm
	nasm test.asm -f bin -o test.bin
	qemu-system-x86_64.exe -fda test.bin
