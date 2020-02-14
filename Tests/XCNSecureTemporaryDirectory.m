//
//  XCNSecureTemporaryDirectory.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 2/15/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import "XCNSecureTemporaryDirectory.h"
#import "XCNErrorsInternal.h"

NSString *_Nullable XCNCreateSecureTemporaryDirectoryWithBasename(NSString *basename, NSError *__autoreleasing _Nullable *error) {
    NSString *templatePathString = [NSTemporaryDirectory() stringByAppendingPathComponent:basename];
    char templatePath[PATH_MAX] = {0};
    if (![templatePathString getCString:templatePath maxLength:sizeof(templatePath) encoding:NSUTF8StringEncoding]) {
        if (error) {
            *error = [NSError errorWithDomain:XCNErrorDomain code:XCNInvalidArgumentError userInfo:@{
                NSLocalizedDescriptionKey: @"Failed to generate a temporary directory name.",
                NSLocalizedFailureReasonErrorKey: @"The given basename is too long."
            }];
        }
        return nil;
    }
    if (!mkdtemp(templatePath)) {
        if (error) {
            errno_t currentErrno = errno;
            if (currentErrno) {
                *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:(NSInteger)currentErrno userInfo:@{
                    NSLocalizedDescriptionKey: [NSString stringWithUTF8String:strerror(currentErrno)]
                }];
            } else {
                *error = [NSError errorWithDomain:XCNErrorDomain code:XCNUnknownError userInfo:@{
                    NSLocalizedDescriptionKey: @"`mkdtemp` unexpectedly failed without reporting error."
                }];
            }
        }
    }
    return [NSString stringWithUTF8String:templatePath];
}
