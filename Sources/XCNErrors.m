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

NSError *XCNIDEFoundationInconsistencyErrorMake(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *localizedDescription = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    static NSString *const localizedFailureReason = @"This error means Xcode changes interface to manipulate project files.";
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription,
                               NSLocalizedFailureReasonErrorKey : localizedFailureReason};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNIDEFoundationInconsistencyError userInfo:userInfo];
}

NSError *XCNInvalidArgumentErrorMake(char shortOption) {
    NSString *localizedDescription = [NSString stringWithFormat:@"Invalid argument '%c'", shortOption];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNInvalidArgumentError userInfo:userInfo];
}

NSError *XCNWrongNumberOfArgumentsErrorMake(int expected, int actual) {
    NSString *localizedDescription = [NSString stringWithFormat:@"Wrong number of arguments (%d for %d).", actual, expected];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : localizedDescription};
    return [NSError errorWithDomain:XCNErrorDomain code:XCNWrongNumberOfArgumentError userInfo:userInfo];
}
