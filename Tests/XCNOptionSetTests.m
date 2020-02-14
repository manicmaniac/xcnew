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
    BOOL hasUnitTests = YES;
    BOOL hasUITests = YES;
    BOOL useCoreData = YES;
    XCNLanguage language = XCNLanguageObjectiveC;
    XCNUserInterface userInterface = XCNUserInterfaceSwiftUI;
    NSString *outputPath = @"/test";
    XCNOptionSet *optionSet = [[XCNOptionSet alloc] init];
    optionSet.productName = productName;
    optionSet.organizationName = organizationName;
    optionSet.organizationIdentifier = organizationIdentifier;
    optionSet.hasUnitTests = hasUnitTests;
    optionSet.hasUITests = hasUITests;
    optionSet.useCoreData = useCoreData;
    optionSet.language = language;
    optionSet.userInterface = userInterface;
    optionSet.outputPath = outputPath;
    XCNOptionSet *copied = [optionSet copy];
    XCTAssertNotEqual(optionSet, copied);
    XCTAssertEqualObjects(optionSet, copied);
}

@end
