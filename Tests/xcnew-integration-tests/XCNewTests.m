//
//  XCNewTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNFileHierarchyAssertions.h"
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

- (void)testExecuteWithDefaultOptions {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/default");
}

#if XCN_TEST_OPTION_IS_UNIFIED
- (void)testExecuteWithTests {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-t", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/tests");
}
#else
- (void)testExecuteWithUnitTests {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-t", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/unit-tests");
}

- (void)testExecuteWithUITests {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-u", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/ui-tests");
}
#endif // XCN_TEST_OPTION_IS_UNIFIED

- (void)testExecuteWithCoreData {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-c", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/core-data");
}

#if XCN_CLOUD_KIT_IS_AVAILABLE
- (void)testExecuteWithCloudKit {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-C", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/cloud-kit");
}
#endif // XCN_CLOUD_KIT_IS_AVAILABLE

- (void)testExecuteWithObjectiveC {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-o", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/objective-c");
}

#if XCN_SWIFT_UI_IS_AVAILABLE
- (void)testExecuteWithSwiftUI {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-s", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/swift-ui");
}
#endif // XCN_SWIFT_UI_IS_AVAILABLE

#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE
- (void)testExecuteWithSwiftUILifecycle {
    NSString *stdoutString, *stderrString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-S", productName ];
    XCTAssertEqual([self runWithArguments:arguments standardOutput:&stdoutString standardError:&stderrString], 0);
    XCTAssertEqualObjects(stdoutString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/swift-ui-lifecycle");
}
#endif // XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE

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
