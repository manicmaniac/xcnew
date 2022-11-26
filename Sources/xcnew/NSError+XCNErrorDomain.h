//
//  NSError+XCNErrorDomain.h
//  xcnew
//
//  Created by Ryosuke Ito on 11/26/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSErrorDomain const XCNErrorDomain;

// clang-format off
typedef NS_ERROR_ENUM(XCNErrorDomain, XCNError) {
    XCNErrorFileWriteUnknown = 1,
    XCNErrorTemplateKindNotFound,
    XCNErrorTemplateNotFound,
    XCNErrorTemplateFactoryTimeout,
    XCNErrorTemplateFactoryNotFound,
    XCNErrorInvalidOption,
    XCNErrorWrongNumberOfArgument,
};
// clang-format on

@interface NSError (XCNErrorDomain)

+ (NSError *)xcn_errorFileWriteUnknownWithURL:(NSURL *)url;
+ (NSError *)xcn_errorTemplateKindNotFoundWithIdentifier:(NSString *)templateKindIdentifier;
+ (NSError *)xcn_errorTemplateNotFoundWithKindIdentifier:(NSString *)templateKindIdentifier;
+ (NSError *)xcn_errorTemplateFactoryNotFoundWithKindIdentifier:(NSString *)templateKindIdentifier;
+ (NSError *)xcn_errorTemplateFactoryTimeoutWithTimeout:(NSTimeInterval)timeout;
+ (NSError *)xcn_errorInvalidOptionWithCString:(const char *)longOption missingArgument:(BOOL)missingArgument;
+ (NSError *)xcn_errorWrongNumberOfArgumentsWithRange:(NSRange)acceptableRange actual:(int)actual;

@end

NS_ASSUME_NONNULL_END
