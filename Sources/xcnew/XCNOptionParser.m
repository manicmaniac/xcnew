//
//  XCNOptionParser.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNOptionParser.h"

#import <getopt.h>
#import "XCNAppLifecycle.h"
#import "XCNErrorsInternal.h"
#import "XCNLanguage.h"
#import "XCNOptionDefinitions.h"
#import "XCNOptionParseResult.h"
#import "XCNProject.h"
#import "XCNProjectFeature.h"
#import "XCNUserInterface.h"

@implementation XCNOptionParser

static XCNOptionParser *_sharedOptionParser;

// MARK: Public

+ (void)initialize {
    [super initialize];
    if (self != [XCNOptionParser class]) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ mustn't be inherited.", [XCNOptionParser class]];
    }
    _sharedOptionParser = [[self alloc] init];
}

+ (XCNOptionParser *)sharedOptionParser {
    return _sharedOptionParser;
}

- (nullable XCNOptionParseResult *)parseArguments:(char *const _Nullable *)argv count:(int)argc error:(NSError *_Nullable __autoreleasing *)error {
    NSParameterAssert(argv != NULL);
    NSParameterAssert(argc > 0);
    // Must be called on the main thread because `getopt_long(3)` is not thread-safe.
    NSAssert(NSThread.isMainThread, @"'%@' must be called on the main thread.", NSStringFromSelector(_cmd));
    opterr = 0;            // Disable auto-generated error messages.
    optind = optreset = 1; // Must be set to 1 to be reentrant.
    NSString *organizationIdentifier;
    XCNProjectFeature feature = 0;
    XCNLanguage language = 0;
    XCNUserInterface userInterface = 0;
    XCNAppLifecycle lifecycle = 0;
    int shortOption;
    while ((shortOption = getopt_long(argc, argv, XCNShortOptions, XCNLongOptions, NULL)) != -1) {
        switch (shortOption) {
            case 'h':
                puts(XCNHelp);
                return nil;
            case 'v':
                // When running xcnew, `NSBundle.mainBundle` is xcnew bundle and also `[NSBundle bundleForClass[self class]]` returns xcnew bundle.
                // Contrarily when running xcnew-tests, the former indicates Apple's xctest bundle and the latter returns xcnew-tests bundle.
                // Actually there's no way to get the correct version string in xcnew bundle while xctest is running.
                // This behavior is really confusing and might break the test.
                // So all `CFBundleShortVersionString`s in this project must be the same value
                // and the next line must use `[NSBundle bundleForClass:[self class]`.
                puts([[[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey] UTF8String]);
                return nil;
            case 'i':
                organizationIdentifier = @(optarg);
                break;
            case 't':
                feature |= (XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
                break;
            case 'c':
                feature |= XCNProjectFeatureCoreData;
                break;
            case 'C':
                feature |= XCNProjectFeatureCloudKit;
                break;
            case 'o':
                language = XCNLanguageObjectiveC;
                break;
            case 's':
                userInterface = XCNUserInterfaceSwiftUI;
                break;
            case 'S':
                lifecycle = XCNAppLifecycleSwiftUI;
                break;
            case '?':
                if (error) {
                    *error = XCNErrorInvalidOptionWithString(@(argv[optind - 1]));
                }
                return nil;
            default:
                [NSException raise:NSInvalidArgumentException format:@"Invalid argument '%c' is found.", shortOption, nil];
                break;
        }
    }
    int numberOfRestArguments = argc - optind;
    if (numberOfRestArguments != 1 && numberOfRestArguments != 2) {
        if (error) {
            NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 1);
            *error = XCNErrorWrongNumberOfArgumentsWithRange(acceptableRangeOfArgumentsCount, numberOfRestArguments);
        }
        return nil;
    }
    XCNProject *project = [[XCNProject alloc] initWithProductName:@(argv[optind])];
    project.organizationIdentifier = organizationIdentifier;
    project.feature = feature;
    project.language = language;
    project.userInterface = userInterface;
    project.lifecycle = lifecycle;
    NSURL *outputURL = [NSURL fileURLWithPath:@(argv[optind + (numberOfRestArguments - 1)])];
    return [[XCNOptionParseResult alloc] initWithProject:project outputURL:outputURL];
}

@end
