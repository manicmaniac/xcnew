//
//  NSError+XCNErrorDomain.m
//  xcnew
//
//  Created by Ryosuke Ito on 11/26/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import "NSError+XCNErrorDomain.h"

@implementation NSError (XCNErrorDomain)

// MARK: Public

NSErrorDomain const XCNErrorDomain = @"XCNErrorDomain";

+ (NSError *)xcn_errorFileWriteUnknownWithURL:(NSURL *)url {
    NSParameterAssert(url != nil);
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorFileWriteUnknown
                           userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write at path '%@'.", url.path],
                                      NSFilePathErrorKey : url.path}];
}

+ (NSError *)xcn_errorTemplateKindNotFoundWithIdentifier:(NSString *)templateKindIdentifier {
    NSParameterAssert(templateKindIdentifier != nil);
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorTemplateKindNotFound
                           userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template kind with identifier '%@' not found.", templateKindIdentifier],
                                      NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason}];
}

+ (NSError *)xcn_errorTemplateNotFoundWithKindIdentifier:(NSString *)templateKindIdentifier {
    NSParameterAssert(templateKindIdentifier != nil);
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorTemplateNotFound
                           userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template for kind '%@' not found.", templateKindIdentifier],
                                      NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason}];
}

+ (NSError *)xcn_errorTemplateFactoryNotFoundWithKindIdentifier:(NSString *)templateKindIdentifier {
    NSParameterAssert(templateKindIdentifier != nil);
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorTemplateFactoryNotFound
                           userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template factory associated with kind '%@' not found.", templateKindIdentifier],
                                      NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason}];
}

+ (NSError *)xcn_errorTemplateFactoryTimeoutWithTimeout:(NSTimeInterval)timeout {
    NSParameterAssert(timeout > 0);
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorTemplateFactoryTimeout
                           userInfo:@{NSLocalizedDescriptionKey : @"Operation timed out.",
                                      NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"IDETemplateFactory hasn't finished in %.f seconds.", timeout]}];
}

+ (NSError *)xcn_errorInvalidOptionWithCString:(const char *)longOption missingArgument:(BOOL)missingArgument {
    NSParameterAssert(longOption != NULL);
    NSData *optionData = [NSData dataWithBytes:longOption length:strlen(longOption)];
    NSString *optionString;
    [NSString stringEncodingForData:optionData
                    encodingOptions:@{NSStringEncodingDetectionSuggestedEncodingsKey : @[ @(NSUTF8StringEncoding) ],
                                      NSStringEncodingDetectionUseOnlySuggestedEncodingsKey : @YES}
                    convertedString:&optionString
                usedLossyConversion:nil];
    NSString *format = missingArgument ? @"Missing argument for option '%@'." : @"Unrecognized option '%@'.";
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorInvalidOption
                           userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:format, optionString]}];
}

+ (NSError *)xcn_errorWrongNumberOfArgumentsWithRange:(NSRange)acceptableRange actual:(int)actual {
    NSParameterAssert(acceptableRange.location != NSNotFound);
    NSParameterAssert(actual >= 0);
    NSString *expected;
    if (acceptableRange.length == 0) {
        expected = [NSString stringWithFormat:@"%lu", acceptableRange.location];
    } else {
        expected = [NSString stringWithFormat:@"%lu..%lu", acceptableRange.location, NSMaxRange(acceptableRange)];
    }
    return [NSError errorWithDomain:XCNErrorDomain
                               code:XCNErrorWrongNumberOfArgument
                           userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Wrong number of arguments (%d for %@).", actual, expected]}];
}

// MARK: Private

static NSString *const kXcodeChangesInterfaceFailureReason = @"This error means Xcode changes interface to manipulate project files.";

@end
