//
//  XCNOptionParser.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNOptionParser.h"
#import "XCNErrorsInternal.h"
#import "XCNMacroDefinitions.h"

#import <getopt.h>

@implementation XCNOptionParser

// MARK: Public

+ (XCNOptionParser *)sharedOptionParser {
    static XCNOptionParser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)parseArguments:(char *const _Nullable *)argv count:(int)argc optionSet:(inout XCNOptionSet *)optionSet error:(NSError *_Nullable __autoreleasing *)error {
    // Must be called on the main thread because `getopt_long(3)` is not thread-safe.
    NSAssert([NSThread isMainThread], @"'%@' must be called on the main thread.", NSStringFromSelector(_cmd));
    [self configureDefaultOptionSet:optionSet];
    int shortOption;
    while ((shortOption = getopt_long(argc, argv, shortOptions, longOptions, NULL)) != -1) {
        switch (shortOption) {
            case 'h':
                [self showHelp];
                return NO;
            case 'v':
                [self showVersion];
                return NO;
            case 'n':
                optionSet->organizationName = @(optarg);
                break;
            case 'i':
                optionSet->organizationIdentifier = @(optarg);
                break;
            case 't':
                optionSet->hasUnitTests = YES;
                break;
            case 'u':
                optionSet->hasUITests = YES;
                break;
            case 'c':
                optionSet->useCoreData = YES;
                break;
            case 'o':
                optionSet->language = XCNLanguageObjectiveC;
                break;
            default:
                if (error) {
                    *error = XCNInvalidArgumentErrorMake(shortOption);
                }
                return NO;
        }
    }
    int numberOfRestArguments = argc - optind;
    if (numberOfRestArguments != 2) {
        if (error) {
            *error = XCNWrongNumberOfArgumentsErrorMake(2, numberOfRestArguments);
        }
        return NO;
    }
    optionSet->productName = @(argv[optind]);
    optionSet->outputPath = @(argv[optind + 1]);
    return YES;
}

// MARK: Private

- (void)configureDefaultOptionSet:(inout XCNOptionSet *)optionSet {
    optionSet->language = XCNLanguageSwift;
}

- (void)showHelp {
    puts("xcnew - A command line tool to create Xcode project.\n"
         "\n"
         "Usage: xcnew [-h] [-n ORG_NAME] [-i ORG_ID] [-tuco] <PRODUCT_NAME> <OUTPUT_DIR>\n"
         "\n"
         "Options:\n"
         "    -h, --help                     Show this help and exit\n"
         "    -v, --version                  Show version and exit\n"
         "    -n, --organization-name        Specify organization's name\n"
         "    -i, --organization-identifier  Specify organization's identifier\n"
         "    -t, --has-unit-tests           Enable unit tests\n"
         "    -u, --has-ui-tests             Enable UI tests\n"
         "    -c, --use-core-data            Enable Core Data template\n"
         "    -o, --objc                     Use Objective-C (default: Swift)");
}

- (void)showVersion {
    puts(XCN_PROGRAM_VERSION);
}

static const char shortOptions[] = "hvn:i:tuco";

static const struct option longOptions[] = {
    {"help", no_argument, NULL, 'h'},
    {"version", no_argument, NULL, 'v'},
    {"organization-name", required_argument, NULL, 'n'},
    {"organization-identifier", required_argument, NULL, 'i'},
    {"has-unit-tests", no_argument, NULL, 't'},
    {"has-ui-tests", no_argument, NULL, 'u'},
    {"use-core-data", no_argument, NULL, 'c'},
    {"objc", no_argument, NULL, 'o'},
    {NULL, 0, NULL, 0},
};

@end
