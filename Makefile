.PHONY: all install uninstall check installcheck clean distclean format generate xcnew.pkg

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
	$(XCODEBUILD) -resultBundlePath ./xcnew.xcresult test
	env PYTHONDONTWRITEBYTECODE=1 python3 -munittest discover --verbose Package/Tests

installcheck:
	xcodebuild build -project xcnew.xcodeproj -target xcnew-integration-tests
	env XCNEW_TEST_TARGET_EXECUTABLE_PATH=$(PREFIX)/bin/xcnew $(XCODEBUILD) test-without-building -only-testing xcnew-integration-tests/XCNewTests

clean:
	$(XCODEBUILD) clean

distclean: clean
	$(RM) -R $(BUILD_DIR)

format:
	find Sources Tests -type f -name '*.[hm]' -exec clang-format -i {} +

generate: README.md Sources/xcnew/XCNOptionDefinitions.c

$(EXECUTABLE):
	$(XCODEBUILD) build

README.md: Sources/xcnew/xcnew.mxml
	./Scripts/xml2c -HiI4 $< $@

Sources/xcnew/XCNOptionDefinitions.c: Sources/xcnew/xcnew.mxml
	./Scripts/xml2c -p XCN $< $@

xcnew.pkg:
	./Scripts/build-package
