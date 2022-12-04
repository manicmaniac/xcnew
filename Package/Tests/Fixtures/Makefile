LDFLAGS = -rpath '/path with space/Xcode.app/Contents/Developer/../Frameworks' \
          -rpath '/path with space/Xcode.app/Contents/Developer/../PlugIns' \
          -rpath '/path with space/Xcode.app/Contents/Developer/../SharedFrameworks'
SHELL = /bin/sh

all: Container/Applications/Xcode.app/Contents/Developer/usr/bin/xcrun \
	Container/Applications/Xcode.app/Contents/Info.plist \
	Container/Library/Developer/CommandLineTools \
	Container/Payload/usr/local/bin/xcnew

Container/Applications/Xcode.app/Contents/Developer/usr/bin/xcrun:
	mkdir -p $(@D)
	echo '#!/bin/sh' > $@
	echo 'DEVELOPER_DIR="$$ORIGINAL_DEVELOPER_DIR" "$$@"' >> $@
	chmod +x $@

Container/Applications/Xcode.app/Contents/Info.plist:
	mkdir -p $(@D)
	echo 'CFBundleIdentifier = "com.apple.dt.Xcode";' > $@

Container/Library/Developer/CommandLineTools:
	mkdir -p $@

Container/Payload/usr/local/bin/xcnew: xcnew.arm64 xcnew.x86_64
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
