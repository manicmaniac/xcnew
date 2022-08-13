//
//  XCNDyldSearchPathInjector.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/13/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef int (*XCNExecvFunctionPointer)(const char *, char *_Nonnull const *_Nonnull);

@interface XCNDyldSearchPathInjector : NSObject

- (instancetype)initWithExecv:(XCNExecvFunctionPointer)execv NS_DESIGNATED_INITIALIZER;
- (BOOL)restartProgramWithArgv:(char *_Nonnull const *_Nonnull)argv withUpdatingSearchPathOrReturnError:(NSError *__autoreleasing _Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
