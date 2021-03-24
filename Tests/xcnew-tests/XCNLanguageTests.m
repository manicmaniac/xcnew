//
//  XCNLanguageTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 2/14/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNLanguage.h"

@interface XCNLanguageTests : XCTestCase
@end

@implementation XCNLanguageTests

- (void)testNSStringFromXCNLanguageWithSwift {
    XCTAssertEqualObjects(NSStringFromXCNLanguage(XCNLanguageSwift), @"Swift");
}

- (void)testNSStringFromXCNLanguageWithObjectiveC {
    XCTAssertEqualObjects(NSStringFromXCNLanguage(XCNLanguageObjectiveC), @"Objective-C");
}

@end
