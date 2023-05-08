//
//  XCNProjectInternal.h
//  xcnew
//
//  Created by Ryosuke Ito on 4/22/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import "XCNProject.h"

NS_ASSUME_NONNULL_BEGIN

@class IDETemplate, IDETemplateKind;

@interface XCNProject ()

// These methods are only visible for testing.
+ (BOOL)initializeIDEIfNeededWithError:(NSError *__autoreleasing _Nullable *_Nullable)error;
- (nullable IDETemplate *)singleViewAppProjectTemplateForKind:(IDETemplateKind *)kind;

@end

NS_ASSUME_NONNULL_END
