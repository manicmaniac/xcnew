//
//  XCNErrors.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrorsInternal.h"

static NSString *const kXcodeChangesInterfaceFailureReason = @"This error means Xcode changes interface to manipulate project files.";

// MARK: Public

NSErrorDomain const XCNErrorDomain = @"XCNErrorDomain";

// MARK: Internal

NSError *XCNErrorFileWriteUnknownWithURL(NSURL *url) {
    NSCParameterAssert(url != nil);
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorFileWriteUnknown userInfo:@{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Cannot write at path '%@'.", url.path],
    }];
}

NSError *XCNErrorTemplateKindNotFoundWithIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateKindNotFound userInfo:@{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template kind with identifier '%@' not found.", templateKindIdentifier],
        NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason,
    }];
}

NSError *XCNErrorTemplateNotFoundWithKindIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateNotFound userInfo:@{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template for kind '%@' not found.", templateKindIdentifier],
        NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason,
    }];
}

NSError *XCNErrorTemplateFactoryNotFoundWithKindIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateFactoryNotFound userInfo:@{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"A template factory associated with kind '%@' not found.", templateKindIdentifier],
        NSLocalizedFailureReasonErrorKey : kXcodeChangesInterfaceFailureReason,
    }];
}

NSError *XCNErrorTemplateFactoryTimeoutWithTimeout(NSTimeInterval timeout) {
    NSCParameterAssert(timeout > 0);
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateFactoryTimeout userInfo:@{
        NSLocalizedDescriptionKey : @"Operation timed out.",
        NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"IDETemplateFactory hasn't finished in %.f seconds.", timeout],
    }];
}

NSError *XCNErrorInvalidOptionWithString(NSString *longOption) {
    NSCParameterAssert(longOption != NULL);
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorInvalidOption userInfo:@{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Unrecognized option '%@'.", longOption],
    }];
}

NSError *XCNErrorWrongNumberOfArgumentsWithRange(NSRange acceptableRange, int actual) {
    NSString *expected;
    if (acceptableRange.length == 0) {
        expected = [NSString stringWithFormat:@"%lu", acceptableRange.location];
    } else {
        expected = [NSString stringWithFormat:@"%lu..%lu", acceptableRange.location, NSMaxRange(acceptableRange)];
    }
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorWrongNumberOfArgument userInfo:@{
        NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Wrong number of arguments (%d for %@).", actual, expected],
    }];
}
