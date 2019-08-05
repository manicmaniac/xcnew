//
//  XCNErrorsTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

@import XCTest;

#import "XCNErrorsInternal.h"

@interface XCNErrorsTests : XCTestCase
@end

@implementation XCNErrorsTests

- (void)testXCNIDEFoundationInconsistencyErrorMake {
    NSError *error = XCNIDEFoundationInconsistencyErrorMake(@"%@ %@ %@", @"foo", @"bar", @"baz");
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(100, error.code);
    XCTAssertEqualObjects(@"foo bar baz", error.localizedDescription);
    XCTAssertEqualObjects(@"This error means Xcode changes interface to manipulate project files.", error.localizedFailureReason);
}

- (void)testXCNInvalidArgumentErrorMake {
    NSError *error = XCNInvalidArgumentErrorMake('h');
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(110, error.code);
    XCTAssertEqualObjects(@"Invalid argument 'h'", error.localizedDescription);
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNWrongNumberOfArgumentsErrorMake {
    NSError *error = XCNWrongNumberOfArgumentsErrorMake(2, 4);
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(111, error.code);
    XCTAssertEqualObjects(@"Wrong number of arguments (4 for 2).", error.localizedDescription);
    XCTAssertNil(error.localizedFailureReason);
}

@end
