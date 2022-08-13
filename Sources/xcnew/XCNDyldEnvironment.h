//
//  XCNDyldEnvironment.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/13/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XCNSearchPath;

typedef char *_Nullable (*XCNGetenvFunctionPointer)(const char *);
typedef int (*XCNSetenvFunctionPointer)(const char *, const char *, int);

@interface XCNDyldEnvironment : NSObject

@property (nonatomic, readonly) XCNSearchPath *dyldFrameworkPath;
@property (nonatomic, readonly) XCNSearchPath *dyldVersionedFrameworkPath;

- (instancetype)initWithGetenv:(XCNGetenvFunctionPointer)getenv setenv:(XCNSetenvFunctionPointer)setenv;
- (void)save;

@end

NS_ASSUME_NONNULL_END
