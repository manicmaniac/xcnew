//
//  NSError+XCNErrorDomainTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 11/26/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSError+XCNErrorDomain.h"

@interface NSError_XCNErrorDomainTests : XCTestCase
@end

@implementation NSError_XCNErrorDomainTests

- (void)testXCNErrorFileWriteUnknownWithURL {
    NSError *error = [NSError xcn_errorFileWriteUnknownWithURL:[NSURL fileURLWithPath:@"/path/to/file"]];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 1);
    XCTAssertEqualObjects(error.localizedDescription, @"Cannot write at path '/path/to/file'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorTemplateKindNotFoundWithIdentifier {
    NSError *error = [NSError xcn_errorTemplateKindNotFoundWithIdentifier:@"com.github.manicmaniac.xcnew.template"];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 2);
    XCTAssertEqualObjects(error.localizedDescription, @"A template kind with identifier 'com.github.manicmaniac.xcnew.template' not found.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorTemplateNotFoundWithKindIdentifier {
    NSError *error = [NSError xcn_errorTemplateNotFoundWithKindIdentifier:@"com.github.manicmaniac.xcnew.template"];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 3);
    XCTAssertEqualObjects(error.localizedDescription, @"A template for kind 'com.github.manicmaniac.xcnew.template' not found.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorTemplateFactoryTimeoutWithTimeout {
    NSError *error = [NSError xcn_errorTemplateFactoryTimeoutWithTimeout:42];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 4);
    XCTAssertEqualObjects(error.localizedDescription, @"Operation timed out.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"IDETemplateFactory hasn't finished in 42 seconds.");
}

- (void)testXCNErrorTemplateFactoryNotFoundWithKindIdentifier {
    NSError *error = [NSError xcn_errorTemplateFactoryNotFoundWithKindIdentifier:@"com.github.manicmaniac.xcnew.template"];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 5);
    XCTAssertEqualObjects(error.localizedDescription, @"A template factory associated with kind 'com.github.manicmaniac.xcnew.template' not found.");
    XCTAssertEqualObjects(error.localizedFailureReason, @"This error means Xcode changes interface to manipulate project files.");
}

- (void)testXCNErrorInvalidOptionWithCStringWithMissingArgument {
    NSError *error = [NSError xcn_errorInvalidOptionWithCString:"-i" missingArgument:YES];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Missing argument for option '-i'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithShortOption {
    NSError *error = [NSError xcn_errorInvalidOptionWithCString:"-X" missingArgument:NO];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '-X'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithUnprintableShortOption {
    NSError *error = [NSError xcn_errorInvalidOptionWithCString:"-\x80" missingArgument:NO];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '-\uFFFD'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithLongOption {
    NSError *error = [NSError xcn_errorInvalidOptionWithCString:"--invalid" missingArgument:NO];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '--invalid'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorInvalidOptionWithCStringWithUTF8LongOption {
    NSError *error = [NSError xcn_errorInvalidOptionWithCString:"--日本語" missingArgument:NO];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 6);
    XCTAssertEqualObjects(error.localizedDescription, @"Unrecognized option '--日本語'.");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorWrongNumberOfArgumentsWithRangeWithShortRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 0);
    NSError *error = [NSError xcn_errorWrongNumberOfArgumentsWithRange:acceptableRangeOfArgumentsCount actual:4];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 7);
    XCTAssertEqualObjects(error.localizedDescription, @"Wrong number of arguments (4 for 1).");
    XCTAssertNil(error.localizedFailureReason);
}

- (void)testXCNErrorWrongNumberOfArgumentsWithRangeWithLongRange {
    NSRange acceptableRangeOfArgumentsCount = NSMakeRange(1, 1);
    NSError *error = [NSError xcn_errorWrongNumberOfArgumentsWithRange:acceptableRangeOfArgumentsCount actual:4];
    XCTAssertEqualObjects(error.domain, XCNErrorDomain);
    XCTAssertEqual(error.code, 7);
    XCTAssertEqualObjects(error.localizedDescription, @"Wrong number of arguments (4 for 1..2).");
    XCTAssertNil(error.localizedFailureReason);
}

@end
