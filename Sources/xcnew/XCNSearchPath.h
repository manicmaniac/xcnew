//
//  XCNSearchPath.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/13/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCNSearchPath : NSObject

@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSArray<NSString *> *paths;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithPaths:(NSArray<NSString *> *)paths NS_DESIGNATED_INITIALIZER;

- (BOOL)isSubsetOfSearchPath:(XCNSearchPath *)other;
- (void)appendSearchPath:(XCNSearchPath *)other;

@end

NS_ASSUME_NONNULL_END
