//
//  XCNAppLifecycleTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/25/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNAppLifecycle.h"

@interface XCNAppLifecycleTests : XCTestCase
@end

@implementation XCNAppLifecycleTests

- (void)testNSStringFromXCNAppLifecycleWithSwiftUI {
    XCTAssertEqualObjects(NSStringFromXCNAppLifecycle(XCNAppLifecycleSwiftUI), @"SwiftUI");
}

- (void)testNSStringFromXCNAppLifecycleWithCocoa {
    XCTAssertEqualObjects(NSStringFromXCNAppLifecycle(XCNAppLifecycleCocoa), @"Cocoa");
}

- (void)testNSStringFromXCNAppLifecycleWithInvalidValue {
    XCTAssertThrowsSpecificNamed(NSStringFromXCNAppLifecycle((XCNAppLifecycle)-1), NSException, NSInvalidArgumentException);
}

@end
