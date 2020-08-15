//
//  XCNOptionSet.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/11/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNLanguage.h"
#import "XCNProjectFeature.h"
#import "XCNUserInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCNOptionSet : NSObject<NSCopying>

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy, nullable) NSString *organizationName;
@property (nonatomic, copy, nullable) NSString *organizationIdentifier;
@property (nonatomic) XCNProjectFeature feature;
@property (nonatomic) XCNLanguage language;
@property (nonatomic) XCNUserInterface userInterface;
@property (nonatomic, copy) NSURL *outputURL;

- (BOOL)isEqualToOptionSet:(XCNOptionSet *)optionSet;

@end

NS_ASSUME_NONNULL_END
