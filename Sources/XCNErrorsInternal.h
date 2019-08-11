//
//  XCNErrorsInternal.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrors.h"

NS_ASSUME_NONNULL_BEGIN

XCN_EXTERN NSError *XCNIDEFoundationInconsistencyErrorCreateWithFormat(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
XCN_EXTERN NSError *XCNInvalidArgumentErrorCreateWithShortOption(char shortOption);
XCN_EXTERN NSError *XCNInvalidArgumentErrorCreateWithLongOption(const char *longOption);
XCN_EXTERN NSError *XCNWrongNumberOfArgumentsErrorCreateWithRange(NSRange acceptableRange, int actual);

NS_ASSUME_NONNULL_END
