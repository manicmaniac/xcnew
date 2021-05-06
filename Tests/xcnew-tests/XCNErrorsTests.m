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

- (void)testXCNErrorFileWriteUnknownWithPath {
    NSError *error = XCNErrorFileWriteUnknownWithPath(@"/path/to/file");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 1);
    XCTAssertEqualObjects(error.localizedDescription, @"Cannot write at path '/path/to/file'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorIDEFoundationInconsistencyWithFormat {
    NSError *error = XCNErrorIDEFoundationInconsistencyWithFormat(@"%@ %@ %@", @"foo", @"bar", @"baz");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 100);
    XCTAssertEqualObjects(error.localizedDescription, @"foo bar baz");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorIDEFoundationTimeoutWithFailureReason {
    NSError *error = XCNErrorIDEFoundationTimeoutWithFailureReason(@"foo");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 101);
    XCTAssertEqualObjects(error.localizedDescription, @"Operation timed out.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"foo");
}

- (void)testXCNErrorInvalidArgumentWithShortOption {
    NSError *error = XCNErrorInvalidArgumentWithShortOption('X');
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 110);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '-X'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidArgumentWithLongOption {
    NSError *error = XCNErrorInvalidArgumentWithLongOption("--invalid");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 110);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '--invalid'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorWrongNumberOfArgumentsWithRangeWithShortRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 0);
    NSError *error = XCNErrorWrongNumberOfArgumentsWithRange(acceptableRangeOfArgumentsCount, 4);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 111);
    XCTAssertEqualObjects(error.localizedDescription, @"Wrong number of arguments (4 for 1).");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorWrongNumberOfArgumentsWithRangeWithLongRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 1);
    NSError *error = XCNErrorWrongNumberOfArgumentsWithRange(acceptableRangeOfArgumentsCount, 4);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 111);
    XCTAssertEqualObjects(error.localizedDescription, @"Wrong number of arguments (4 for 1..2).");
    XCTAssertNil(error.localizedFailureReason);
}

@end
