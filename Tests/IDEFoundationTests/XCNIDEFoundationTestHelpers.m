//
//  XCNIDEFoundationTestHelpers.m
//  xcnew
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import "XCNIDEFoundationTestHelpers.h"

#import <XCTest/XCTest.h>

NSString *const XCNXcode3ProjectTemplateKindIdentifier = @"Xcode.Xcode3.ProjectTemplateKind";

void XCNInitializeIDEOrFailTestCase(XCTestCase *self) {
    if (!IDEInitializationCompleted(NULL)) {
        NSError *error;
        if (!IDEInitialize(1, &error)) {
            self.continueAfterFailure = NO;
            XCTFail(@"%@", error);
        }
    }
}
