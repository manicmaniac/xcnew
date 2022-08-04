//
//  IDETemplateTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <DVTFoundation/DVTFoundation.h>
#import <IDEFoundation/IDEFoundation.h>
#import <XCTest/XCTest.h>
#import "XCNIDEFoundationTestHelpers.h"
#import "XCNMacroDefinitions.h"

@interface IDETemplateTests : XCTestCase
@end

@implementation IDETemplateTests

- (BOOL)setUpWithError:(NSError *__autoreleasing _Nullable *)error {
    return IDEInitializationCompleted(NULL) || IDEInitialize(1, error);
}

- (void)testAvailableTemplateOfTemplateKind {
    IDETemplateKind *templateKind = [IDETemplateKind templateKindForIdentifier:XCNXcode3ProjectTemplateKindIdentifier];
    NSArray<IDETemplateKind *> *availableTemplates = [IDETemplate availableTemplatesOfTemplateKind:templateKind];
    XCTAssertGreaterThan(availableTemplates.count, 0);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(SELF, $x, $x.hiddenFromChooser = NO AND $x.templateName = 'App' AND ANY $x.templatePlatforms.identifier = 'com.apple.platform.iphoneos').@count == 1"];
    XCTAssertTrue([predicate evaluateWithObject:availableTemplates], @"'%@' is not true", predicate);
}

@end
