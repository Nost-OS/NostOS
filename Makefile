# Include helper Makefiles
include scripts/Makefile.perl.mk

SRC_DIR = ./src
BIN_DIR = ./bin
BUILD_DIR = ./build

FILES = ./build/kernel.asm.o ./build/kernel.o ./build/display/display.o
INCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

PERL_SCRIPT = ./scripts/check_dependencies.pl

PERL = perl
ASM = nasm
LD = i686-elf-ld
CC = i686-elf-gcc

.PHONY: all check_dependencies build clean

all: check_dependencies build

check_dependencies: check_perl
	@echo "\nChecking dependencies and tools..."
	$(PERL) $(PERL_SCRIPT)
	@echo "Dependency check complete.\n"

build: $(BIN_DIR)/boot.bin $(BIN_DIR)/kernel.bin
	@echo "Building project..."
	rm -rf $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/boot.bin >> $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/kernel.bin >> $(BIN_DIR)/os.bin
	dd if=/dev/zero bs=512 count=100 >> $(BIN_DIR)/os.bin
	@echo "Build complete.\n"

$(BIN_DIR)/kernel.bin: $(FILES)
	@echo "Building kernel.bin..."
	$(LD) -g -relocatable $(FILES) -o $(BUILD_DIR)/kernelfull.o
	$(CC) $(FLAGS) -T $(SRC_DIR)/linker.ld -o $(BIN_DIR)/kernel.bin -ffreestanding -O0 -nostdlib $(BUILD_DIR)/kernelfull.o

$(BIN_DIR)/boot.bin: $(SRC_DIR)/boot/boot.asm
	@echo "Building boot.bin..."
	$(ASM) $(SRC_DIR)/boot/boot.asm -f bin -o $(BIN_DIR)/boot.bin

$(BUILD_DIR)/kernel.asm.o: $(SRC_DIR)/kernel.asm
	@echo "Building kernel.asm.o..."
	$(ASM) -f elf -g $(SRC_DIR)/kernel.asm -o $(BUILD_DIR)/kernel.asm.o

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.c
	$(CC) $(INCLUDES) $(FLAGS) -std=gnu99 -c $(SRC_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o

$(BUILD_DIR)/display/display.o: $(SRC_DIR)/display/display.c
	$(CC) $(INCLUDES) -I$(SRC_DIR)/display $(FLAGS) -std=gnu99 -c $(SRC_DIR)/display/display.c -o $(BUILD_DIR)/display/display.o

clean:
	@echo "Cleaning build files..."
	@if [ -f $(BIN_DIR)/boot.bin ] ; then \
		rm -f $(BIN_DIR)/boot.bin; \
		echo "Removed $(BIN_DIR)/boot.bin"; \
	else \
		echo "$(BIN_DIR)/boot.bin not found. Nothing to clean."; \
	fi
	@if [ -f $(BIN_DIR)/kernel.bin ] ; then \
		rm -f $(BIN_DIR)/kernel.bin; \
		echo "Removed $(BIN_DIR)/kernel.bin"; \
	else \
		echo "$(BIN_DIR)/kernel.bin not found. Nothing to clean."; \
	fi
	@if [ -f $(BIN_DIR)/os.bin ] ; then \
		rm -f $(BIN_DIR)/os.bin; \
		echo "Removed $(BIN_DIR)/os.bin"; \
	else \
		echo "$(BIN_DIR)/os.bin not found. Nothing to clean."; \
	fi
	@if [ -f $(BUILD_DIR)/kernelfull.o ] ; then \
		rm -f $(BUILD_DIR)/kernelfull.o; \
		echo "Removed $(BUILD_DIR)/kernelfull.o"; \
	else \
		echo "$(BUILD_DIR)/kernelfull.o not found. Nothing to clean."; \
	fi
	rm -rf $(FILES)
	@echo "Cleaning complete."