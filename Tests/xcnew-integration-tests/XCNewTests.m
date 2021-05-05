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
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[] output:&outputString error:&errorString], 111);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"xcnew: Wrong number of arguments (0 for 1..2).\n");
}

- (void)testRunWithInvalidShortOptionArguments {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[ @"-X" ] output:&outputString error:&errorString], 110);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"xcnew: Unrecognized option '-X'.\n");
}

- (void)testRunWithInvalidLongOptionArguments {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[ @"--invalid" ] output:&outputString error:&errorString], 110);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"xcnew: Unrecognized option '--invalid'.\n");
}

- (void)testRunWithHelp {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[ @"-h" ] output:&outputString error:&errorString], 0);
    XCTAssertTrue([outputString containsString:@"Usage"]);
    XCTAssertEqualObjects(errorString, @"");
}

- (void)testRunWithVersion {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[ @"-v" ] output:&outputString error:&errorString], 0);
    XCTAssertTrue([outputString containsString:@"."]);
    XCTAssertEqualObjects(errorString, @"");
}

- (void)testExecuteWithDefaultOptions {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1100 ? @"Fixtures/default" : @"Fixtures/default@xcode10");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}

#if XCN_TEST_OPTION_IS_UNIFIED
- (void)testExecuteWithTests {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-t", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/tests");
}
#else
- (void)testExecuteWithUnitTests {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-t", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1100 ? @"Fixtures/unit-tests" : @"Fixtures/unit-tests@xcode10");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}

- (void)testExecuteWithUITests {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-u", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1100 ? @"Fixtures/ui-tests" : @"Fixtures/ui-tests@xcode10");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}
#endif // XCN_TEST_OPTION_IS_UNIFIED

- (void)testExecuteWithCoreData {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-c", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1100 ? @"Fixtures/core-data" : @"Fixtures/core-data@xcode10");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}

#if XCN_CLOUD_KIT_IS_AVAILABLE
- (void)testExecuteWithCloudKit {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-C", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/cloud-kit");
}
#endif // XCN_CLOUD_KIT_IS_AVAILABLE

- (void)testExecuteWithObjectiveC {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-o", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1100 ? @"Fixtures/objective-c" : @"Fixtures/objective-c@xcode10");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}

#if XCN_SWIFT_UI_IS_AVAILABLE
- (void)testExecuteWithSwiftUI {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-s", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/swift-ui");
}
#endif // XCN_SWIFT_UI_IS_AVAILABLE

#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE
- (void)testExecuteWithSwiftUILifecycle {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-S", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/swift-ui-lifecycle");
}
#endif // XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE

// MARK: Private

- (int)runWithArguments:(NSArray<NSString *> *)arguments output:(NSString **)outputString error:(NSString **)errorString {
    NSTask *task = [[NSTask alloc] init];
    task.currentDirectoryURL = _currentDirectoryURL;
    task.executableURL = [NSURL fileURLWithPath:@"/usr/bin/sandbox-exec"];
    task.arguments = [@[ @"-f", _sandboxProfileURL.path, _executableURL.path ] arrayByAddingObjectsFromArray:arguments];
    NSPipe *outputPipe = [NSPipe pipe];
    task.standardOutput = outputPipe;
    NSPipe *errorPipe = [NSPipe pipe];
    task.standardError = errorPipe;
    NSError *error;
    if (![task launchAndReturnError:&error]) {
        self.continueAfterFailure = NO;
        XCTFail(@"%@", error);
        return -1;
    }
    [task waitUntilExit];
    [outputPipe.fileHandleForWriting closeFile];
    [errorPipe.fileHandleForWriting closeFile];
    if (outputString) {
        NSData *outputData = [outputPipe.fileHandleForReading readDataToEndOfFile];
        *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    }
    if (errorString) {
        NSData *errorData = [errorPipe.fileHandleForReading readDataToEndOfFile];
        *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    }
    return task.terminationStatus;
}

@end
