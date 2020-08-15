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
    NSString *productName = @"Example";
    NSString *organizationName = @"Organization";
    NSString *organizationIdentifier = @"com.example";
    XCNProjectFeature feature = XCNProjectFeatureUnitTests | XCNProjectFeatureUITests | XCNProjectFeatureCoreData;
    XCNLanguage language = XCNLanguageObjectiveC;
    XCNUserInterface userInterface = XCNUserInterfaceSwiftUI;
    NSURL *outputURL = [NSURL fileURLWithPath:@"/test"];
    XCNOptionSet *optionSet = [[XCNOptionSet alloc] init];
    optionSet.productName = productName;
    optionSet.organizationName = organizationName;
    optionSet.organizationIdentifier = organizationIdentifier;
    optionSet.feature = feature;
    optionSet.language = language;
    optionSet.userInterface = userInterface;
    optionSet.outputURL = outputURL;
    XCNOptionSet *copied = [optionSet copy];
    XCTAssertNotEqual(optionSet, copied);
    XCTAssertEqualObjects(optionSet, copied);
}

@end
