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

- (void)setUp {
    optind = 1;
    opterr = 1;
    optreset = 1;
}

- (void)testParseArgumentsWithShortOptionC {
    XCNOptionParser *parser = [XCNOptionParser sharedOptionParser];
    char *argv[] = { "xcnew", "-C", "Example", NULL };
    int argc = 3;
    NSError *error;
    XCNOptionSet *optionSet = [parser parseArguments:argv count:argc error:&error];
    XCTAssertNotNil(optionSet);
    XCTAssertEqual(optionSet.feature & XCNProjectFeatureCloudKit, XCNProjectFeatureCloudKit);
}

- (void)testParseArgumentsWithShortOptionS {
    XCNOptionParser *parser = [XCNOptionParser sharedOptionParser];
    char *argv[] = { "xcnew", "-S", "Example", NULL };
    int argc = 3;
    NSError *error;
    XCNOptionSet *optionSet = [parser parseArguments:argv count:argc error:&error];
    XCTAssertNotNil(optionSet);
    XCTAssertEqual(optionSet.lifecycle, XCNAppLifecycleSwiftUI);
}

@end
