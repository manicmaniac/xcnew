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
    NSString *organizationName;
    NSString *organizationIdentifier;
    XCNProjectFeature feature = 0;
    XCNLanguage language = 0;
    XCNUserInterface userInterface = 0;
    XCNAppLifecycle lifecycle = 0;
    int shortOption;
    while ((shortOption = getopt_long(argc, argv, shortOptions, longOptions, NULL)) != -1) {
        switch (shortOption) {
            case 'h':
                puts(help);
                return nil;
            case 'v':
                puts([[NSBundle.mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey] UTF8String]);
                return nil;
            case 'n':
                organizationName = @(optarg);
                break;
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
    project.organizationName = organizationName;
    project.organizationIdentifier = organizationIdentifier;
    project.feature = feature;
    project.language = language;
    project.userInterface = userInterface;
    project.lifecycle = lifecycle;
    NSURL *outputURL = [NSURL fileURLWithPath:@(argv[optind + (numberOfRestArguments - 1)])];
    return [[XCNOptionParseResult alloc] initWithProject:project outputURL:outputURL];
}

// MARK: Private

static const char help[] = "xcnew - A command line tool to create Xcode project.\n"
                           "\n"
                           "Usage: xcnew [-h|-v] [-n ORG_NAME] [-i ORG_ID] [-tcosSC"
                           "] <PRODUCT_NAME> [OUTPUT_DIR]\n"
                           "\n"
                           "Options:\n"
                           "    -h, --help                     Show help and exit\n"
                           "    -v, --version                  Show version and exit\n"
                           "    -n, --organization-name        Specify organization's name\n"
                           "    -i, --organization-identifier  Specify organization's identifier\n"
                           "    -t, --has-tests                Enable unit and UI tests\n"
                           "    -c, --use-core-data            Enable Core Data template\n"
                           "    -C, --use-cloud-kit            Enable Core Data with CloudKit template (overrides -c option)\n"
                           "    -o, --objc                     Use Objective-C instead of Swift (overridden by -s and -S options)\n"
                           "    -s, --swift-ui                 Use Swift UI instead of Storyboard\n"
                           "    -S, --swift-ui-lifecycle       Use Swift UI lifecycle (overrides -s option)\n"
                           "\n"
                           "Arguments:\n"
                           "    <PRODUCT_NAME>                 Required TARGET_NAME of project.pbxproj\n"
                           "    [OUTPUT_DIR]                   Optional directory name of the project";

static const char shortOptions[] = "hvn:i:tcosSC";

static const struct option longOptions[] = {
    {"help", no_argument, NULL, 'h'},
    {"version", no_argument, NULL, 'v'},
    {"organization-name", required_argument, NULL, 'n'},
    {"organization-identifier", required_argument, NULL, 'i'},
    {"has-tests", no_argument, NULL, 't'},
    {"use-core-data", no_argument, NULL, 'c'},
    {"use-cloud-kit", no_argument, NULL, 'C'},
    {"objc", no_argument, NULL, 'o'},
    {"swift-ui", no_argument, NULL, 's'},
    {"swift-ui-lifecycle", no_argument, NULL, 'S'},
    {NULL, 0, NULL, 0},
};

@end
