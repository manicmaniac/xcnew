//
//  XCNSpamWarningSuppressor.m
//  xcnew
//
//  Created by Ryosuke Ito on 11/18/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import "XCNSpamWarningSuppressor.h"

@implementation XCNSpamWarningSuppressor {
    NSFileHandle *_fileHandle;
}

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
    XCNIbtooldConnectionIDErrorRegularExpression = [NSRegularExpression regularExpressionWithPattern:kIbtooldConnectionIDErrorPattern
                                                                                             options:NSRegularExpressionAnchorsMatchLines
                                                                                               error:&error];
    if (!XCNIbtooldConnectionIDErrorRegularExpression) {
        [NSException raise:NSInvalidArgumentException format:@"%@", error];
    }
}

- (instancetype)initWithFileHandle:(NSFileHandle *)fileHandle {
    NSParameterAssert(fileHandle != nil);
    self = [super init];
    if (self) {
        _fileHandle = fileHandle;
    }
    return self;
}

- (NSString *)readStringToEndOfFileAndReturnError:(NSError **)error {
    NSData *data = [_fileHandle readDataToEndOfFileAndReturnError:error];
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
    [XCNIbtooldConnectionIDErrorRegularExpression replaceMatchesInString:string
                                                                 options:(NSMatchingOptions)0
                                                                   range:NSMakeRange(0, string.length)
                                                            withTemplate:@""];
    return string;
}

// MARK: Private

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

/**
 * A regular expression pattern to match and delete spam warnings from Xcode.
 *
 * This warning could be a bug in `xcnew`.
 * Although `IDEInitialize()` launches `ibtoold` internally, something is missing to have `ibtoold` set a valid connection ID.
 */
static NSString *const kIbtooldConnectionIDErrorPattern = @"^.*ibtoold.*0 is not a valid connection ID\\.$\\n";

static NSRegularExpression *XCNIbtooldConnectionIDErrorRegularExpression = nil;

@end
