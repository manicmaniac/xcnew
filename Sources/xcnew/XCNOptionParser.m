//
//  XCNOptionParser.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNOptionParser.h"

#import <getopt.h>
#import "XCNErrorsInternal.h"
#import "XCNOptionSet.h"
#import "XCNProjectFeature.h"

@implementation XCNOptionParser

static XCNOptionParser *_sharedOptionParser;

// MARK: Public

+ (void)initialize {
    [super initialize];
    if (self != [XCNOptionParser class]) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ mustn't be inherited.", [XCNOptionParser class]];
    }
    _sharedOptionParser = [[XCNOptionParser alloc] init];
}

+ (XCNOptionParser *)sharedOptionParser {
    return _sharedOptionParser;
}

- (nullable XCNOptionSet *)parseArguments:(char *const _Nullable *)argv count:(int)argc error:(NSError *_Nullable __autoreleasing *)error {
    NSParameterAssert(argv != NULL);
    NSParameterAssert(argc > 0);
    // Must be called on the main thread because `getopt_long(3)` is not thread-safe.
    NSAssert(NSThread.isMainThread, @"'%@' must be called on the main thread.", NSStringFromSelector(_cmd));
    opterr = 0;            // Disable auto-generated error messages.
    optind = optreset = 1; // Must be set to 1 to be reentrant.
    XCNOptionSet *optionSet = [[XCNOptionSet alloc] init];
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
                optionSet.organizationName = @(optarg);
                break;
            case 'i':
                optionSet.organizationIdentifier = @(optarg);
                break;
            case 't':
#if XCN_TEST_OPTION_IS_UNIFIED
                optionSet.feature |= (XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
#else
                optionSet.feature |= XCNProjectFeatureUnitTests;
                break;
            case 'u':
                optionSet.feature |= XCNProjectFeatureUITests;
                break;
#endif
            case 'c':
                optionSet.feature |= XCNProjectFeatureCoreData;
                break;
            case 'C':
                optionSet.feature |= XCNProjectFeatureCloudKit;
                break;
            case 'o':
                optionSet.language = XCNLanguageObjectiveC;
                break;
#if XCN_SWIFT_UI_IS_AVAILABLE
            case 's':
                optionSet.userInterface = XCNUserInterfaceSwiftUI;
                break;
#endif
#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE
            case 'S':
                optionSet.lifecycle = XCNAppLifecycleSwiftUI;
                break;
#endif
            case '?':
                if (error) {
                    *error = XCNInvalidArgumentErrorCreateWithLongOption(argv[optind - 1]);
                }
                return nil;
            default:
                if (error) {
                    *error = XCNInvalidArgumentErrorCreateWithShortOption(optopt);
                }
                return nil;
        }
    }
    int numberOfRestArguments = argc - optind;
    switch (numberOfRestArguments) {
        case 2:
            optionSet.productName = @(argv[optind]);
            optionSet.outputURL = [NSURL fileURLWithPath:@(argv[optind + 1])];
            break;
        case 1:
            optionSet.productName = @(argv[optind]);
            optionSet.outputURL = [NSURL fileURLWithPath:optionSet.productName];
            break;
        default:
            if (error) {
                NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 1);
                *error = XCNWrongNumberOfArgumentsErrorCreateWithRange(acceptableRangeOfArgumentsCount, numberOfRestArguments);
            }
            return nil;
    }
    return optionSet;
}

// MARK: Private

#if XCN_SWIFT_UI_IS_AVAILABLE
#define XCN_SWIFT_UI_SHORT_OPTION_STRING "s"
#else
#define XCN_SWIFT_UI_SHORT_OPTION_STRING
#endif

#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE
#define XCN_SWIFT_UI_LIFECYCLE_SHORT_OPTION_STRING "S"
#else
#define XCN_SWIFT_UI_LIFECYCLE_SHORT_OPTION_STRING
#endif

#if XCN_CLOUD_KIT_IS_AVAILABLE
#define XCN_CLOUD_KIT_SHORT_OPTION_STRING "C"
#else
#define XCN_CLOUD_KIT_SHORT_OPTION_STRING
#endif

#if XCN_TEST_OPTION_IS_UNIFIED
#define XCN_UI_TESTS_SHORT_OPTION_STRING
#else
#define XCN_UI_TESTS_SHORT_OPTION_STRING "u"
#endif

#define XCN_CONDITIONAL_SHORT_OPTION_STRING \
    XCN_UI_TESTS_SHORT_OPTION_STRING \
    XCN_SWIFT_UI_SHORT_OPTION_STRING \
    XCN_CLOUD_KIT_SHORT_OPTION_STRING \
    XCN_SWIFT_UI_LIFECYCLE_SHORT_OPTION_STRING

static const char help[] = "xcnew - A command line tool to create Xcode project.\n"
                           "\n"
                           "Usage: xcnew [-h|-v] [-n ORG_NAME] [-i ORG_ID] [-tco" XCN_CONDITIONAL_SHORT_OPTION_STRING
                           "] <PRODUCT_NAME> [OUTPUT_DIR]\n"
                           "\n"
                           "Options:\n"
                           "    -h, --help                     Show this help and exit\n"
                           "    -v, --version                  Show version and exit\n"
                           "    -n, --organization-name        Specify organization's name\n"
                           "    -i, --organization-identifier  Specify organization's identifier\n"
#if XCN_TEST_OPTION_IS_UNIFIED
                           "    -t, --has-tests                Enable unit and UI tests\n"
#else
                           "    -t, --has-unit-tests           Enable unit tests\n"
                           "    -u, --has-ui-tests             Enable UI tests\n"
#endif
                           "    -c, --use-core-data            Enable Core Data template\n"
#if XCN_CLOUD_KIT_IS_AVAILABLE
                           "    -C, --use-cloud-kit            Enable Core Data with CloudKit template (overrides -c option)\n"
#endif
                           "    -o, --objc                     Use Objective-C instead of Swift (overridden by -s and -S options)\n"
#if XCN_SWIFT_UI_IS_AVAILABLE
                           "    -s, --swift-ui                 Use Swift UI instead of Storyboard\n"
#endif
#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE
                           "    -S, --swift-ui-lifecycle       Use Swift UI lifecycle (overrides -s option)"
#endif
                           "\n"
                           "Arguments:\n"
                           "    <PRODUCT_NAME>                 Required TARGET_NAME of project.pbxproj\n"
                           "    [OUTPUT_DIR]                   Optional directory name of the project";

static const char shortOptions[] = "hvn:i:tco" XCN_CONDITIONAL_SHORT_OPTION_STRING;

static const struct option longOptions[] = {
    {"help", no_argument, NULL, 'h'},
    {"version", no_argument, NULL, 'v'},
    {"organization-name", required_argument, NULL, 'n'},
    {"organization-identifier", required_argument, NULL, 'i'},
#if XCN_TEST_OPTION_IS_UNIFIED
    {"has-tests", no_argument, NULL, 't'},
#else
    {"has-unit-tests", no_argument, NULL, 't'},
    {"has-ui-tests", no_argument, NULL, 'u'},
#endif
    {"use-core-data", no_argument, NULL, 'c'},
#if XCN_CLOUD_KIT_IS_AVAILABLE
    {"use-cloud-kit", no_argument, NULL, 'C'},
#endif
    {"objc", no_argument, NULL, 'o'},
#if XCN_SWIFT_UI_IS_AVAILABLE
    {"swift-ui", no_argument, NULL, 's'},
#endif
#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE
    {"swift-ui-lifecycle", no_argument, NULL, 'S'},
#endif
    {NULL, 0, NULL, 0},
};

@end
