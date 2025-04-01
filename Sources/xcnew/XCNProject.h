//
//  XCNProject.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNAppLifecycle.h"
#import "XCNLanguage.h"
#import "XCNProjectFeature.h"
#import "XCNUserInterface.h"

NS_ASSUME_NONNULL_BEGIN

@class XCNProjectNormalizer;

@interface XCNProject : NSObject

@property (nonatomic, readonly) NSString *productName;
@property (nonatomic, copy, nullable) NSString *organizationIdentifier;
@property (nonatomic) XCNProjectFeature feature;
@property (nonatomic) XCNLanguage language;
@property (nonatomic) XCNUserInterface userInterface;
@property (nonatomic) XCNAppLifecycle lifecycle;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProductName:(NSString *)productName NS_DESIGNATED_INITIALIZER;
- (BOOL)writeToURL:(NSURL *)url timeout:(NSTimeInterval)timeout error:(NSError *__autoreleasing _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
