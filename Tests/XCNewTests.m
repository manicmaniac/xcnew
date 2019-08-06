//
//  XCNewTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

@import XCTest;

#import "XCNTestAssertions.h"

@interface XCNewTests : XCTestCase
@end

@implementation XCNewTests {
   @private
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
    int pid = [NSProcessInfo processInfo].processIdentifier;
    _temporaryDirectory = [NSString stringWithFormat:@"%@%@-%d", NSTemporaryDirectory(), NSStringFromClass([self class]), pid];
    NSError *error = nil;
    if (![_fileManager createDirectoryAtPath:_temporaryDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
        XCTFail(@"%@", error);
    }
    [_fileManager changeCurrentDirectoryPath:_temporaryDirectory];
}

- (void)tearDown {
    NSError *error = nil;
    [_fileManager changeCurrentDirectoryPath:_previousDirectory];
    if (![_fileManager removeItemAtPath:_temporaryDirectory error:&error]) {
        XCTFail(@"%@", error);
    }
}

- (void)testRunWithNoArguments {
    NSString *stdoutString = nil, *stderrString = nil;
    XCTAssertEqual(111, [self runWithArguments:@[] standardOutput:&stdoutString standardError:&stderrString]);
    XCTAssertEqualObjects(@"", stdoutString);
    XCTAssertEqualObjects(@"xcnew: Wrong number of arguments (0 for 2).\n", stderrString);
}

- (void)testRunWithShortNumberOfArguments {
    NSString *stdoutString = nil, *stderrString = nil;
    XCTAssertEqual(111, [self runWithArguments:@[ @"Example" ] standardOutput:&stdoutString standardError:&stderrString]);
    XCTAssertEqualObjects(@"", stdoutString);
    XCTAssertEqualObjects(@"xcnew: Wrong number of arguments (1 for 2).\n", stderrString);
}

- (void)testRunWithInvalidShortOptionArguments {
    NSString *stdoutString = nil, *stderrString = nil;
    XCTAssertEqual(110, [self runWithArguments:@[ @"-X" ] standardOutput:&stdoutString standardError:&stderrString]);
    XCTAssertEqualObjects(@"", stdoutString);
    XCTAssertEqualObjects(@"xcnew: Unrecognized option '-X'.\n", stderrString);
}

- (void)testRunWithInvalidLongOptionArguments {
    NSString *stdoutString = nil, *stderrString = nil;
    XCTAssertEqual(110, [self runWithArguments:@[ @"--invalid" ] standardOutput:&stdoutString standardError:&stderrString]);
    XCTAssertEqualObjects(@"", stdoutString);
    XCTAssertEqualObjects(@"xcnew: Unrecognized option '--invalid'.\n", stderrString);
}

- (void)testRunWithHelp {
    NSString *stdoutString = nil, *stderrString = nil;
    XCTAssertEqual(0, [self runWithArguments:@[ @"-h" ] standardOutput:&stdoutString standardError:&stderrString]);
    XCTAssertTrue([stdoutString containsString:@"Usage"]);
    XCTAssertEqualObjects(@"", stderrString);
}

- (void)testRunWithVersion {
    NSString *stdoutString = nil, *stderrString = nil;
    XCTAssertEqual(0, [self runWithArguments:@[ @"-v" ] standardOutput:&stdoutString standardError:&stderrString]);
    XCTAssertTrue([stdoutString containsString:@"."]);
    XCTAssertEqualObjects(@"", stderrString);
}

- (void)testExecuteWithMinimalValidArguments {
    NSString *stdoutString = nil;
    NSString *path = @"./Example/../Example/";
    NSArray *arguments = @[ @"Example", path ];
    XCTAssertEqual(0, [self runWithArguments:arguments standardOutput:&stdoutString standardError:nil]);
    XCTAssertEqualObjects(@"", stdoutString);
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
}

- (void)testExecuteWithAllValidArguments {
    NSString *stdoutString = nil;
    NSString *path = [_temporaryDirectory stringByAppendingPathComponent:@"Example"];
    NSArray *arguments = @[ @"--organization-name=Organization",
                            @"--organization-identifier=com.example",
                            @"--has-unit-tests",
                            @"--has-ui-tests",
                            @"--use-core-data",
                            @"--", // GNU style option scanning terminator
                            @"Example",
                            path ];
    XCTAssertEqual(0, [self runWithArguments:arguments standardOutput:&stdoutString standardError:nil]);
    XCTAssertEqualObjects(@"", stdoutString);
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
}

// MARK: Private

- (int)runWithArguments:(NSArray<NSString *> *)arguments standardOutput:(NSString **)stdoutString standardError:(NSString **)stderrString {
    NSFileHandle *stdoutFileHandle, *stderrFileHandle;
    NSTask *task = [NSTask new];
    task.launchPath = _executablePath;
    task.arguments = arguments;
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
        [stdoutFileHandle closeFile];
        *stdoutString = [[NSString alloc] initWithData:stdoutData encoding:NSUTF8StringEncoding];
    }
    if (stderrString) {
        NSData *stderrData = [stderrFileHandle readDataToEndOfFile];
        [stderrFileHandle closeFile];
        *stderrString = [[NSString alloc] initWithData:stderrData encoding:NSUTF8StringEncoding];
    }
    [task waitUntilExit];
    return task.terminationStatus;
}

@end
