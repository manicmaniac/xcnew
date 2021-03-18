//
//  XCNLanguage.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XCNLanguage) {
    XCNLanguageSwift,
    XCNLanguageObjectiveC,
};

OBJC_EXPORT NSString *NSStringFromXCNLanguage(XCNLanguage language);

NS_ASSUME_NONNULL_END
