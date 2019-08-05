.PHONY: all install uninstall check clean distclean

PREFIX ?= /usr/local
BUILD_DIR ?= build

all: build/Release/xcnew

install: $(PREFIX)/bin/xcnew

uninstall:
	$(RM) $(PREFIX)/bin/xcnew

check:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Debug test BUILD_DIR=$(BUILD_DIR)

clean:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release clean BUILD_DIR=$(BUILD_DIR)

distclean:
	$(RM) -R build

$(PREFIX)/bin/xcnew: build/Release/xcnew
	install $< $@

build/Release/xcnew:
	xcodebuild -project xcnew.xcodeproj -scheme xcnew -configuration Release build BUILD_DIR=$(BUILD_DIR)
