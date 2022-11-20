//
//  XCNAppLifecycle.m
//  xcnew
//
//  Created by Ryosuke Ito on 3/25/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import "XCNAppLifecycle.h"

// MARK: Public

NSString *NSStringFromXCNAppLifecycle(XCNAppLifecycle lifecycle) {
    switch (lifecycle) {
        case XCNAppLifecycleCocoa:
            return @"Cocoa";
        case XCNAppLifecycleSwiftUI:
            return @"SwiftUI";
        default:
            [NSException raise:NSInvalidArgumentException format:@"XCNAppLifecycle %lu doesn't exist.", lifecycle];
    }
}
