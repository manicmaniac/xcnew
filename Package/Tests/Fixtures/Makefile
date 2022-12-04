LDFLAGS = -rpath '/path with space/Xcode.app/Contents/Developer/../Frameworks' \
          -rpath '/path with space/Xcode.app/Contents/Developer/../PlugIns' \
          -rpath '/path with space/Xcode.app/Contents/Developer/../SharedFrameworks'
SHELL = /bin/sh

INSTALLER_PAYLOAD_DIR = Payload
INSTALLER_XCNEW_PATH = $(INSTALLER_PAYLOAD_DIR)/usr/local/bin/xcnew
COMMAND_LINE_TOOLS_DEVELOPER_DIR = Library/Developer/CommandLineTools
XCODE_CONTENTS_DIR = Applications/Xcode.app/Contents
XCODE_DEVELOPER_DIR = $(XCODE_CONTENTS_DIR)/Developer

all: Container/$(XCODE_DEVELOPER_DIR)/usr/bin/xcrun \
	Container/$(XCODE_CONTENTS_DIR)/Info.plist \
	Container/$(COMMAND_LINE_TOOLS_DEVELOPER_DIR) \
	Container/$(INSTALLER_XCNEW_PATH)

Container/$(XCODE_DEVELOPER_DIR)/usr/bin/xcrun:
	mkdir -p $(@D)
	echo '#!/bin/sh' > $@
	echo 'DEVELOPER_DIR="$$ORIGINAL_DEVELOPER_DIR" "$$@"' >> $@
	chmod +x $@

Container/$(XCODE_CONTENTS_DIR)/Info.plist:
	mkdir -p $(@D)
	echo 'CFBundleIdentifier = "com.apple.dt.Xcode";' > $@

Container/$(COMMAND_LINE_TOOLS_DEVELOPER_DIR):
	mkdir -p $@

Container/$(INSTALLER_XCNEW_PATH): xcnew.arm64 xcnew.x86_64
	mkdir -p $(@D)
	lipo -create $^ -output $@

xcnew.arm64: CFLAGS = -arch arm64
xcnew.x86_64: CFLAGS = -arch x86_64
xcnew.arm64 xcnew.x86_64:
	echo 'int main() {}' | $(CC) -xc $(CPPFLAGS) $(CFLAGS) - $(LDFLAGS) -o $@

clean:
	$(RM) -R Container

.INTERMEDIATE: xcnew.arm64 xcnew.x86_64

.PHONY: all clean
