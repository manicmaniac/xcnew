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

inline NSError *XCNIDEFoundationInconsistencyErrorCreateWithFormat(NSString *format, ...) {
    NSCParameterAssert(format != nil);
    va_list args;
    va_start(args, format);
    NSString *localizedDescription = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    static NSString *const localizedFailureReason = @"This error means Xcode changes interface to manipulate project files.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNIDEFoundationInconsistencyError userInfo:userInfo];
}

inline NSError *XCNInvalidArgumentErrorCreateWithShortOption(char shortOption) {
    NSString *localizedDescription = [NSString stringWithFormat:@"Unrecognized option '-%c'.", shortOption];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNInvalidArgumentError userInfo:userInfo];
}

inline NSError *XCNInvalidArgumentErrorCreateWithLongOption(const char *longOption) {
    NSCParameterAssert(longOption != nil);
    NSString *localizedDescription = [NSString stringWithFormat:@"Unrecognized option '%s'.", longOption];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNInvalidArgumentError userInfo:userInfo];
}

inline NSError *XCNWrongNumberOfArgumentsErrorCreateWithRange(NSRange acceptableRange, int actual) {
    NSString *expected;
    if (acceptableRange.length == 0) {
        expected = [NSString stringWithFormat:@"%lu", acceptableRange.location];
    } else {
        expected = [NSString stringWithFormat:@"%lu..%lu", acceptableRange.location, NSMaxRange(acceptableRange)];
    }
    NSString *localizedDescription = [NSString stringWithFormat:@"Wrong number of arguments (%d for %@).", actual, expected];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNWrongNumberOfArgumentError userInfo:userInfo];
}
