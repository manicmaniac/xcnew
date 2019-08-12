//
//  XCNErrorsTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XCNErrorsInternal.h"

@interface XCNErrorsTests : XCTestCase
@end

@implementation XCNErrorsTests

- (void)testXCNFileWriteUnknownErrorCreateWithPath {
    NSError *error = XCNFileWriteUnknownErrorCreateWithPath(@"/path/to/file");
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(1, error.code);
    XCTAssertEqualObjects(@"Cannot write at path '/path/to/file'.", error.localizedDescription);
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNIDEFoundationInconsistencyErrorCreateWithFormat {
    NSError *error = XCNIDEFoundationInconsistencyErrorCreateWithFormat(@"%@ %@ %@", @"foo", @"bar", @"baz");
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(100, error.code);
    XCTAssertEqualObjects(@"foo bar baz", error.localizedDescription);
    XCTAssertEqualObjects(@"This error means Xcode changes interface to manipulate project files.", error.localizedFailureReason);
}

- (void)testXCNInvalidArgumentErrorCreateWithShortOption {
    NSError *error = XCNInvalidArgumentErrorCreateWithShortOption('X');
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(110, error.code);
    XCTAssertEqualObjects(@"Unrecognized option '-X'.", error.localizedDescription);
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNInvalidArgumentErrorCreateWithLongOption {
    NSError *error = XCNInvalidArgumentErrorCreateWithLongOption("--invalid");
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(110, error.code);
    XCTAssertEqualObjects(@"Unrecognized option '--invalid'.", error.localizedDescription);
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNWrongNumberOfArgumentsErrorCreateWithRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 1);
    NSError *error = XCNWrongNumberOfArgumentsErrorCreateWithRange(acceptableRangeOfArgumentsCount, 4);
    XCTAssertEqualObjects(XCNErrorDomain, error.domain);
    XCTAssertEqual(111, error.code);
    XCTAssertEqualObjects(@"Wrong number of arguments (4 for 1..2).", error.localizedDescription);
    XCTAssertNil(error.localizedFailureReason);
}

@end
