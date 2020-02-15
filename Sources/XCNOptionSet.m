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

- (instancetype)init {
    self = [super init];
    if (self) {
        _language = XCNLanguageSwift;
        _userInterface = XCNUserInterfaceStoryboard;
    }
    return self;
}

- (BOOL)isEqualToOptionSet:(XCNOptionSet *)optionSet {
    return ([_productName isEqualToString:optionSet.productName] &&
            [_organizationName isEqualToString:optionSet.organizationName] &&
            [_organizationIdentifier isEqualToString:optionSet.organizationIdentifier] &&
            (_hasUnitTests == optionSet.hasUnitTests) &&
            (_hasUITests == optionSet.hasUITests) &&
            (_useCoreData == optionSet.useCoreData) &&
            (_language == optionSet.language) &&
            (_userInterface == optionSet.userInterface) &&
            [_outputPath isEqualToString:optionSet.outputPath]);
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
            _hasUnitTests ^
            _hasUITests ^
            _useCoreData ^
            _language ^
            _userInterface ^
            _outputPath.hash);
}

// MARK: NSCopying

- (id)copyWithZone:(NSZone *)zone {
    XCNOptionSet *copied = [[XCNOptionSet allocWithZone:zone] init];
    copied.productName = _productName;
    copied.organizationName = _organizationName;
    copied.organizationIdentifier = _organizationIdentifier;
    copied.hasUnitTests = _hasUnitTests;
    copied.hasUITests = _hasUITests;
    copied.useCoreData = _useCoreData;
    copied.language = _language;
    copied.userInterface = _userInterface;
    copied.outputPath = _outputPath;
    return copied;
}

@end
