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
    XCNErrorFileWriteUnknown = 1,
    XCNErrorIDEFoundationInconsistency = 100,
    XCNErrorIDEFoundationTimeout = 101,
    XCNErrorInvalidArgument = 110,
    XCNErrorWrongNumberOfArgument = 111,
    XCNErrorUnknown = 125
};
// clang-format on

NS_ASSUME_NONNULL_END
