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

NSError *XCNErrorFileWriteUnknownWithPath(NSString *path) {
    NSCParameterAssert(path != nil);
    NSString *localizedDescription = [NSString stringWithFormat:@"Cannot write at path '%@'.", path];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorFileWriteUnknown userInfo:userInfo];
}

NSError *XCNErrorIDEFoundationInconsistencyWithFormat(NSString *format, ...) {
    NSCParameterAssert(format != nil);
    va_list args;
    va_start(args, format);
    NSString *localizedDescription = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    static NSString *const localizedFailureReason = @"This error means Xcode changes interface to manipulate project files.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorIDEFoundationInconsistency userInfo:userInfo];
}

NSError *XCNErrorIDEFoundationTimeoutWithFailureReason(NSString *failureReason) {
    NSCParameterAssert(failureReason != nil);
    static NSString *const localizedDescription = @"Operation timed out.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : failureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorIDEFoundationTimeout userInfo:userInfo];
}

NSError *XCNErrorInvalidArgumentWithShortOption(char shortOption) {
    NSString *localizedDescription = [NSString stringWithFormat:@"Unrecognized option '-%c'.", shortOption];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorInvalidArgument userInfo:userInfo];
}

NSError *XCNErrorInvalidArgumentWithLongOption(const char *longOption) {
    NSCParameterAssert(longOption != NULL);
    NSString *localizedDescription = [NSString stringWithFormat:@"Unrecognized option '%s'.", longOption];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNErrorInvalidArgument userInfo:userInfo];
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
