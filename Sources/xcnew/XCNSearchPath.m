//
//  XCNSearchPath.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/13/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import "XCNSearchPath.h"

@implementation XCNSearchPath {
    NSMutableArray<NSString *> *_paths;
}

// MARK: Public

- (instancetype)init {
    return [self initWithPaths:@[]];
}

- (instancetype)initWithString:(NSString *)string {
    return [self initWithPaths:[string componentsSeparatedByString:@":"]];
}

- (instancetype)initWithPaths:(NSArray<NSString *> *)paths {
    self = [super init];
    if (self) {
        _paths = [paths mutableCopy];
    }
    return self;
}

- (NSString *)string {
    return [_paths componentsJoinedByString:@":"];
}

- (BOOL)isSubsetOfSearchPath:(XCNSearchPath *)other {
    return [[NSSet setWithArray:_paths] isSubsetOfSet:[NSSet setWithArray:other.paths]];
}

- (void)appendSearchPath:(XCNSearchPath *)other {
    [_paths addObjectsFromArray:other.paths];
}

@end
