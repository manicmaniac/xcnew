//
//  XCNDyldEnvironment.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/13/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import "XCNDyldEnvironment.h"
#import "XCNSearchPath.h"

#define DYLD_FRAMEWORK_PATH "DYLD_FRAMEWORK_PATH"
#define DYLD_VERSIONED_FRAMEWORK_PATH "DYLD_VERSIONED_FRAMEWORK_PATH"

@implementation XCNDyldEnvironment {
    XCNSetenvFunctionPointer _setenv;
}

// MARK: Public

- (instancetype)initWithGetenv:(XCNGetenvFunctionPointer)getenv setenv:(XCNSetenvFunctionPointer)setenv {
    self = [super init];
    if (self) {
        _setenv = setenv;
        char *dyldFrameworkPathCString = getenv(DYLD_FRAMEWORK_PATH);
        if (dyldFrameworkPathCString) {
            _dyldFrameworkPath = [[XCNSearchPath alloc] initWithString:@(dyldFrameworkPathCString)];
        } else {
            _dyldFrameworkPath = [[XCNSearchPath alloc] init];
        }
        char *dyldVersionedFrameworkPathCString = getenv(DYLD_VERSIONED_FRAMEWORK_PATH);
        if (dyldVersionedFrameworkPathCString) {
            _dyldVersionedFrameworkPath = [[XCNSearchPath alloc] initWithString:@(dyldVersionedFrameworkPathCString)];
        } else {
            _dyldVersionedFrameworkPath = [[XCNSearchPath alloc] init];
        }
    }
    return self;
}

- (void)save {
    _setenv(DYLD_FRAMEWORK_PATH, _dyldFrameworkPath.string.UTF8String, 1);
    _setenv(DYLD_VERSIONED_FRAMEWORK_PATH, _dyldVersionedFrameworkPath.string.UTF8String, 1);
}

@end
