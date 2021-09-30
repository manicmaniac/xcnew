//
//  XCNOptionParserParameterizedTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/29/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

// getopt_long(3) included in Xcode 11 or less seems not reentrant even though it exports optreset.
// To make another executable to test the parser behavior is a possible option but too much.
#if XCODE_VERSION_MAJOR >= 0x1200

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "XCNAppLifecycle.h"
#import "XCNErrors.h"
#import "XCNOptionParser.h"
#import "XCNOptionSet.h"
#import "XCNProjectFeature.h"

@interface XCNOptionParserParameterizedTests : XCTestCase
@end

@implementation XCNOptionParserParameterizedTests {
    NSPipe *_outputPipe;
    int _originalStandardOutputFileDescriptor;
}

typedef void (^XCNOptionParserExpectation)(XCNOptionSet *, NSString *, NSError *);

static NSArray<NSInvocation *> *_testInvocations;

// MARK: Public

+ (void)initialize {
    [super initialize];
    if (self == [XCNOptionParserParameterizedTests class]) {
        NSString *version = [[NSBundle bundleForClass:self] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey];
        _testInvocations = [super.testInvocations arrayByAddingObjectsFromArray:@[
            // Normal states
            [self invocationWithArguments:@[ @"xcnew", @"-h" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--help" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-v" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--version" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-n", @"Organization", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationName, @"Organization");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--organization-name", @"Organization", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationName, @"Organization");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-i", @"com.github.manicmaniac", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--organization-identifier", @"com.github.manicmaniac", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationIdentifier, @"com.github.manicmaniac");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-t", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.feature, XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--has-tests", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.feature, XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-c", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.feature, XCNProjectFeatureCoreData);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--use-core-data", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.feature, XCNProjectFeatureCoreData);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-C", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.feature, XCNProjectFeatureCloudKit);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--use-cloud-kit", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.feature, XCNProjectFeatureCloudKit);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-o", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.language, XCNLanguageObjectiveC);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--objc", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.language, XCNLanguageObjectiveC);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-s", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.userInterface, XCNUserInterfaceSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--swift-ui", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.userInterface, XCNUserInterfaceSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-S", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.lifecycle, XCNAppLifecycleSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--swift-ui-lifecycle", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqual(optionSet.lifecycle, XCNAppLifecycleSwiftUI);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"Example", @"Output" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.productName, @"Example");
                                  XCTAssertEqualObjects(optionSet.outputURL.lastPathComponent, @"Output");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // Abnormal states
            [self invocationWithArguments:@[ @"xcnew" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorWrongNumberOfArgument);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-X" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--invalid" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertEqualObjects(error.domain, XCNErrorDomain);
                                  XCTAssertEqual(error.code, XCNErrorInvalidOption);
                              }],
            // Reverse-ordered options
            [self invocationWithArguments:@[ @"xcnew", @"Example", @"-n", @"Organization" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationName, @"Organization");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // Long options joined by a equal sign
            [self invocationWithArguments:@[ @"xcnew", @"--organization-name=Organization", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationName, @"Organization");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // GNU-style option terminator
            [self invocationWithArguments:@[ @"xcnew", @"-n", @"Organization", @"--", @"Example" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertEqualObjects(optionSet.organizationName, @"Organization");
                                  XCTAssertEqualObjects(output, @"");
                                  XCTAssertNil(error);
                              }],
            // Stop parsing when either of -h, --help, -v and --version found
            [self invocationWithArguments:@[ @"xcnew", @"-h", @"-v" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--help", @"--version" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:@"Usage"]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"-v", @"-h" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
                                  XCTAssertTrue([output containsString:version]);
                                  XCTAssertNil(error);
                              }],
            [self invocationWithArguments:@[ @"xcnew", @"--version", @"--help" ]
                              expectation:^(XCNOptionSet *optionSet, NSString *output, NSError *error) {
                                  XCTAssertNil(optionSet);
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

- (void)testInheritance {
    Class XCNSubclassedOptionParser = objc_allocateClassPair([XCNOptionParser class], "XCNSubclassedOptionParser", 0);
    [self addTeardownBlock:^{
        objc_disposeClassPair(XCNSubclassedOptionParser);
    }];
    objc_registerClassPair(XCNSubclassedOptionParser);
    XCTAssertThrowsSpecificNamed([XCNSubclassedOptionParser self], NSException, NSInternalInconsistencyException);
}

- (void)parameterizedTestParseArguments:(NSArray<NSString *> *)arguments expectation:(XCNOptionParserExpectation)expectationBlock {
    int argc = (int)arguments.count;
    char **argv = calloc(argc + 1, sizeof(char *));
    for (int i = 0; i < argc; i++) {
        argv[i] = strdup(arguments[i].fileSystemRepresentation);
    }
    NSError *error;
    XCNOptionSet *optionSet = [XCNOptionParser.sharedOptionParser parseArguments:argv count:argc error:&error];
    for (int i = 0; i < argc; i++) {
        free(argv[i]);
    }
    free(argv);
    close(STDOUT_FILENO);
    NSData *outputData = [_outputPipe.fileHandleForReading readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    expectationBlock(optionSet, output, error);
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

#endif // XCODE_VERSION_MAJOR >= 0x1200
