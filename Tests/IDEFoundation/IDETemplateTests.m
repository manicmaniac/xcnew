//
//  IDETemplateTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IDEFoundation/IDEInitialization.h>
#import "CDStructures.h" // To satisfy <IDEFoundation/IDETemplate.h>
#import <IDEFoundation/IDETemplate.h>
#import <IDEFoundation/IDETemplateKind.h>
#import "XCNIDEFoundationTestHelpers.h"

@interface IDETemplateTests : XCTestCase
@end

@implementation IDETemplateTests

- (void)setUp {
    XCNInitializeIDEOrFailTestCase(self);
}

- (void)testAvailableTemplateOfTemplateKind {
    IDETemplateKind *templateKind = [IDETemplateKind templateKindForIdentifier:XCNXcode3ProjectTemplateKindIdentifier];
    NSArray<IDETemplateKind *> *availableTemplates = [IDETemplate availableTemplatesOfTemplateKind:templateKind];
    XCTAssertGreaterThan(availableTemplates.count, 0);
    XCTAssertTrue([[NSPredicate predicateWithFormat:@"ANY identifier ENDSWITH 'Single View App.xctemplate'"] evaluateWithObject:availableTemplates]);
}

@end
