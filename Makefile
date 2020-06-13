.PHONY: all install uninstall check clean distclean

PREFIX = /usr/local
BUILD_DIR = build
XCODEBUILD = xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release BUILD_DIR=$(BUILD_DIR)
EXECUTABLE = $(BUILD_DIR)/Release/xcnew

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

$(EXECUTABLE):
	$(XCODEBUILD) build
