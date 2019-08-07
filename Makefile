.PHONY: all install uninstall check clean distclean

PREFIX ?= /usr/local
BUILD_DIR ?= build

all: build/Release/xcnew

install:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release install BUILD_DIR=$(BUILD_DIR) DSTROOT=$(PREFIX)

uninstall:
	$(RM) $(PREFIX)/bin/xcnew

check:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Debug test BUILD_DIR=$(BUILD_DIR)

clean:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release clean BUILD_DIR=$(BUILD_DIR)

distclean: clean
	$(RM) -R build

build/Release/xcnew:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release build BUILD_DIR=$(BUILD_DIR)
