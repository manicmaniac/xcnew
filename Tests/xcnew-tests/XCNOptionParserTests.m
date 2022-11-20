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

@end
