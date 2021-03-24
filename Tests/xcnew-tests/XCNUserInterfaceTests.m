//
//  XCNUserInterfaceTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 2/14/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNUserInterface.h"

@interface XCNUserInterfaceTests : XCTestCase
@end

@implementation XCNUserInterfaceTests

- (void)testNSStringFromXCNUserInterfaceWithSwiftUI {
    XCTAssertEqualObjects(NSStringFromXCNUserInterface(XCNUserInterfaceSwiftUI), @"SwiftUI");
}

- (void)testNSStringFromXCNUserInterfaceWithStoryboard {
    XCTAssertEqualObjects(NSStringFromXCNUserInterface(XCNUserInterfaceStoryboard), @"Storyboard");
}

@end
