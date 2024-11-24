# Include helper Makefiles
include scripts/Makefile.perl.mk

SRC_DIR = ./src
BIN_DIR = ./bin
BUILD_DIR = ./build

FILES = ./build/kernel.asm.o ./build/kernel.o ./build/display/display.o ./build/disk/disk.o ./build/disk/streamer.o ./build/fs/pparser.o ./build/string/string.o ./build/idt/idt.asm.o ./build/idt/idt.o ./build/memory/memory.o ./build/io/io.o ./build/memory/heap/heap.o ./build/memory/heap/kheap.o ./build/memory/paging/paging.asm.o ./build/memory/paging/paging.o
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
	@echo "Checking dependencies and tools..."
	$(PERL) $(PERL_SCRIPT)
	@echo "Dependency check complete.\n"

build: $(BIN_DIR)/boot.bin $(BIN_DIR)/kernel.bin
	@echo "Building project..."
	rm -rf $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/boot.bin >> $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/kernel.bin >> $(BIN_DIR)/os.bin
	dd if=/dev/zero bs=512 count=100 >> $(BIN_DIR)/os.bin
	@echo "Build complete."

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
	@echo "Building kernel.o..."
	$(CC) $(INCLUDES) $(FLAGS) -std=gnu99 -c $(SRC_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o

$(BUILD_DIR)/display/display.o: $(SRC_DIR)/display/display.c
	@echo "Building display.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/display $(FLAGS) -std=gnu99 -c $(SRC_DIR)/display/display.c -o $(BUILD_DIR)/display/display.o

$(BUILD_DIR)/idt/idt.asm.o: $(SRC_DIR)/idt/idt.asm
	@echo "Building idt.asm.o..."
	$(ASM) -f elf -g $(SRC_DIR)/idt/idt.asm -o $(BUILD_DIR)/idt/idt.asm.o

$(BUILD_DIR)/idt/idt.o: $(SRC_DIR)/idt/idt.c
	@echo "Building idt.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/idt $(FLAGS) -std=gnu99 -c $(SRC_DIR)/idt/idt.c -o $(BUILD_DIR)/idt/idt.o

$(BUILD_DIR)/memory/memory.o: $(SRC_DIR)/memory/memory.c
	@echo "Building memory.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/memory $(FLAGS) -std=gnu99 -c $(SRC_DIR)/memory/memory.c -o $(BUILD_DIR)/memory/memory.o

$(BUILD_DIR)/memory/heap/heap.o: $(SRC_DIR)/memory/heap/heap.c
	@echo "Building heap.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/memory/heap $(FLAGS) -std=gnu99 -c $(SRC_DIR)/memory/heap/heap.c -o $(BUILD_DIR)/memory/heap/heap.o

$(BUILD_DIR)/memory/heap/kheap.o: $(SRC_DIR)/memory/heap/kheap.c
	@echo "Building kheap.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/memory/heap $(FLAGS) -std=gnu99 -c $(SRC_DIR)/memory/heap/kheap.c -o $(BUILD_DIR)/memory/heap/kheap.o

$(BUILD_DIR)/io/io.o: $(SRC_DIR)/io/io.c
	@echo "Building io.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/io $(FLAGS) -std=gnu99 -c $(SRC_DIR)/io/io.c -o $(BUILD_DIR)/io/io.o

$(BUILD_DIR)/memory/paging/paging.asm.o: $(SRC_DIR)/memory/paging/paging.asm
	@echo "Building paging.asm.o..."
	$(ASM) -f elf -g $(SRC_DIR)/memory/paging/paging.asm -o $(BUILD_DIR)/memory/paging/paging.asm.o

$(BUILD_DIR)/memory/paging/paging.o: $(SRC_DIR)/memory/paging/paging.c
	@echo "Building paging.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/memory/paging $(FLAGS) -std=gnu99 -c $(SRC_DIR)/memory/paging/paging.c -o $(BUILD_DIR)/memory/paging/paging.o

$(BUILD_DIR)/disk/disk.o: $(SRC_DIR)/disk/disk.c
	@echo "Building disk.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/disk $(FLAGS) -std=gnu99 -c $(SRC_DIR)/disk/disk.c -o $(BUILD_DIR)/disk/disk.o

$(BUILD_DIR)/disk/streamer.o: $(SRC_DIR)/disk/streamer.c
	@echo "Building streamer.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/disk $(FLAGS) -std=gnu99 -c $(SRC_DIR)/disk/streamer.c -o $(BUILD_DIR)/disk/streamer.o

$(BUILD_DIR)/string/string.o: $(SRC_DIR)/string/string.c
	@echo "Building string.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/string $(FLAGS) -std=gnu99 -c $(SRC_DIR)/string/string.c -o $(BUILD_DIR)/string/string.o

$(BUILD_DIR)/fs/pparser.o: $(SRC_DIR)/fs/pparser.c
	@echo "Building pparser.o..."
	$(CC) $(INCLUDES) -I$(SRC_DIR)/fs $(FLAGS) -std=gnu99 -c $(SRC_DIR)/fs/pparser.c -o $(BUILD_DIR)/fs/pparser.o

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