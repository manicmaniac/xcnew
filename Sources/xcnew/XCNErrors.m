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

NSError *XCNErrorFileWriteUnknownWithURL(NSURL *url) {
    NSCParameterAssert(url != nil);
    NSString *localizedDescription = [NSString stringWithFormat:@"Cannot write at path '%@'.", url.path];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorFileWriteUnknown userInfo:userInfo];
}

NSError *XCNErrorTemplateKindNotFoundWithIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    NSString *localizedDescription = [NSString stringWithFormat:@"A template kind with identifier '%@' not found.", templateKindIdentifier];
    static NSString *const localizedFailureReason = @"This error means Xcode changes interface to manipulate project files.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateKindNotFound userInfo:userInfo];
}

NSError *XCNErrorTemplateNotFoundWithKindIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    NSString *localizedDescription = [NSString stringWithFormat:@"A template for kind '%@' not found.", templateKindIdentifier];
    static NSString *const localizedFailureReason = @"This error means Xcode changes interface to manipulate project files.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateNotFound userInfo:userInfo];
}

NSError *XCNErrorTemplateFactoryNotFoundWithKindIdentifier(NSString *templateKindIdentifier) {
    NSCParameterAssert(templateKindIdentifier != nil);
    NSString *localizedDescription = [NSString stringWithFormat:@"A template factory associated with kind '%@' not found.", templateKindIdentifier];
    static NSString *const localizedFailureReason = @"This error means Xcode changes interface to manipulate project files.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateFactoryNotFound userInfo:userInfo];
}

NSError *XCNErrorTemplateFactoryTimeoutWithTimeout(NSTimeInterval timeout) {
    NSCParameterAssert(timeout > 0);
    static NSString *const localizedDescription = @"Operation timed out.";
    NSString *localizedFailureReason = [NSString stringWithFormat:@"IDETemplateFactory hasn't finished in %.f seconds.", timeout];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorTemplateFactoryTimeout userInfo:userInfo];
}

NSError *XCNErrorInvalidOptionWithString(NSString *longOption) {
    NSCParameterAssert(longOption != NULL);
    NSString *localizedDescription = [NSString stringWithFormat:@"Unrecognized option '%@'.", longOption];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorInvalidOption userInfo:userInfo];
}

NSError *XCNErrorWrongNumberOfArgumentsWithRange(NSRange acceptableRange, int actual) {
    NSString *expected;
    if (acceptableRange.length == 0) {
        expected = [NSString stringWithFormat:@"%lu", acceptableRange.location];
    } else {
        expected = [NSString stringWithFormat:@"%lu..%lu", acceptableRange.location, NSMaxRange(acceptableRange)];
    }
    NSString *localizedDescription = [NSString stringWithFormat:@"Wrong number of arguments (%d for %@).", actual, expected];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorWrongNumberOfArgument userInfo:userInfo];
}
