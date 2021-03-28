//
//  XCNewTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNMacroDefinitions.h"

@interface XCNewTests : XCTestCase
@end

@implementation XCNewTests {
    NSFileManager *_fileManager;
    NSURL *_temporaryDirectoryURL;
    NSURL *_currentDirectoryURL;
    NSURL *_executableURL;
    NSURL *_sandboxProfileURL;
}

// MARK: Public

- (void)setUp {
    _fileManager = NSFileManager.defaultManager;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    _executableURL = [bundle URLForAuxiliaryExecutable:@"xcnew"];
    _sandboxProfileURL = [bundle URLForResource:@"xcnew-integration-tests" withExtension:@"sb"];
    NSError *error;
    _temporaryDirectoryURL = [_fileManager URLForDirectory:NSItemReplacementDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:_fileManager.temporaryDirectory
                                                    create:YES
                                                     error:&error];
    if (!_temporaryDirectoryURL) {
        self.continueAfterFailure = NO;
        return XCTFail(@"%@", error);
    }
    _currentDirectoryURL = [_temporaryDirectoryURL URLByAppendingPathComponent:@"Current"];
    if (![_fileManager createDirectoryAtURL:_currentDirectoryURL
                withIntermediateDirectories:NO
                                 attributes:nil
                                      error:&error]) {
        self.continueAfterFailure = NO;
        return XCTFail(@"%@", error);
    }
}

- (void)tearDown {
    NSError *error;
    if (![_fileManager removeItemAtURL:_temporaryDirectoryURL error:&error]) {
        XCTFail(@"%@", error);
    }
}

- (void)testRunWithNoArguments {
    NSString *stdoutString, *stderrString;
    XCTAssertEqual([self runWithArguments:@[] standardOutput:&stdoutString standardError:&stderrString], 111);
    XCTAssertEqualObjects(stdoutString, @"");
    XCTAssertEqualObjects(stderrString, @"xcnew: Wrong number of arguments (0 for 1..2).\n");
}

- (void)testRunWithInvalidShortOptionArguments {
    NSString *stdoutString, *stderrString;
    XCTAssertEqual([self runWithArguments:@[ @"-X" ] standardOutput:&stdoutString standardError:&stderrString], 110);
    XCTAssertEqualObjects(stdoutString, @"");
    XCTAssertEqualObjects(stderrString, @"xcnew: Unrecognized option '-X'.\n");
}

- (void)testRunWithInvalidLongOptionArguments {
    NSString *stdoutString, *stderrString;
    XCTAssertEqual([self runWithArguments:@[ @"--invalid" ] standardOutput:&stdoutString standardError:&stderrString], 110);
    XCTAssertEqualObjects(stdoutString, @"");
    XCTAssertEqualObjects(stderrString, @"xcnew: Unrecognized option '--invalid'.\n");
}

- (void)testRunWithHelp {
    NSString *stdoutString, *stderrString;
    XCTAssertEqual([self runWithArguments:@[ @"-h" ] standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertTrue([stdoutString containsString:@"Usage"]);
    XCTAssertEqualObjects(stderrString, @"");
}

- (void)testRunWithVersion {
    NSString *stdoutString, *stderrString;
    XCTAssertEqual([self runWithArguments:@[ @"-v" ] standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertTrue([stdoutString containsString:@"."]);
    XCTAssertEqualObjects(stderrString, @"");
}

- (void)testExecuteWithMinimalValidArguments {
    NSString *stdoutString, *stderrString;
    NSString *path = @"Example";
    NSArray *arguments = @[ @"Example" ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");

    NSError *error;
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:[_currentDirectoryURL URLByAppendingPathComponent:path]
                                                            options:(NSFileWrapperReadingOptions)0
                                                              error:&error];
    if (!fileWrapper) {
        return XCTFail(@"%@", error);
    }
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertNil(fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"ExampleUITests"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}

#if XCN_SWIFT_UI_IS_AVAILABLE
- (void)testExecuteWithAllValidArgumentsEnablingSwiftUI {
    NSString *stdoutString, *stderrString;
    NSString *path = @"./Example/../Example/";
    NSArray *arguments = @[ @"--organization-name=Organization",
                            @"--organization-identifier=com.example",
#if XCN_TEST_OPTION_IS_UNIFIED
                            @"--has-tests",
#else
                            @"--has-unit-tests",
                            @"--has-ui-tests",
#endif // XCN_TEST_OPTION_IS_UNIFIED
                            @"--use-core-data",
                            @"--swift-ui",
                            @"--", // GNU style option scanning terminator
                            @"ProductName",
                            path ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    NSError *error;
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:[_currentDirectoryURL URLByAppendingPathComponent:path]
                                                            options:(NSFileWrapperReadingOptions)0
                                                              error:&error];
    if (!fileWrapper) {
        return XCTFail(@"%@", error);
    }
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"].isDirectory);
    XCTAssertTrue(fileWrapper.fileWrappers[@"ExampleTests"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"ExampleUITests"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
#if XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE
    XCTAssertTrue([appDelegateContents containsString:@"Organization"]);
#else
    XCTAssertFalse([appDelegateContents containsString:@"Organization"]);
#endif // XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"].isRegularFile);
    XCTAssertNil(fileWrapper.fileWrappers[@".git"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}
#endif // XCN_SWIFT_UI_IS_AVAILABLE

#if XCN_CLOUD_KIT_IS_AVAILABLE
- (void)testExecuteWithAllValidArgumentsEnablingCloudKit {
    NSString *stdoutString, *stderrString;
    NSString *path = @"./Example/../Example/";
    NSArray *arguments = @[ @"--organization-name=Organization",
                            @"--organization-identifier=com.example",
#if XCN_TEST_OPTION_IS_UNIFIED
                            @"--has-tests",
#else
                            @"--has-unit-tests",
                            @"--has-ui-tests",
#endif // XCN_TEST_OPTION_IS_UNIFIED
                            @"--use-cloud-kit",
                            @"--", // GNU style option scanning terminator
                            @"ProductName",
                            path ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    NSError *error;
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:[_currentDirectoryURL URLByAppendingPathComponent:path]
                                                            options:(NSFileWrapperReadingOptions)0
                                                              error:&error];
    if (!fileWrapper) {
        return XCTFail(@"%@", error);
    }
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"].isDirectory);
    XCTAssertTrue(fileWrapper.fileWrappers[@"ExampleTests"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"ExampleUITests"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
#if XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE
    XCTAssertTrue([appDelegateContents containsString:@"Organization"]);
#else
    XCTAssertFalse([appDelegateContents containsString:@"Organization"]);
#endif // XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE
    XCTAssertTrue([appDelegateContents containsString:@"NSPersistentCloudKitContainer"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"]);
    XCTAssertNil(fileWrapper.fileWrappers[@".git"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}
#endif // XCN_CLOUD_KIT_IS_AVAILABLE

- (void)testExecuteWithAllValidArgumentsDisablingSwiftUI {
    NSString *stdoutString, *stderrString;
    NSString *path = @"./Example/../Example/";
    NSArray *arguments = @[ @"--organization-name=Organization",
                            @"--organization-identifier=com.example",
#if XCN_TEST_OPTION_IS_UNIFIED
                            @"--has-tests",
#else
                            @"--has-unit-tests",
                            @"--has-ui-tests",
#endif // XCN_TEST_OPTION_IS_UNIFIED
                            @"--use-core-data",
                            @"--", // GNU style option scanning terminator
                            @"ProductName",
                            path ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    NSError *error;
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:[_currentDirectoryURL URLByAppendingPathComponent:path]
                                                            options:(NSFileWrapperReadingOptions)0
                                                              error:&error];
    if (!fileWrapper) {
        return XCTFail(@"%@", error);
    }
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"].isDirectory);
    XCTAssertTrue(fileWrapper.fileWrappers[@"ExampleTests"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(fileWrapper.fileWrappers[@"ExampleUITests"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
#if XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE
    XCTAssertTrue([appDelegateContents containsString:@"Organization"]);
#else
    XCTAssertFalse([appDelegateContents containsString:@"Organization"]);
#endif // XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE
    XCTAssertFalse([appDelegateContents containsString:@"NSPersistentCloudKitContainer"]);
    XCTAssertNil(fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}

- (void)testExecuteWithInaccessiblePath {
    NSString *stdoutString, *stderrString;
    NSURL *url = [_temporaryDirectoryURL URLByAppendingPathComponent:@"Inaccessible"];
    NSError *error;
    if (![_fileManager createDirectoryAtURL:url withIntermediateDirectories:NO attributes:nil error:&error]) {
        return XCTFail(@"%@", error);
    }
    if (![_fileManager setAttributes:@{NSFileImmutable : @YES} ofItemAtPath:url.path error:&error]) {
        return XCTFail(@"%@", error);
    }
    __weak typeof(self) wself = self;
    [self addTeardownBlock:^{
        __strong typeof(wself) self = wself;
        NSError *error;
        if (![self->_fileManager setAttributes:@{NSFileImmutable : @NO} ofItemAtPath:url.path error:&error]) {
            XCTFail(@"%@", error);
        }
    }];
    NSArray *arguments = @[ @"ProductName", url.path ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 1);
    XCTAssertEqualObjects(stdoutString, @"");
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:url
                                                            options:(NSFileWrapperReadingOptions)0
                                                              error:&error];
    if (!fileWrapper) {
        return XCTFail(@"%@", error);
    }
    XCTAssertNil(fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(fileWrapper.fileWrappers[@"Inaccessible.xcodeproj"].fileWrappers[@"project.pbxproj"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}

// MARK: Private

- (int)runWithArguments:(NSArray<NSString *> *)arguments standardOutput:(NSString **)stdoutString standardError:(NSString **)stderrString {
    NSFileHandle *stdoutFileHandle, *stderrFileHandle;
    NSTask *task = [[NSTask alloc] init];
    task.currentDirectoryURL = _currentDirectoryURL;
    task.launchPath = @"/usr/bin/sandbox-exec";
    task.arguments = [@[ @"-f", _sandboxProfileURL.path, _executableURL.path ] arrayByAddingObjectsFromArray:arguments];
    if (stdoutString) {
        NSPipe *stdoutPipe = [NSPipe pipe];
        stdoutFileHandle = stdoutPipe.fileHandleForReading;
        task.standardOutput = stdoutPipe;
    }
    if (stderrString) {
        NSPipe *stderrPipe = [NSPipe pipe];
        stderrFileHandle = stderrPipe.fileHandleForReading;
        task.standardError = stderrPipe;
    }
    [task launch];
    if (stdoutString) {
        NSData *stdoutData = [stdoutFileHandle readDataToEndOfFile];
        *stdoutString = [[NSString alloc] initWithData:stdoutData encoding:NSUTF8StringEncoding];
    }
    if (stderrString) {
        NSData *stderrData = [stderrFileHandle readDataToEndOfFile];
        *stderrString = [[NSString alloc] initWithData:stderrData encoding:NSUTF8StringEncoding];
    }
    [task waitUntilExit];
    return task.terminationStatus;
}

@end
