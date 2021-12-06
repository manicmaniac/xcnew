//
//  DVTPlatformTests.m
//  DVTFoundationTests
//
//  Created by Ryosuke Ito on 12/7/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <DVTFoundation/DVTFoundation.h>
#import <XCTest/XCTest.h>

@interface DVTPlatformTests : XCTestCase
@end

@implementation DVTPlatformTests

- (void)setUp {
    NSError *error;
    if (![DVTPlatform loadAllPlatformsReturningError:&error]) {
        self.continueAfterFailure = NO;
        XCTFail(@"%@", error);
    }
}

- (void)testAllPlatforms {
    XCTAssertGreaterThan([[DVTPlatform allPlatforms] count], 0);
}

- (void)testPlatformForIdentifier {
    DVTPlatform *platform = [DVTPlatform platformForIdentifier:@"com.apple.platform.iphoneos"];
    XCTAssertNotNil(platform);
}

@end
