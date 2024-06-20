ASM = nasm

all:
	$(ASM) ./boot.asm -f bin -o boot.bin

clean:
	rm -rf ./boot.bin