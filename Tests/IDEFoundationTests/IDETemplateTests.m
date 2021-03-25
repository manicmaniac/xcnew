//
//  IDETemplateTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <DVTFoundation/DVTPlatform.h>
#import <IDEFoundation/IDEInitialization.h>
#import <IDEFoundation/IDETemplate.h>
#import <IDEFoundation/IDETemplateKind.h>
#import <XCTest/XCTest.h>
#import "CDStructures.h" // To satisfy <IDEFoundation/IDETemplate.h>
#import "XCNIDEFoundationTestHelpers.h"
#import "XCNMacroDefinitions.h"

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
    NSString *singleViewAppTemplateName = (XCODE_VERSION_MAJOR >= 0x1200) ? @"App" : @"Single View App";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(SELF, $x, $x.hiddenFromChooser = NO AND $x.templateName = %@ AND ANY $x.templatePlatforms.identifier = 'com.apple.platform.iphoneos').@count == 1", singleViewAppTemplateName];
    XCTAssertTrue([predicate evaluateWithObject:availableTemplates], @"'%@' is not true", predicate);
}

@end
