//
//  XCNErrors.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSErrorDomain const XCNErrorDomain;

// clang-format off
typedef NS_ERROR_ENUM(XCNErrorDomain, XCNError) {
    XCNFileWriteUnknownError = 1,
    XCNIDEFoundationInconsistencyError = 100,
    XCNInvalidArgumentError = 110,
    XCNWrongNumberOfArgumentError = 111,
    XCNUnknownError = 125
};
// clang-format on

NS_ASSUME_NONNULL_END
