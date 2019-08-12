//
//  XCNErrors.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNMacroDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

XCN_EXTERN NSErrorDomain const XCNErrorDomain;

// clang-format off
typedef NS_ERROR_ENUM(XCNErrorDomain, XCNError) {
    XCNIDEFoundationInconsistencyError = 100,
    XCNInvalidArgumentError = 110,
    XCNWrongNumberOfArgumentError = 111,
    XCNUnknownError = 128
};
// clang-format on

NS_ASSUME_NONNULL_END
