//
//  XCNProject.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNProject.h"

#import <DVTFoundation/DVTFilePath.h>
#import <IDEFoundation/IDETemplate.h>
#import <IDEFoundation/IDETemplateFactory.h>
#import <IDEFoundation/IDETemplateInstantiationContext.h>
#import <IDEFoundation/IDETemplateKind.h>
#import <IDEFoundation/IDETemplateOption.h>
#import "XCNErrorsInternal.h"

@implementation XCNProject

// MARK: Public

+ (void)initialize {
    [super initialize];
    if (self == [XCNProject self]) {
        IDEInitialize(1, NULL);
    }
}

- (instancetype)initWithProductName:(NSString *)productName {
    NSParameterAssert(productName != nil);
    self = [super init];
    if (self) {
        _productName = [productName copy];
    }
    return self;
}

- (BOOL)writeToFile:(NSString *)path error:(NSError *__autoreleasing _Nullable *)error {
    NSParameterAssert(path != nil);
    path = [self absolutePathForPath:path];
    if (![NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }
    if (![NSFileManager.defaultManager isWritableFileAtPath:path]) {
        if (error) {
            *error = XCNFileWriteUnknownErrorCreateWithPath(path);
        }
        return NO;
    }
    IDETemplateKind *kind = [IDETemplateKind templateKindForIdentifier:kXcode3ProjectTemplateKindIdentifier];
    if (!kind) {
        if (error) {
            *error = XCNIDEFoundationInconsistencyErrorCreateWithFormat(@"A template kind with identifier '%@' not found.", kXcode3ProjectTemplateKindIdentifier);
        }
        return NO;
    }
    IDETemplate *template = [self singleViewAppProjectTemplateForKind:kind];
    if (!template) {
        if (error) {
            *error = XCNIDEFoundationInconsistencyErrorCreateWithFormat(@"A template for kind '%@' not found.", kind);
        }
        return NO;
    }
    [self configureTemplateOptions:template.templateOptions];
    IDETemplateInstantiationContext *context = [kind newTemplateInstantiationContext];
    context.documentTemplate = template;
    context.documentFilePath = [DVTFilePath filePathForPathString:path];
    __block BOOL finished = NO;
    [kind.factory instantiateTemplateForContext:context
                                        options:nil
                                       whenDone:^{
                                           finished = YES;
                                       }];
    do {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, YES);
    } while (!finished);
    return YES;
}

// MARK: Private

extern void IDEInitialize(int, NSError **);

static NSString *const kXcode3ProjectTemplateKindIdentifier = @"Xcode.Xcode3.ProjectTemplateKind";

- (IDETemplate *)singleViewAppProjectTemplateForKind:(IDETemplateKind *)kind {
    for (IDETemplate *template in [IDETemplate availableTemplatesOfTemplateKind:kind]) {
        if ([template.identifier hasSuffix:@"Single View App.xctemplate"]) {
            return template;
        }
    }
    return nil;
}

- (NSString *)absolutePathForPath:(NSString *)path {
    if (!path.isAbsolutePath) {
        path = [NSFileManager.defaultManager.currentDirectoryPath stringByAppendingPathComponent:path];
    }
    return path.stringByStandardizingPath;
}

- (void)configureTemplateOptions:(NSArray<IDETemplateOption *> *)options {
    NSParameterAssert(options != nil);
    for (IDETemplateOption *option in options) {
        NSString *identifier = option.identifier;
        if ([identifier isEqualToString:@"languageChoice"]) {
            option.value = [self stringFromLanguage:_language];
        } else if ([identifier isEqualToString:@"productName"]) {
            option.value = _productName;
        } else if ([identifier isEqualToString:@"organizationName"]) {
            option.value = _organizationName;
        } else if ([identifier isEqualToString:@"bundleIdentifierPrefix"]) {
            option.value = _organizationIdentifier;
        } else if ([identifier isEqualToString:@"hasUnitTests"]) {
            option.value = [self stringFromBOOL:_hasUnitTests];
        } else if ([identifier isEqualToString:@"hasUITests"]) {
            option.value = [self stringFromBOOL:_hasUITests];
        } else if ([identifier isEqualToString:@"coreData"]) {
            option.value = [self stringFromBOOL:_useCoreData];
        } else if ([identifier isEqualToString:@"userInterface"]) {
            option.value = [self stringFromUserInterface:_userInterface];
        }
    }
}

- (NSString *)stringFromLanguage:(XCNLanguage)language {
    switch (language) {
        case XCNLanguageObjectiveC:
            return @"Objective-C";
        case XCNLanguageSwift:
            return @"Swift";
    }
}

- (NSString *)stringFromUserInterface:(XCNUserInterface)userInterface {
    switch (userInterface) {
        case XCNUserInterfaceSwiftUI:
            return @"SwiftUI";
        case XCNUserInterfaceStoryboard:
            return @"Storyboard";
    }
}

- (NSString *)stringFromBOOL:(BOOL)value {
    return value ? @"true" : @"false";
}

@end
