//
//  XCNProject.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNLanguage.h"
#import "XCNUserInterface.h"
#import "XCNProjectFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCNProject : NSObject

@property (nonatomic, readonly) NSString *productName;
@property (nonatomic, copy, nullable) NSString *organizationName;
@property (nonatomic, copy, nullable) NSString *organizationIdentifier;
@property (nonatomic) XCNProjectFeature feature;
@property (nonatomic) XCNLanguage language;
@property (nonatomic) XCNUserInterface userInterface;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProductName:(NSString *)productName NS_DESIGNATED_INITIALIZER;
- (BOOL)writeToURL:(NSURL *)url error:(NSError *__autoreleasing _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
