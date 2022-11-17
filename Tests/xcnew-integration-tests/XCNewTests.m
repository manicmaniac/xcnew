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

/**
 * A regular expression pattern to match and delete spam warnings from Xcode.
 *
 * When running Xcode 13 command line tools on Apple Silicon devices,
 * it warns about symbol collision between libamsupport and MobileDevice.framework.
 * This could be a bug in Xcode 13 as many developers reported in developer forums or other websites.
 * Although setting command line tools to /Library/Developer/CommandLineTools may fix the issue,
 * this solution does not help on CI environment because it needs command line tools set under
 * Xcode's developer directory.
 *
 * - https://developer.apple.com/forums/thread/698628
 * - https://stackoverflow.com/q/65547989
 */
static NSString *const kSymbolCollisionWarningPattern = @"^objc\\[[0-9]+\\]: Class AMSupportURL(ConnectionDelegate|Session) is implemented in both "
                                                        @"/usr/lib/libamsupport.dylib \\(0x[0-9a-f]+\\) and "
                                                        @"/Library/Apple/System/Library/PrivateFrameworks/MobileDevice\\.framework/Versions/A/MobileDevice "
                                                        @"\\(0x[0-9a-f]+\\)\\. One of the two will be used. Which one is undefined.$\\n";
static NSRegularExpression *XCNSymbolCollisionWarningRegularExpression = nil;

/**
 * A regular expression pattern to match and delete spam warnings from Xcode.
 *
 * When running Xcode 13 command line tools, it warns about missing extension points for watchOS.
 * I don't know why it occurs but sometimes even `xcodebuild` or other official tools complain the same.
 *
 * - https://developer.apple.com/forums/thread/703233
 */
static NSString *const kWatchOSExtensionPointWarningPattern = @"^.*Requested but did not find extension point with identifier "
                                                              @"Xcode\\.IDEKit\\.Extension(SentinelHostApplications|PointIdentifierToBundleIdentifier) "
                                                              @"for extension Xcode\\.DebuggerFoundation\\.AppExtension.*\\.watchOS of plug-in .*$\\n";
static NSRegularExpression *XCNWatchOSExtensionPointWarningRegularExpression = nil;

/**
 * A regular expression pattern to match and delete spam warnings from Xcode.
 *
 * When running Xcode 13 command line tools, it warns about failure to get Swift version.
 * This could be a bug in `xcnew` but currently I have no idea to fix it.
 */
static NSString *const kGetSwiftVersionWarningPattern = @"^.*DVTToolchain: Failed to get Swift version for /.*/XcodeDefault.xctoolchain: "
                                                        @"Error Domain=NSPOSIXErrorDomain Code=1 \"Operation not permitted\"$\\n";
static NSRegularExpression *XCNGetSwiftVersionWarningRegularExpression = nil;

// MARK: Public

+ (void)initialize {
    [super initialize];
    // Instantiate a regular expression as early as possible so that the syntax error can be found earlier.
    NSError *error;
    XCNSymbolCollisionWarningRegularExpression = [NSRegularExpression regularExpressionWithPattern:kSymbolCollisionWarningPattern
                                                                                           options:NSRegularExpressionAnchorsMatchLines
                                                                                             error:&error];
    if (!XCNSymbolCollisionWarningRegularExpression) {
        [NSException raise:NSInvalidArgumentException format:@"%@", error];
    }
    XCNWatchOSExtensionPointWarningRegularExpression = [NSRegularExpression regularExpressionWithPattern:kWatchOSExtensionPointWarningPattern
                                                                                                 options:NSRegularExpressionAnchorsMatchLines
                                                                                                   error:&error];
    if (!XCNWatchOSExtensionPointWarningRegularExpression) {
        [NSException raise:NSInvalidArgumentException format:@"%@", error];
    }
    XCNGetSwiftVersionWarningRegularExpression = [NSRegularExpression regularExpressionWithPattern:kGetSwiftVersionWarningPattern
                                                                                           options:NSRegularExpressionAnchorsMatchLines
                                                                                             error:&error];
    if (!XCNGetSwiftVersionWarningRegularExpression) {
        [NSException raise:NSInvalidArgumentException format:@"%@", error];
    }
}

- (BOOL)setUpWithError:(NSError *__autoreleasing _Nullable *)error {
    _fileManager = NSFileManager.defaultManager;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *executablePathFromEnvironment = NSProcessInfo.processInfo.environment[@"XCNEW_TEST_TARGET_EXECUTABLE_PATH"];
    if (executablePathFromEnvironment) {
        _executableURL = [NSURL fileURLWithPath:executablePathFromEnvironment];
    } else {
        _executableURL = [bundle URLForAuxiliaryExecutable:@"xcnew"];
    }
    _sandboxProfileURL = [bundle URLForResource:@"xcnew-integration-tests" withExtension:@"sb"];
    _temporaryDirectoryURL = [_fileManager URLForDirectory:NSItemReplacementDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:_fileManager.temporaryDirectory
                                                    create:YES
                                                     error:error];
    if (!_temporaryDirectoryURL) {
        return NO;
    }
    _currentDirectoryURL = [_temporaryDirectoryURL URLByAppendingPathComponent:@"Current"];
    return [_fileManager createDirectoryAtURL:_currentDirectoryURL
                  withIntermediateDirectories:NO
                                   attributes:nil
                                        error:error];
}

- (BOOL)tearDownWithError:(NSError *__autoreleasing _Nullable *)error {
    return [_fileManager removeItemAtURL:_temporaryDirectoryURL error:error];
}

- (void)testRunWithNoArguments {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[] output:&outputString error:&errorString], 7);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"xcnew: Wrong number of arguments (0 for 1..2).\n");
}

- (void)testRunWithInvalidShortOptionArguments {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[ @"-X" ] output:&outputString error:&errorString], 6);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"xcnew: Unrecognized option '-X'.\n");
}

- (void)testRunWithInvalidLongOptionArguments {
    NSString *outputString, *errorString;
    XCTAssertEqual([self runWithArguments:@[ @"--invalid" ] output:&outputString error:&errorString], 6);
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
    XCTAssertEqualObjects(errorString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/default");
}

- (void)testExecuteWithTests {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-t", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1300 ? @"Fixtures/tests" : @"Fixtures/tests@xcode12");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}

- (void)testExecuteWithCoreData {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-c", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/core-data");
}

- (void)testExecuteWithCloudKit {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-C", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/cloud-kit");
}

- (void)testExecuteWithObjectiveC {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-o", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/objective-c");
}

- (void)testExecuteWithSwiftUI {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-s", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, @"Fixtures/swift-ui");
}

- (void)testExecuteWithSwiftUILifecycle {
    NSString *outputString, *errorString;
    NSString *productName = @"Example";
    NSArray *arguments = @[ @"-S", productName ];
    XCTAssertEqual([self runWithArguments:arguments output:&outputString error:&errorString], 0);
    XCTAssertEqualObjects(outputString, @"");
    XCTAssertEqualObjects(errorString, @"");
    NSString *specificationName = (XCODE_VERSION_MAJOR >= 0x1300 ? @"Fixtures/swift-ui-lifecycle" : @"Fixtures/swift-ui-lifecycle@xcode12");
    XCNAssertFileHierarchyEqualsToSpecificationName(_currentDirectoryURL, specificationName);
}

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
        if (!(*errorString = [self readStringSuppressingLogNoiseFromFileHandle:errorPipe.fileHandleForReading error:&error])) {
            self.continueAfterFailure = NO;
            XCTFail(@"%@", error);
            return -1;
        }
    }
    return task.terminationStatus;
}

- (NSString *)readStringSuppressingLogNoiseFromFileHandle:(NSFileHandle *)fileHandle error:(NSError **)error {
    NSData *data = [fileHandle readDataToEndOfFileAndReturnError:error];
    if (!data) {
        return nil;
    }
    NSMutableString *string = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [XCNSymbolCollisionWarningRegularExpression replaceMatchesInString:string
                                                               options:(NSMatchingOptions)0
                                                                 range:NSMakeRange(0, string.length)
                                                          withTemplate:@""];
    [XCNWatchOSExtensionPointWarningRegularExpression replaceMatchesInString:string
                                                                     options:(NSMatchingOptions)0
                                                                       range:NSMakeRange(0, string.length)
                                                                withTemplate:@""];
    [XCNGetSwiftVersionWarningRegularExpression replaceMatchesInString:string
                                                               options:(NSMatchingOptions)0
                                                                 range:NSMakeRange(0, string.length)
                                                          withTemplate:@""];
    return string;
}

@end
