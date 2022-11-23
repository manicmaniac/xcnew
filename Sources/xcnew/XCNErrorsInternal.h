//
//  XCNErrorsInternal.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNErrors.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSError *XCNErrorFileWriteUnknownWithURL(NSURL *url);
OBJC_EXPORT NSError *XCNErrorTemplateKindNotFoundWithIdentifier(NSString *templateKindIdentifier);
OBJC_EXPORT NSError *XCNErrorTemplateNotFoundWithKindIdentifier(NSString *templateKindIdentifier);
OBJC_EXPORT NSError *XCNErrorTemplateFactoryNotFoundWithKindIdentifier(NSString *templateKindIdentifier);
OBJC_EXPORT NSError *XCNErrorTemplateFactoryTimeoutWithTimeout(NSTimeInterval timeout);
OBJC_EXPORT NSError *XCNErrorInvalidShortOptionWithCharacter(char shortOption);
OBJC_EXPORT NSError *XCNErrorInvalidOptionWithCString(const char *longOption, BOOL missingArgument);
OBJC_EXPORT NSError *XCNErrorWrongNumberOfArgumentsWithRange(NSRange acceptableRange, int actual);

NS_ASSUME_NONNULL_END
