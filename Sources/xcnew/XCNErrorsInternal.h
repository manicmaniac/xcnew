//
//  XCNErrorsInternal.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrors.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSError *XCNErrorFileWriteUnknownWithPath(NSString *path);
OBJC_EXPORT NSError *XCNErrorIDEFoundationInconsistencyWithFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
OBJC_EXPORT NSError *XCNErrorIDEFoundationTimeoutWithFailureReason(NSString *failureReason);
OBJC_EXPORT NSError *XCNErrorInvalidArgumentWithShortOption(char shortOption);
OBJC_EXPORT NSError *XCNErrorInvalidArgumentWithLongOption(const char *longOption);
OBJC_EXPORT NSError *XCNErrorWrongNumberOfArgumentsWithRange(NSRange acceptableRange, int actual);

NS_ASSUME_NONNULL_END
