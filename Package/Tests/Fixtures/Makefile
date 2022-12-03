LDFLAGS = -rpath '/path with space/Xcode.app/Contents/Developer/../Frameworks' \
          -rpath '/path with space/Xcode.app/Contents/Developer/../PlugIns' \
          -rpath '/path with space/Xcode.app/Contents/Developer/../SharedFrameworks'
SHELL = /bin/sh

all: xcnew

xcnew: xcnew.arm64 xcnew.x86_64
	lipo -create $^ -output $@

xcnew.arm64: CFLAGS = -arch arm64
xcnew.x86_64: CFLAGS = -arch x86_64
xcnew.arm64 xcnew.x86_64:
	echo 'int main() {}' | $(CC) -xc $(CPPFLAGS) $(CFLAGS) - $(LDFLAGS) -o $@

clean:
	$(RM) xcnew

.INTERMEDIATE: xcnew.c xcnew.arm64 xcnew.x86_64

.PHONY: all clean
