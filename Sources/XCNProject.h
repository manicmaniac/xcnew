//
//  XCNProject.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNLanguage.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCNProject : NSObject

@property (nonatomic, readonly) NSString *productName;
@property (nonatomic, copy, nullable) NSString *organizationName;
@property (nonatomic, copy, nullable) NSString *organizationIdentifier;
@property (nonatomic, assign) BOOL hasUnitTests;
@property (nonatomic, assign) BOOL hasUITests;
@property (nonatomic, assign) BOOL useCoreData;
@property (nonatomic, assign) XCNLanguage language;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProductName:(NSString *)productName NS_DESIGNATED_INITIALIZER;
- (BOOL)writeToFile:(NSString *)path error:(NSError *__autoreleasing _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
