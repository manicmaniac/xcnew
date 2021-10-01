//
//  XCNOptionParseResult.h
//  xcnew
//
//  Created by Ryosuke Ito on 10/1/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XCNProject;

@interface XCNOptionParseResult : NSObject

@property (nonatomic, readonly) XCNProject *project;
@property (nonatomic, copy, readonly) NSURL *outputURL;

- (instancetype)initWithProject:(XCNProject *)project outputURL:(NSURL *)outputURL;

@end

NS_ASSUME_NONNULL_END
