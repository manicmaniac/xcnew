//
//  XCNOptionParserTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/29/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNAppLifecycle.h"
#import "XCNOptionParser.h"
#import "XCNOptionSet.h"
#import "XCNProjectFeature.h"

@interface XCNOptionParserTests : XCTestCase
@end

@implementation XCNOptionParserTests

// getopt_long(3) included in Xcode 11 or less seems not reentrant even though it exports optreset.
// To make another executable to test the parser behavior is a possible option but too much.
#if XCODE_VERSION_MAJOR >= 0x1200

- (void)testParseArgumentsWithShortOptionC {
    XCNOptionParser *parser = [XCNOptionParser sharedOptionParser];
    char *argv[] = {"xcnew", "-C", "Example", NULL};
    int argc = 3;
    NSError *error;
    XCNOptionSet *optionSet = [parser parseArguments:argv count:argc error:&error];
    XCTAssertNotNil(optionSet);
    XCTAssertEqual(optionSet.feature & XCNProjectFeatureCloudKit, XCNProjectFeatureCloudKit);
}

- (void)testParseArgumentsWithShortOptionS {
    XCNOptionParser *parser = [XCNOptionParser sharedOptionParser];
    char *argv[] = {"xcnew", "-S", "Example", NULL};
    int argc = 3;
    NSError *error;
    XCNOptionSet *optionSet = [parser parseArguments:argv count:argc error:&error];
    XCTAssertNotNil(optionSet);
    XCTAssertEqual(optionSet.lifecycle, XCNAppLifecycleSwiftUI);
}

#endif // XCODE_VERSION_MAJOR >= 0x1200

@end
