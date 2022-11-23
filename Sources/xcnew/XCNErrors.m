//
//  XCNErrors.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrorsInternal.h"

// MARK: Public

NSErrorDomain const XCNErrorDomain = @"XCNErrorDomain";

// MARK: Internal

static NSString *const kXcodeChangesInterfaceFailureReason = @"This error means Xcode changes interface to manipulate project files.";

NSError *XCNErrorFileWriteUnknownWithURL(NSURL *url) {
    NSCParameterAssert(url != nil);
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write at path '%@'.", url.path]};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorFileWriteUnknown userInfo:userInfo];
}

NSError *XCNErrorTemplateKindNotFoundWithIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template kind with identifier '%@' not found.", templateKindIdentifier],
        NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason,
    };
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateKindNotFound userInfo:userInfo];
}

NSError *XCNErrorTemplateNotFoundWithKindIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template for kind '%@' not found.", templateKindIdentifier],
        NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason,
    };
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateNotFound userInfo:userInfo];
}

NSError *XCNErrorTemplateFactoryNotFoundWithKindIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template factory associated with kind '%@' not found.", templateKindIdentifier],
        NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason,
    };
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateFactoryNotFound userInfo:userInfo];
}

NSError *XCNErrorTemplateFactoryTimeoutWithTimeout(NSTimeInterval timeout) {
    NSCParameterAssert(timeout > 0);
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey : @"Operation timed out.",
        NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"IDETemplateFactory hasn't finished in %.f seconds.", timeout],
    };
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateFactoryTimeout userInfo:userInfo];
}

NSError *XCNErrorInvalidOptionWithCString(const char *longOption, BOOL missingArgument) {
    NSCParameterAssert(longOption != NULL);
    NSData *optionData = [NSData dataWithBytes:longOption length:strlen(longOption)];
    NSString *optionString;
    [NSString stringEncodingForData:optionData
                    encodingOptions:@{NSStringEncodingDetectionSuggestedEncodingsKey : @[ @(NSUTF8StringEncoding) ],
                                      NSStringEncodingDetectionUseOnlySuggestedEncodingsKey : @YES}
                    convertedString:&optionString
                usedLossyConversion:nil];
    NSString *format = missingArgument ? @"Missing argument for option '%@'." : @"Unrecognized option '%@'.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:format, optionString]};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorInvalidOption userInfo:userInfo];
}

NSError *XCNErrorWrongNumberOfArgumentsWithRange(NSRange acceptableRange, int actual) {
    NSString *expected;
    if (acceptableRange.length == 0) {
        expected = [NSString stringWithFormat:@"%lu", acceptableRange.location];
    } else {
        expected = [NSString stringWithFormat:@"%lu..%lu", acceptableRange.location, NSMaxRange(acceptableRange)];
    }
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Wrong number of arguments (%d for %@).", actual, expected],
    };
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorWrongNumberOfArgument userInfo:userInfo];
}
