//
//  XCNErrorsInternal.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrors.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSError *XCNFileWriteUnknownErrorCreateWithPath(NSString *path);
OBJC_EXPORT NSError *XCNIDEFoundationInconsistencyErrorCreateWithFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
OBJC_EXPORT NSError *XCNIDEFoundationTimeoutErrorCreateWithFailureReason(NSString *failureReason);
OBJC_EXPORT NSError *XCNInvalidArgumentErrorCreateWithShortOption(char shortOption);
OBJC_EXPORT NSError *XCNInvalidArgumentErrorCreateWithLongOption(const char *longOption);
OBJC_EXPORT NSError *XCNWrongNumberOfArgumentsErrorCreateWithRange(NSRange acceptableRange, int actual);

NS_ASSUME_NONNULL_END
