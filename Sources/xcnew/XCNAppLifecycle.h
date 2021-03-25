//
//  XCNAppLifecycle.h
//  xcnew
//
//  Created by Ryosuke Ito on 3/25/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XCNAppLifecycle) {
    XCNAppLifecycleCocoa,
    XCNAppLifecycleSwiftUI,
};

OBJC_EXPORT NSString *NSStringFromXCNAppLifecycle(XCNAppLifecycle lifecycle);

NS_ASSUME_NONNULL_END
