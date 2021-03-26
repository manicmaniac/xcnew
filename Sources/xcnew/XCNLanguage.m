//
//  XCNLanguage.m
//  xcnew
//
//  Created by Ryosuke Ito on 2/14/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import "XCNLanguage.h"

NSString *NSStringFromXCNLanguage(XCNLanguage language) {
    switch (language) {
        case XCNLanguageSwift:
            return @"Swift";
        case XCNLanguageObjectiveC:
            return @"Objective-C";
        default:
            [NSException raise:NSInvalidArgumentException format:@"XCNLanguage %lu doesn't exist.", language];
    }
}
