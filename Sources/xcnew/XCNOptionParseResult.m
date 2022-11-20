//
//  XCNOptionParseResult.m
//  xcnew
//
//  Created by Ryosuke Ito on 10/1/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import "XCNOptionParseResult.h"

@implementation XCNOptionParseResult

// MARK: Public

- (instancetype)initWithProject:(XCNProject *)project outputURL:(NSURL *)outputURL {
    NSParameterAssert(project != nil);
    NSParameterAssert(outputURL != nil);
    NSParameterAssert(outputURL.isFileURL);
    self = [super init];
    if (self) {
        _project = project;
        _outputURL = [outputURL copy];
    }
    return self;
}

@end
