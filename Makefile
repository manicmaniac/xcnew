.PHONY: all install uninstall check clean distclean format manpages

PREFIX = /usr/local
BUILD_DIR = build
XCODEBUILD = xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release BUILD_DIR=$(BUILD_DIR)
EXECUTABLE = $(BUILD_DIR)/Release/xcnew

%.1: %.mxml
	@echo "Warning: Some version of xml2man does not support option descriptions." >&2
	@echo "         Please make sure every option is described in generated manual." >&2
	xcrun xml2man -f $< $@

all: $(EXECUTABLE)

install:
	$(XCODEBUILD) install DSTROOT=$(PREFIX)

uninstall:
	$(RM) $(PREFIX)/bin/xcnew $(PREFIX)/share/man/man1/xcnew.1

check:
	$(XCODEBUILD) test

clean:
	$(XCODEBUILD) clean

distclean: clean
	$(RM) -R $(BUILD_DIR)

format:
	find Sources Tests -type f -name '*.[hm]' -exec clang-format -i {} +

manpages: Sources/xcnew/xcnew.1

$(EXECUTABLE):
	$(XCODEBUILD) build
