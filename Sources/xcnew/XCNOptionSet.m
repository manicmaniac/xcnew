//
//  XCNOptionSet.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/11/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNOptionSet.h"

@implementation XCNOptionSet

// MARK: Public

static_assert(XCNAppLifecycleCocoa == 0, "The default value of -[XCNOptionSet lifecycle] is XCNAppLifecycleCocoa.");
static_assert(XCNLanguageSwift == 0, "The default value of -[XCNOptionSet language] is XCNLanguageSwift.");
static_assert(XCNUserInterfaceStoryboard == 0, "The default value of -[XCNOptionSet userInterface] is XCNLanguageStoryboard.");

- (BOOL)isEqualToOptionSet:(XCNOptionSet *)optionSet {
    return ([_productName isEqualToString:optionSet.productName] &&
            [_organizationName isEqualToString:optionSet.organizationName] &&
            [_organizationIdentifier isEqualToString:optionSet.organizationIdentifier] &&
            (_feature == optionSet.feature) &&
            (_language == optionSet.language) &&
            (_userInterface == optionSet.userInterface) &&
            [_outputURL isEqual:optionSet.outputURL]);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[XCNOptionSet self]]) {
        return NO;
    }
    return [self isEqualToOptionSet:object];
}

- (NSUInteger)hash {
    return (_productName.hash ^
            _organizationName.hash ^
            _organizationIdentifier.hash ^
            _feature ^
            _language ^
            _userInterface ^
            _outputURL.hash);
}

// MARK: NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XCNOptionSet *copied = [[XCNOptionSet allocWithZone:zone] init];
    copied.productName = _productName;
    copied.organizationName = _organizationName;
    copied.organizationIdentifier = _organizationIdentifier;
    copied.feature = _feature;
    copied.language = _language;
    copied.userInterface = _userInterface;
    copied.outputURL = _outputURL;
    return copied;
}

@end
