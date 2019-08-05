//
//  XCNErrorsInternal.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrors.h"

NS_ASSUME_NONNULL_BEGIN

XCN_EXTERN NSError *XCNIDEFoundationInconsistencyErrorMake(NSString *format, ...);
XCN_EXTERN NSError *XCNInvalidArgumentErrorMake(char shortOption);
XCN_EXTERN NSError *XCNWrongNumberOfArgumentsErrorMake(int expected, int actual);

NS_ASSUME_NONNULL_END
