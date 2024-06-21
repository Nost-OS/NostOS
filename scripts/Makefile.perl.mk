# ================================================
# Install perl if not existing
# ================================================

PHONY := check_perl install_perl

check_perl:
	@echo "Checking for perl..."
	@which perl 2>/dev/null || $(MAKE) install_perl
	@echo "Perl is installed."

install_perl:
	@echo "Perl is not installed. Installing perl..."
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt-get update && sudo apt-get install -y Perl; \
	else \
		echo "Unsupported package manager. Please install perl manually."; \
		exit 1; \
	fi
	@which perl > /dev/null 2>&1 && echo "Perl has been installed successfully.\n" || { echo "Failed to install Perl."; exit 1; }

.PHONY: $(PHONY)