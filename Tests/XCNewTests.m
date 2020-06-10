//
//  XCNewTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNMacroDefinitions.h"
#import "XCNSecureTemporaryDirectory.h"
#import "XCNTestAssertions.h"

@interface XCNewTests : XCTestCase
@end

@implementation XCNewTests {
    NSFileManager *_fileManager;
    NSString *_temporaryDirectory;
    NSString *_previousDirectory;
    NSString *_executablePath;
}

// MARK: Public

- (void)setUp {
    _fileManager = NSFileManager.defaultManager;
    _previousDirectory = _fileManager.currentDirectoryPath;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    _executablePath = [bundle.executablePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"xcnew"];
    NSError *error;
    _temporaryDirectory = XCNCreateSecureTemporaryDirectoryWithBasename(@"XCNewTests-XXXXXX", &error);
    if (!_temporaryDirectory) {
        XCTFail(@"%@", error);
    }
    [_fileManager changeCurrentDirectoryPath:_temporaryDirectory];
}

- (void)tearDown {
    NSError *error;
    [_fileManager changeCurrentDirectoryPath:_previousDirectory];
    if (![_fileManager removeItemAtPath:_temporaryDirectory error:&error]) {
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
    XCNAssertDirectoryExistsAtPath(path);
    NSLog(@"%@", [_fileManager contentsOfDirectoryAtPath:path error:nil]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@".git/"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example.xcodeproj/project.pbxproj"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example/Info.plist"]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@"Example/Example.xcdatamodeld/Example.xcdatamodel/contents"]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@"ExampleTests/Info.plist"]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@"ExampleUITests/Info.plist"]);
    NSString *appDelegatePath = [path stringByAppendingPathComponent:@"Example/AppDelegate.swift"];
    XCNAssertFileExistsAtPath(appDelegatePath);
    XCNAssertFileContainsString(appDelegatePath, @"Example");
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@"Example/ContentView.swift"]);
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
                            @"--has-unit-tests",
                            @"--has-ui-tests",
                            @"--use-core-data",
                            @"--swift-ui",
                            @"--", // GNU style option scanning terminator
                            @"ProductName",
                            path ];
    path = [_fileManager.currentDirectoryPath stringByAppendingPathComponent:path].stringByStandardizingPath;
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertDirectoryExistsAtPath(path);
    NSLog(@"%@", [_fileManager contentsOfDirectoryAtPath:path error:nil]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@".git/"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example.xcodeproj/project.pbxproj"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example/Info.plist"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example/Example.xcdatamodeld/Example.xcdatamodel/contents"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"ExampleTests/Info.plist"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"ExampleUITests/Info.plist"]);
    NSString *appDelegatePath = [path stringByAppendingPathComponent:@"Example/AppDelegate.swift"];
    XCNAssertFileExistsAtPath(appDelegatePath);
    XCNAssertFileContainsString(appDelegatePath, @"Organization");
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example/ContentView.swift"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}
#endif

- (void)testExecuteWithAllValidArgumentsDisablingSwiftUI {
    NSString *stdoutString, *stderrString;
    NSString *path = @"./Example/../Example/";
    NSArray *arguments = @[ @"--organization-name=Organization",
                            @"--organization-identifier=com.example",
                            @"--has-unit-tests",
                            @"--has-ui-tests",
                            @"--use-core-data",
                            @"--", // GNU style option scanning terminator
                            @"ProductName",
                            path ];
    path = [_fileManager.currentDirectoryPath stringByAppendingPathComponent:path].stringByStandardizingPath;
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertDirectoryExistsAtPath(path);
    NSLog(@"%@", [_fileManager contentsOfDirectoryAtPath:path error:nil]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@".git/"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example.xcodeproj/project.pbxproj"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example/Info.plist"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"Example/Example.xcdatamodeld/Example.xcdatamodel/contents"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"ExampleTests/Info.plist"]);
    XCNAssertFileExistsAtPath([path stringByAppendingPathComponent:@"ExampleUITests/Info.plist"]);
    NSString *appDelegatePath = [path stringByAppendingPathComponent:@"Example/AppDelegate.swift"];
    XCNAssertFileExistsAtPath(appDelegatePath);
    XCNAssertFileContainsString(appDelegatePath, @"Organization");
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@"Example/ContentView.swift"]);
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}

- (void)testExecuteWithInaccessiblePath {
    NSString *stdoutString, *stderrString;
    NSString *path = [_temporaryDirectory stringByAppendingPathComponent:@"Inaccessible"];
    NSError *error;
    if (![_fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]) {
        return XCTFail(@"%@", error);
    }
    if (![_fileManager setAttributes:@{NSFileImmutable : @YES} ofItemAtPath:path error:&error]) {
        return XCTFail(@"%@", error);
    }
    NSArray *arguments = @[ @"ProductName", path ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 1);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertDirectoryExistsAtPath(path);
    NSLog(@"%@", [_fileManager contentsOfDirectoryAtPath:path error:nil]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@".git/"]);
    XCNAssertFileOrDirectoryDoesNotExistAtPath([path stringByAppendingPathComponent:@"Inaccessible.xcodeproj/project.pbxproj"]);
    if (![_fileManager setAttributes:@{NSFileImmutable : @NO} ofItemAtPath:path error:&error]) {
        XCTFail(@"%@", error);
    }
    if (self.testRun.failureCount) {
        XCTFail(@"%@", stderrString);
    }
}

// MARK: Private

- (int)runWithArguments:(NSArray<NSString *> *)arguments standardOutput:(NSString **)stdoutString standardError:(NSString **)stderrString {
    NSFileHandle *stdoutFileHandle, *stderrFileHandle;
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/sandbox-exec";
    task.arguments = [@[ @"-f", [self sandboxProfileURL].path, _executablePath ] arrayByAddingObjectsFromArray:arguments];
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

- (NSURL *)sandboxProfileURL {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [bundle URLForResource:@"xcnew-tests" withExtension:@"sb"];
}

@end
