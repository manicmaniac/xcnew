xcnew: CFLAGS = -arch x86_64
xcnew: LDFLAGS = -rpath /Applications/Xcode.app/Contents/Developer/../Frameworks \
                 -rpath /Applications/Xcode.app/Contents/Developer/../PlugIns \
                 -rpath /Applications/Xcode.app/Contents/Developer/../SharedFrameworks
xcnew:

xcnew.c:
	echo 'int main() {}' > $@

clean:
	$(RM) xcnew.c

distclean: clean
	$(RM) xcnew
