# Include helper Makefiles
include scripts/Makefile.perl

BIN_DIR = ./bin

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
	$(ASM) ./boot.asm -f bin -o $(BIN_DIR)/boot.bin
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