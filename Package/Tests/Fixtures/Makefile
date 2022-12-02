xcnew: CFLAGS = -arch x86_64
xcnew: LDFLAGS = -rpath '/path with whitespace/Xcode.app/Contents/Developer/../Frameworks' \
                 -rpath '/path with whitespace/Xcode.app/Contents/Developer/../PlugIns' \
                 -rpath '/path with whitespace/Xcode.app/Contents/Developer/../SharedFrameworks'
xcnew:

xcnew.c:
	echo 'int main() {}' > $@

clean:
	$(RM) xcnew.c

distclean: clean
	$(RM) xcnew
