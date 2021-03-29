//
//  XCNOptionSetTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 8/11/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNOptionSet.h"

@interface XCNOptionSetTests : XCTestCase
@end

@implementation XCNOptionSetTests

- (void)testCopy {
    XCNOptionSet *optionSet = [[XCNOptionSet alloc] init];
    optionSet.productName = @"Example";
    optionSet.organizationName = @"Organization";
    optionSet.organizationIdentifier = @"com.example";
    optionSet.feature = XCNProjectFeatureCloudKit;
    optionSet.language = XCNLanguageObjectiveC;
    optionSet.userInterface = XCNUserInterfaceSwiftUI;
    optionSet.lifecycle = XCNAppLifecycleSwiftUI;
    optionSet.outputURL = [NSURL fileURLWithPath:@"/test"];
    XCNOptionSet *copied = [optionSet copy];
    XCTAssertNotEqual(optionSet, copied);
    XCTAssertEqualObjects(optionSet, copied);
    XCTAssertEqualObjects(copied.productName, optionSet.productName);
    XCTAssertEqualObjects(copied.organizationName, optionSet.organizationName);
    XCTAssertEqualObjects(copied.organizationIdentifier, optionSet.organizationIdentifier);
    XCTAssertEqual(copied.feature, optionSet.feature);
    XCTAssertEqual(copied.language, optionSet.language);
    XCTAssertEqual(copied.userInterface, optionSet.userInterface);
    XCTAssertEqual(copied.lifecycle, optionSet.lifecycle);
    XCTAssertEqualObjects(copied.outputURL, optionSet.outputURL);
}

@end
