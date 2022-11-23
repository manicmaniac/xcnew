//
//  XCNOptionParserParameterizedTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/29/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "XCNAppLifecycle.h"
#import "XCNErrors.h"
#import "XCNOptionParseResult.h"
#import "XCNOptionParser.h"
#import "XCNProject.h"
#import "XCNProjectFeature.h"

@interface XCNOptionParserParameterizedTests : XCTestCase
@end

@implementation XCNOptionParserParameterizedTests {
    NSPipe *_outputPipe;
    int _originalStandardOutputFileDescriptor;
}

typedef void (^XCNOptionParserExpectation)(XCNOptionParseResult *, NSString *, NSError *);

static NSArray<NSInvocation *> *_testInvocations;

// MARK: Public

+ (void)initialize {
    [super initialize];
    if (self == [XCNOptionParserParameterizedTests class]) {
        NSString *version = [[NSBundle bundleForClass:self] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
        _testInvocations = [super.testInvocations arrayByAddingObjectsFromArray:@[
            // Normal states
            [self invocationWithArguments:@[ @"xcnew", @"-h" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--help" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-v" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--version" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-i", @"com.github.manicmaniac", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(result.project.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--organization-identifier", @"com.github.manicmaniac", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(result.project.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-t", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.feature, XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--has-tests", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.feature, XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-c", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.feature, XCNProjectFeatureCoreData);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--use-core-data", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.feature, XCNProjectFeatureCoreData);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-C", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.feature, XCNProjectFeatureCloudKit);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--use-cloud-kit", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.feature, XCNProjectFeatureCloudKit);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-o", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.language, XCNLanguageObjectiveC);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--objc", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.language, XCNLanguageObjectiveC);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-s", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.userInterface, XCNUserInterfaceSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--swift-ui", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.userInterface, XCNUserInterfaceSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-S", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.lifecycle, XCNAppLifecycleSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--swift-ui-lifecycle", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqual(result.project.lifecycle, XCNAppLifecycleSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"Example", @"Output" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(result.project.productName, @"Example");
                                  XCTAssertEqualObjects(result.outputURL.lastPathComponent, @"Output");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // Abnormal states
            [self invocationWithArguments:@[ @"xcnew" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorWrongNumberOfArgument);
                                  XCTAssertTrue([error.localizedDescription containsString:@"0 for 1"]);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-X" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                                  XCTAssertTrue([error.localizedDescription containsString:@"-X"]);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--invalid", @"--help" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                                  XCTAssertTrue([error.localizedDescription containsString:@"--invalid"]);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--日本語" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                                  XCTAssertTrue([error.localizedDescription containsString:@"--日本語"]);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--objc", @"-\uFFFD" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTExpectFailure(@"getopt() cannot treat non ASCII characters in options.");
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                                  XCTAssertTrue([error.localizedDescription containsString:@"-\uFFFD"]);
                              }],
            // Missing argument
            [self invocationWithArguments:@[ @"xcnew", @"-i" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                                  XCTAssertTrue([error.localizedDescription containsString:@"Missing"]);
                                  XCTAssertTrue([error.localizedDescription containsString:@"-i"]);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--organization-identifier" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                                  XCTAssertTrue([error.localizedDescription containsString:@"Missing"]);
                                  XCTAssertTrue([error.localizedDescription containsString:@"--organization-identifier"]);
                              }],
            // Reverse-ordered options
            [self invocationWithArguments:@[ @"xcnew", @"Example", @"-i", @"com.github.manicmaniac" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(result.project.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // Long options joined by a equal sign
            [self invocationWithArguments:@[ @"xcnew", @"--organization-identifier=com.github.manicmaniac", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(result.project.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // GNU-style option terminator
            [self invocationWithArguments:@[ @"xcnew", @"-i", @"com.github.manicmaniac", @"--", @"Example" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(result.project.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // Stop parsing when either of -h, --help, -v and --version found
            [self invocationWithArguments:@[ @"xcnew", @"-h", @"-v" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--help", @"--version" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-v", @"-h" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--version", @"--help" ]
                              expectation:^(XCNOptionParseResult *result, NSString *output, NSError *error) {
                                  XCTAssertNil(result);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }]
        ]];
    }
}

+ (NSArray<NSInvocation *> *)testInvocations {
    return _testInvocations;
}

+ (instancetype)testCaseWithSelector:(SEL)selector {
    for (NSInvocation *invocation in self.testInvocations) {
        if (sel_isEqual(selector, invocation.selector)) {
            return [self testCaseWithInvocation:invocation];
        }
    }
    return [super testCaseWithSelector:selector];
}

- (void)setUp {
    _originalStandardOutputFileDescriptor = dup(STDOUT_FILENO);
    _outputPipe = [NSPipe pipe];
    dup2(_outputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO);
    [_outputPipe.fileHandleForWriting closeFile];
}

- (void)tearDown {
    [_outputPipe.fileHandleForReading closeFile];
    dup2(_originalStandardOutputFileDescriptor, STDOUT_FILENO);
    close(_originalStandardOutputFileDescriptor);
}

- (void)parameterizedTestParseArguments:(NSArray<NSString *> *)arguments expectation:(XCNOptionParserExpectation)expectationBlock {
    int argc = (int)arguments.count;
    char **argv = calloc(argc + 1, sizeof(char *));
    for (int i = 0; i < argc; i++) {
        argv[i] = strdup(arguments[i].fileSystemRepresentation);
    }
    NSError *error;
    XCNOptionParseResult *result = [XCNOptionParser.sharedOptionParser parseArguments:argv count:argc error:&error];
    for (int i = 0; i < argc; i++) {
        free(argv[i]);
    }
    free(argv);
    close(STDOUT_FILENO);
    NSData *outputData = [_outputPipe.fileHandleForReading readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    expectationBlock(result, output, error);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self selectorHasTestPrefix:anInvocation.selector]) {
        anInvocation.selector = @selector(parameterizedTestParseArguments:expectation:);
        return [anInvocation invoke];
    }
    [super forwardInvocation:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self selectorHasTestPrefix:aSelector]) {
        aSelector = @selector(parameterizedTestParseArguments:expectation:);
    }
    return [super methodSignatureForSelector:aSelector];
}

// MARK: Private

+ (NSInvocation *)invocationWithArguments:(NSArray<NSString *> *)arguments expectation:(XCNOptionParserExpectation)expectationBlock {
    NSMethodSignature *methodSignature = [self instanceMethodSignatureForSelector:@selector(parameterizedTestParseArguments:expectation:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.selector = [self selectorForArguments:arguments];
    [invocation retainArguments];
    [invocation setArgument:&arguments atIndex:2];
    [invocation setArgument:&expectationBlock atIndex:3];
    return invocation;
}

+ (SEL)selectorForArguments:(NSArray<NSString *> *)arguments {
    NSString *selectorName = [NSString stringWithFormat:@"testParseArguments (%@)", [arguments componentsJoinedByString:@" "]];
    return NSSelectorFromString(selectorName);
}

- (BOOL)selectorHasTestPrefix:(SEL)selector {
    return [NSStringFromSelector(selector) hasPrefix:@"test"];
}

@end
