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

- (void)testXCNErrorFileWriteUnknownWithURL {
    NSError *error = XCNErrorFileWriteUnknownWithURL([NSURL URLWithString:@"file:///path/to/file"]);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 1);
    XCTAssertEqualObjects(error.localizedDescription, @"Cannot write at path '/path/to/file'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorTemplateKindNotFoundWithIdentifier {
    NSError *error = XCNErrorTemplateKindNotFoundWithIdentifier(@"com.github.manicmaniac.xcnew.template");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 2);
    XCTAssertEqualObjects(error.localizedDescription, @"A template kind with identifier 'com.github.manicmaniac.xcnew.template' not found.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorTemplateNotFoundWithKindIdentifier {
    NSError *error = XCNErrorTemplateNotFoundWithKindIdentifier(@"com.github.manicmaniac.xcnew.template");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 3);
    XCTAssertEqualObjects(error.localizedDescription, @"A template for kind 'com.github.manicmaniac.xcnew.template' not found.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorTemplateFactoryTimeoutWithTimeout {
    NSError *error = XCNErrorTemplateFactoryTimeoutWithTimeout(42);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 4);
    XCTAssertEqualObjects(error.localizedDescription, @"Operation timed out.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"IDETemplateFactory hasn't finished in 42 seconds.");
}

- (void)testXCNErrorTemplateFactoryNotFoundWithKindIdentifier {
    NSError *error = XCNErrorTemplateFactoryNotFoundWithKindIdentifier(@"com.github.manicmaniac.xcnew.template");
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 5);
    XCTAssertEqualObjects(error.localizedDescription, @"A template factory associated with kind 'com.github.manicmaniac.xcnew.template' not found.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorInvalidOptionWithCStringWithMissingArgument {
    NSError *error = XCNErrorInvalidOptionWithCString("-i", YES);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Missing argument for option '-i'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithShortOption {
    NSError *error = XCNErrorInvalidOptionWithCString("-X", NO);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '-X'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithUnprintableShortOption {
    NSError *error = XCNErrorInvalidOptionWithCString("-\x80", NO);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '-\uFFFD'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithLongOption {
    NSError *error = XCNErrorInvalidOptionWithCString("--invalid", NO);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '--invalid'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithUTF8LongOption {
    NSError *error = XCNErrorInvalidOptionWithCString("--日本語", NO);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '--日本語'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorWrongNumberOfArgumentsWithRangeWithShortRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 0);
    NSError *error = XCNErrorWrongNumberOfArgumentsWithRange(acceptableRangeOfArgumentsCount, 4);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 7);
    XCTAssertEqualObjects(error.localizedDescription, @"Wrong number of arguments (4 for 1).");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorWrongNumberOfArgumentsWithRangeWithLongRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 1);
    NSError *error = XCNErrorWrongNumberOfArgumentsWithRange(acceptableRangeOfArgumentsCount, 4);
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 7);
    XCTAssertEqualObjects(error.localizedDescription, @"Wrong number of arguments (4 for 1..2).");
    XCTAssertNil(error.localizedFailureReason);
}

@end
