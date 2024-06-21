# Include helper Makefiles
include scripts/Makefile.perl.mk

BIN_DIR = ./bin
SRC_DIR = ./src

PERL_SCRIPT = ./scripts/check_dependencies.pl

PERL = perl
ASM = nasm

.PHONY: all check_dependencies build clean

all: check_dependencies build

check_dependencies: check_perl
	@echo "\nChecking dependencies and tools..."
	$(PERL) $(PERL_SCRIPT)
	@echo "Dependency check complete.\n"

build:
	@echo "Building project..."
	$(ASM) $(SRC_DIR)/boot.asm -f bin -o $(BIN_DIR)/boot.bin
	dd if=./message.txt >> $(BIN_DIR)/boot.bin
	dd if=/dev/zero bs=512 count=1 >> ./$(BIN_DIR)/boot.bin
	@echo "Build complete.\n"

clean:
	@echo "Cleaning build files..."
	@if [ -f $(BIN_DIR)/boot.bin ] ; then \
		rm -f $(BIN_DIR)/boot.bin; \
		echo "Removed $(BIN_DIR)/boot.bin"; \
	else \
		echo "$(BIN_DIR)/boot.bin not found. Nothing to clean."; \
	fi
	@echo "Cleaning complete."