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
    NSString *_executablePath;
}

// MARK: Public

- (void)setUp {
    _fileManager = [NSFileManager defaultManager];
    int pid = [NSProcessInfo processInfo].processIdentifier;
    _temporaryDirectory = [NSString stringWithFormat:@"%@%@-%d", NSTemporaryDirectory(), NSStringFromClass([self class]), pid];
    NSError *error = nil;
    if (![_fileManager createDirectoryAtPath:_temporaryDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
        NSLog(@"%@", error);
    }
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    _executablePath = [[bundle.executablePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"xcnew"];
}

- (void)tearDown {
    NSError *error = nil;
    if (![_fileManager removeItemAtPath:_temporaryDirectory error:&error]) {
        NSLog(@"%@", error);
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
    NSString *stdoutString = nil, *stderrString = nil;
    NSString *path = [_temporaryDirectory stringByAppendingPathComponent:@"Example"];
    NSArray *arguments = @[ @"Example", path ];
    XCTAssertEqual(0, [self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString]);
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
}

- (void)testExecuteWithAllValidArguments {
    NSString *stdoutString = nil, *stderrString = nil;
    NSString *path = [_temporaryDirectory stringByAppendingPathComponent:@"Example"];
    NSArray *arguments = @[ @"--organization-name=Organization",
                            @"--organization-identifier=com.example",
                            @"--has-unit-tests",
                            @"--has-ui-tests",
                            @"--use-core-data",
                            @"--", // GNU style option scanning terminator
                            @"Example",
                            path ];
    XCTAssertEqual(0, [self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString]);
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
    NSError *error = nil;
    NSString *appDelegateSource = [NSString stringWithContentsOfFile:appDelegatePath encoding:NSUTF8StringEncoding error:&error];
    XCTAssertNil(error);
    XCTAssert([appDelegateSource containsString:@"Organization"]);
}

// MARK: Private

- (int)runWithArguments:(NSArray<NSString *> *)arguments standardOutput:(NSString **)stdoutString standardError:(NSString **)stderrString {
    NSTask *task = [NSTask new];
    task.launchPath = _executablePath;
    task.arguments = arguments;
    NSPipe *stdoutPipe = [NSPipe pipe];
    NSPipe *stderrPipe = [NSPipe pipe];
    NSFileHandle *stdoutFileHandle = stdoutPipe.fileHandleForReading;
    NSFileHandle *stderrFileHandle = stderrPipe.fileHandleForReading;
    task.standardOutput = stdoutPipe;
    task.standardError = stderrPipe;
    [task launch];
    NSData *stdoutData = [stdoutFileHandle readDataToEndOfFile];
    [stdoutFileHandle closeFile];
    NSData *stderrData = [stderrFileHandle readDataToEndOfFile];
    [stderrFileHandle closeFile];
    if (stdoutString) {
        *stdoutString = [[NSString alloc] initWithData:stdoutData encoding:NSUTF8StringEncoding];
    }
    if (stderrString) {
        *stderrString = [[NSString alloc] initWithData:stderrData encoding:NSUTF8StringEncoding];
    }
    [task waitUntilExit];
    return task.terminationStatus;
}

@end
