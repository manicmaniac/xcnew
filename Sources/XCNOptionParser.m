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
#import "XCNMacroDefinitions.h"
#import "XCNOptionSet.h"

@implementation XCNOptionParser

// MARK: Public

+ (void)initialize {
    [super initialize];
    NSAssert(self == [XCNOptionParser class], @"XCNOptionParser mustn't be inherited.");
}

+ (XCNOptionParser *)sharedOptionParser {
    static XCNOptionParser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (nullable XCNOptionSet *)parseArguments:(char *const _Nullable *)argv count:(int)argc error:(NSError *_Nullable __autoreleasing *)error {
    NSParameterAssert(argv != NULL);
    NSParameterAssert(argc > 0);
    // Must be called on the main thread because `getopt_long(3)` is not thread-safe.
    NSAssert([NSThread isMainThread], @"'%@' must be called on the main thread.", NSStringFromSelector(_cmd));
    opterr = 0;
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
                optionSet.hasUnitTests = YES;
                break;
            case 'u':
                optionSet.hasUITests = YES;
                break;
            case 'c':
                optionSet.useCoreData = YES;
                break;
            case 'o':
                optionSet.language = XCNLanguageObjectiveC;
                break;
#if XCN_SWIFT_UI_IS_AVAILABLE
            case 's':
                optionSet.userInterface = XCNUserInterfaceSwiftUI;
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

static const char help[] = "xcnew - A command line tool to create Xcode project.\n"
                           "\n"
                           "Usage: xcnew [-h|-v] [-n ORG_NAME] [-i ORG_ID] [-tuco" XCN_SWIFT_UI_SHORT_OPTION_STRING "] <PRODUCT_NAME> [OUTPUT_DIR]\n"
                           "\n"
                           "Options:\n"
                           "    -h, --help                     Show this help and exit\n"
                           "    -v, --version                  Show version and exit\n"
                           "    -n, --organization-name        Specify organization's name\n"
                           "    -i, --organization-identifier  Specify organization's identifier\n"
                           "    -t, --has-unit-tests           Enable unit tests\n"
                           "    -u, --has-ui-tests             Enable UI tests\n"
                           "    -c, --use-core-data            Enable Core Data template\n"
                           "    -o, --objc                     Use Objective-C (default: Swift)\n"
#if XCN_SWIFT_UI_IS_AVAILABLE
                           "    -s, --swift-ui                 Use Swift UI (default: Storyboard)\n"
#endif
                           "\n"
                           "Arguments:\n"
                           "    <PRODUCT_NAME>                 Required TARGET_NAME of project.pbxproj\n"
                           "    [OUTPUT_DIR]                   Optional directory name of the project";

static const char shortOptions[] = "hvn:i:tuco" XCN_SWIFT_UI_SHORT_OPTION_STRING;

static const struct option longOptions[] = {
    {"help", no_argument, NULL, 'h'},
    {"version", no_argument, NULL, 'v'},
    {"organization-name", required_argument, NULL, 'n'},
    {"organization-identifier", required_argument, NULL, 'i'},
    {"has-unit-tests", no_argument, NULL, 't'},
    {"has-ui-tests", no_argument, NULL, 'u'},
    {"use-core-data", no_argument, NULL, 'c'},
    {"objc", no_argument, NULL, 'o'},
#if XCN_SWIFT_UI_IS_AVAILABLE
    {"swift-ui", no_argument, NULL, 's'},
#endif
    {NULL, 0, NULL, 0},
};

@end
