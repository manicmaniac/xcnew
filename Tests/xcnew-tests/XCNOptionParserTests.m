//
//  XCNOptionParserTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 11/21/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "XCNOptionParser.h"

@interface XCNOptionParserTests : XCTestCase
@end

@implementation XCNOptionParserTests

// MARK: Public

- (void)testInheritance {
    Class XCNSubclassedOptionParser = objc_allocateClassPair([XCNOptionParser class], "XCNSubclassedOptionParser", 0);
    [self addTeardownBlock:^{
        objc_disposeClassPair(XCNSubclassedOptionParser);
    }];
    objc_registerClassPair(XCNSubclassedOptionParser);
    XCTAssertThrowsSpecificNamed([XCNSubclassedOptionParser self], NSException, NSInternalInconsistencyException);
}

- (void)testSomeInvalidShortOptionThrowsInvalidArgumentException {
    XCTExpectFailure(@"getopt() always returns '?' when the short option is invalid so there's no chance for exception to be thrown.");
    NSUInteger exceptionThrownCount = 0;
    char shortOption[3] = "-?";
    char *argv[3] = {"xcnew", shortOption, NULL};
    for (char i = CHAR_MIN; i < CHAR_MAX; i++) {
        shortOption[1] = i;
        @try {
            [XCNOptionParser.sharedOptionParser parseArguments:argv count:2 error:nil];
        }
        @catch (NSException *exception) {
            if (exception.name != NSInvalidArgumentException) {
                @throw exception;
            }
            exceptionThrownCount++;
        }
    }
    XCTAssertGreaterThan(exceptionThrownCount, 0);
}

@end
