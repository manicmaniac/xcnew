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

static NSArray<NSInvocation *> *_testInvocations;

// MARK: Public

+ (void)initialize {
    [super initialize];
    if (self == [XCNOptionParserParameterizedTests class]) {
        _testInvocations = @[
            // Normal states
            [self invocationWithArguments:@[ @"xcnew", @"-h" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS 'Usage' AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--help" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS 'Usage' AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-v" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS $version AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--version" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS $version AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-n", @"Organization", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationName = 'Organization'"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--organization-name", @"Organization", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationName = 'Organization'"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-i", @"com.github.manicmaniac", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationIdentifier = 'com.github.manicmaniac'"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--organization-identifier", @"com.github.manicmaniac", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationIdentifier = 'com.github.manicmaniac'"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-t", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND (optionSet.feature & %lu) = %lu",
                                           XCNProjectFeatureUnitTests, XCNProjectFeatureUnitTests]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--has-tests", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND (optionSet.feature & %lu) = %lu",
                                           (XCNProjectFeatureUnitTests | XCNProjectFeatureUITests), (XCNProjectFeatureUnitTests | XCNProjectFeatureUITests)]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-c", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND (optionSet.feature & %lu) = %lu",
                                           XCNProjectFeatureCoreData, XCNProjectFeatureCoreData]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--use-core-data", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND (optionSet.feature & %lu) = %lu",
                                           XCNProjectFeatureCoreData, XCNProjectFeatureCoreData]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-C", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND (optionSet.feature & %lu) = %lu",
                                           XCNProjectFeatureCloudKit, XCNProjectFeatureCloudKit]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--use-cloud-kit", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND (optionSet.feature & %lu) = %lu",
                                           XCNProjectFeatureCloudKit, XCNProjectFeatureCloudKit]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-o", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.language = %lu",
                                           XCNLanguageObjectiveC]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--objc", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.language = %lu",
                                           XCNLanguageObjectiveC]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-s", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.userInterface = %lu",
                                           XCNUserInterfaceSwiftUI]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--swift-ui", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.userInterface = %lu",
                                           XCNUserInterfaceSwiftUI]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-S", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.lifecycle = %lu",
                                           XCNAppLifecycleSwiftUI]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--swift-ui-lifecycle", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.lifecycle = %lu",
                                           XCNAppLifecycleSwiftUI]
                                     file:@__FILE__
                                     line:__LINE__],
            // Abnormal states
            [self invocationWithArguments:@[ @"xcnew" ]
                                predicate:[NSPredicate predicateWithFormat:@"error.domain == %@ AND output = '' AND error.code == %lu AND optionSet == NULL",
                                           XCNErrorDomain, XCNWrongNumberOfArgumentError]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-X" ]
                                predicate:[NSPredicate predicateWithFormat:@"error.domain == %@ AND output = '' AND error.code == %lu AND optionSet == NULL",
                                           XCNErrorDomain, XCNInvalidArgumentError]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--invalid" ]
                                predicate:[NSPredicate predicateWithFormat:@"error.domain == %@ AND output = '' AND error.code == %lu AND optionSet == NULL",
                                           XCNErrorDomain, XCNInvalidArgumentError]
                                     file:@__FILE__
                                     line:__LINE__],
            // Reverse-ordered options
            [self invocationWithArguments:@[ @"xcnew", @"Example", @"-n", @"Organization" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationName = 'Organization'"]
                                     file:@__FILE__
                                     line:__LINE__],
            // Long options joined by a equal sign
            [self invocationWithArguments:@[ @"xcnew", @"--organization-name=Organization", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationName = 'Organization'"]
                                     file:@__FILE__
                                     line:__LINE__],
            // GNU-style option terminator
            [self invocationWithArguments:@[ @"xcnew", @"-n", @"Organization", @"--", @"Example" ]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output = '' AND optionSet.organizationName = 'Organization'"]
                                     file:@__FILE__
                                     line:__LINE__],
            // Stop parsing when either of -h, --help, -v and --version found
            [self invocationWithArguments:@[ @"xcnew", @"-h", @"-v"]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS 'Usage' AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--help", @"--version"]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS 'Usage' AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"-v", @"-h"]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS $version AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
            [self invocationWithArguments:@[ @"xcnew", @"--version", @"--help"]
                                predicate:[NSPredicate predicateWithFormat:@"error = NULL AND output CONTAINS $version AND optionSet = NULL"]
                                     file:@__FILE__
                                     line:__LINE__],
        ];
    }
}

+ (NSArray<NSInvocation *> *)testInvocations {
    return _testInvocations;
}

+ (instancetype)testCaseWithSelector:(SEL)selector {
    NSString *selectorName = NSStringFromSelector(selector);
    for (NSInvocation *invocation in _testInvocations) {
        if ([selectorName isEqualToString:NSStringFromSelector(invocation.selector)]) {
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

- (void)parameterizedTestParseArguments:(NSArray<NSString *> *)arguments predicate:(NSPredicate *)predicate file:(NSString *)file line:(NSUInteger)line {
    XCNOptionParser *parser = XCNOptionParser.sharedOptionParser;
    int argc = (int)arguments.count;
    char **argv = calloc(argc + 1, sizeof(char *));
    for (int i = 0; i < argc; i++) {
        argv[i] = strdup(arguments[i].UTF8String);
    }
    NSError *error;
    XCNOptionSet *optionSet = [parser parseArguments:argv count:argc error:&error];
    for (int i = 0; i < argc; i++) {
        free(argv[i]);
    }
    free(argv);
    close(STDOUT_FILENO);
    NSData *outputData = _outputPipe.fileHandleForReading.availableData;
    NSString *output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = @{@"optionSet" : (optionSet ? optionSet : [NSNull null]),
                                 @"error" : (error ? error : [NSNull null]),
                                 @"output" : (output ? output : [NSNull null])
    };
    NSDictionary *variables = @{@"version" : [NSBundle.mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey]};
    if (![predicate evaluateWithObject:dictionary substitutionVariables:variables]) {
        NSString *description = [NSString stringWithFormat:@"(%@) doesn't match %@ (with variables %@)", predicate.predicateFormat, dictionary, variables];
#if XCODE_VERSION_MAJOR >= 0x1200
        XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:file lineNumber:line];
        XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:location];
        XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeAssertionFailure
                                      compactDescription:description
                                     detailedDescription:nil
                                       sourceCodeContext:context
                                         associatedError:nil
                                             attachments:@[]];
        [self recordIssue:issue];
#else
        [self recordFailureWithDescription:description inFile:file atLine:line expected:YES];
#endif
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([NSStringFromSelector(anInvocation.selector) hasPrefix:@"test"]) {
        anInvocation.selector = @selector(parameterizedTestParseArguments:predicate:file:line:);
        return [anInvocation invoke];
    }
    [super forwardInvocation:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) hasPrefix:@"test"]) {
        aSelector = @selector(parameterizedTestParseArguments:predicate:file:line:);
    }
    return [super methodSignatureForSelector:aSelector];
}

// MARK: Private

+ (NSInvocation *)invocationWithArguments:(NSArray<NSString *> *)arguments predicate:(NSPredicate *)predicate file:(NSString *)file line:(NSUInteger)line {
    SEL selector = @selector(parameterizedTestParseArguments:predicate:file:line:);
    NSMethodSignature *methodSignature = [self instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.selector = [self selectorForArguments:arguments];
    [invocation retainArguments];
    [invocation setArgument:&arguments atIndex:2];
    [invocation setArgument:&predicate atIndex:3];
    [invocation setArgument:&file atIndex:4];
    [invocation setArgument:&line atIndex:5];
    return invocation;
}

+ (SEL)selectorForArguments:(NSArray<NSString *> *)arguments {
    NSString *selectorName = [NSString stringWithFormat:@"testParseArguments (%@)", [arguments componentsJoinedByString:@" "]];
    return NSSelectorFromString(selectorName);
}

@end

#endif // XCODE_VERSION_MAJOR >= 0x1200
