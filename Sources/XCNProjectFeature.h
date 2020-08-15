//
//  XCNProjectFeature.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/15/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, XCNProjectFeature) {
    XCNProjectFeatureUnitTests = 1 << 0,
    XCNProjectFeatureUITests = 1 << 1,
    XCNProjectFeatureCoreData = 1 << 2,
};

NS_ASSUME_NONNULL_END
