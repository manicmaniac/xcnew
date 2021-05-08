//
//  IDETemplateKindTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <IDEFoundation/IDEFoundation.h>
#import <XCTest/XCTest.h>
#import "XCNIDEFoundationTestHelpers.h"

@interface IDETemplateKindTests : XCTestCase
@end

@implementation IDETemplateKindTests

- (void)setUp {
    XCNInitializeIDEOrFailTestCase(self);
}

- (void)testTemplateKindForIdentifier {
    XCTAssertNotNil([IDETemplateKind templateKindForIdentifier:XCNXcode3ProjectTemplateKindIdentifier]);
}

- (void)testTemplateKindForIdentifierWithInvalidIdentifier {
    XCTAssertNil([IDETemplateKind templateKindForIdentifier:@"xcnew.ProjectTemplateKind"]);
}

- (void)testFactory {
    IDETemplateKind *templateKind = [IDETemplateKind templateKindForIdentifier:XCNXcode3ProjectTemplateKindIdentifier];
    XCTAssertTrue([templateKind.factory isMemberOfClass:NSClassFromString(@"Xcode3ProjectTemplateFactory")]);
}

- (void)testNewTemplateInstantiationContext {
    IDETemplateKind *templateKind = [IDETemplateKind templateKindForIdentifier:XCNXcode3ProjectTemplateKindIdentifier];
    XCTAssertNotNil([templateKind newTemplateInstantiationContext]);
}

@end
