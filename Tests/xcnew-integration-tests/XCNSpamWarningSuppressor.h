//
//  XCNSpamWarningSuppressor.h
//  xcnew
//
//  Created by Ryosuke Ito on 11/18/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCNSpamWarningSuppressor : NSObject

- (instancetype)initWithFileHandle:(NSFileHandle *)fileHandle;
- (nullable NSString *)readStringToEndOfFileAndReturnError:(NSError *__autoreleasing _Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
