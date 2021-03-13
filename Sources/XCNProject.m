//
//  XCNProject.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNProject.h"

#import <DVTFoundation/DVTFilePath.h>
#import <IDEFoundation/IDEInitialization.h>
#import <IDEFoundation/IDETemplate.h>
#import <IDEFoundation/IDETemplateFactory.h>
#import <IDEFoundation/IDETemplateInstantiationContext.h>
#import <IDEFoundation/IDETemplateKind.h>
#import <IDEFoundation/IDETemplateOption.h>
#import "XCNErrorsInternal.h"

@implementation XCNProject {
    NSFileManager *_fileManager;
}

// MARK: Public

- (instancetype)initWithProductName:(NSString *)productName {
    NSParameterAssert(productName != nil);
    self = [super init];
    if (self) {
        _productName = [productName copy];
        _fileManager = NSFileManager.defaultManager;
    }
    return self;
}

- (BOOL)writeToURL:(NSURL *)url error:(NSError *__autoreleasing  _Nullable *)error {
    NSParameterAssert(url != nil);
    if (![XCNProject initializeIDEIfNeededWithError:error]) {
        return NO;
    }
    if (![_fileManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }
    if (![_fileManager isWritableFileAtPath:url.path]) {
        if (error) {
            *error = XCNFileWriteUnknownErrorCreateWithPath(url.path);
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
    context.documentFilePath = [DVTFilePath filePathForFileURL:url];
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    [kind.factory instantiateTemplateForContext:context
                                        options:nil
                                       whenDone:^{
                                           // As far as I know, this block is always called from the main thread but it's not guaranteed.
                                           // Anyway `CFRunLoop` is a thread-safe object so it doesn't matter even if a subthread calls this block.
                                           CFRunLoopStop(runLoop);
                                       }];
    CFRunLoopRun();
    return YES;
}

// MARK: Private

static NSString *const kXcode3ProjectTemplateKindIdentifier = @"Xcode.Xcode3.ProjectTemplateKind";

+ (BOOL)initializeIDEIfNeededWithError:(NSError *__autoreleasing _Nullable *)error {
    @synchronized (self) {
        if (!IDEInitializationCompleted(NULL)) {
            return IDEInitialize(1, error);
        }
        return YES;
    }
}

- (IDETemplate *)singleViewAppProjectTemplateForKind:(IDETemplateKind *)kind {
    for (IDETemplate *template in [IDETemplate availableTemplatesOfTemplateKind:kind]) {
        if ([template.identifier hasSuffix:@"Single View App.xctemplate"]) {
            return template;
        }
    }
    return nil;
}

- (void)configureTemplateOptions:(NSArray<IDETemplateOption *> *)options {
    NSParameterAssert(options != nil);
    for (IDETemplateOption *option in options) {
        NSString *identifier = option.identifier;
        if ([identifier isEqualToString:@"languageChoice"]) {
            option.value = NSStringFromXCNLanguage(_language);
        } else if ([identifier isEqualToString:@"productName"]) {
            option.value = _productName;
        } else if ([identifier isEqualToString:@"organizationName"]) {
            option.value = _organizationName;
        } else if ([identifier isEqualToString:@"bundleIdentifierPrefix"]) {
            option.value = _organizationIdentifier;
        } else if ([identifier isEqualToString:@"hasUnitTests"]) {
            option.booleanValue = (_feature & XCNProjectFeatureUnitTests);
        } else if ([identifier isEqualToString:@"hasUITests"]) {
            option.booleanValue = (_feature & XCNProjectFeatureUITests);
        } else if ([identifier isEqualToString:@"coreData"]) {
            option.booleanValue = (_feature & XCNProjectFeatureCoreData);
        } else if ([identifier isEqualToString:@"coreDataCloudKit"]) {
            option.booleanValue = (_feature & XCNProjectFeatureCloudKit);
        } else if ([identifier isEqualToString:@"userInterface"]) {
            option.value = NSStringFromXCNUserInterface(_userInterface);
        }
    }
}

@end
