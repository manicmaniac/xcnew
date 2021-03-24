//
//  XCNOptionParser.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNMacroDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@class XCNOptionSet;

XCN_FINAL_CLASS
@interface XCNOptionParser : NSObject

@property (class, readonly) XCNOptionParser *sharedOptionParser;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (nullable XCNOptionSet *)parseArguments:(char *const _Nullable *_Nullable)argv count:(int)argc error:(NSError *__autoreleasing _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
