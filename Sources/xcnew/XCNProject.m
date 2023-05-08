//
//  XCNProject.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import "XCNProjectInternal.h"

#import <DVTFoundation/DVTFoundation.h>
#import <IDEFoundation/IDEFoundation.h>
#import "NSError+XCNErrorDomain.h"
#import "XCNMacroDefinitions.h"

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

- (BOOL)writeToURL:(NSURL *)url timeout:(NSTimeInterval)timeout error:(NSError *__autoreleasing _Nullable *)error {
    NSParameterAssert(url != nil);
    NSParameterAssert(url.isFileURL);
    NSParameterAssert(timeout > 0);
    if (![XCNProject initializeIDEIfNeededWithError:error]) {
        return NO;
    }
    if (![_fileManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }
    if (![_fileManager isWritableFileAtPath:url.path]) {
        if (error) {
            *error = [NSError xcn_errorFileWriteUnknownWithURL:url];
        }
        return NO;
    }
    IDETemplateKind *kind = [IDETemplateKind templateKindForIdentifier:kXcode3ProjectTemplateKindIdentifier];
    if (!kind) {
        if (error) {
            *error = [NSError xcn_errorTemplateKindNotFoundWithIdentifier:kXcode3ProjectTemplateKindIdentifier];
        }
        return NO;
    }
    IDETemplateFactory *factory = kind.factory;
    if (!factory) {
        if (error) {
            *error = [NSError xcn_errorTemplateFactoryNotFoundWithKindIdentifier:kXcode3ProjectTemplateKindIdentifier];
        }
        return NO;
    }
    IDETemplate *template = [self singleViewAppProjectTemplateForKind:kind];
    if (!template) {
        if (error) {
            *error = [NSError xcn_errorTemplateNotFoundWithKindIdentifier:kXcode3ProjectTemplateKindIdentifier];
        }
        return NO;
    }
    [self configureTemplateOptions:template.templateOptions];
    IDETemplateInstantiationContext *context = [kind newTemplateInstantiationContext];
    context.documentTemplate = template;
    context.documentFilePath = [DVTFilePath filePathForFileURL:url];
    return [self synchronouslyInstantiateTemplateWithFactory:factory
                                                     context:context
                                                     timeout:timeout
                                                       error:error];
}

- (void)setLanguage:(XCNLanguage)language {
    if (language == XCNLanguageObjectiveC) {
        _userInterface = XCNUserInterfaceStoryboard;
        _lifecycle = XCNAppLifecycleCocoa;
    }
    _language = language;
}

- (void)setUserInterface:(XCNUserInterface)userInterface {
    if (userInterface == XCNUserInterfaceSwiftUI) {
        _language = XCNLanguageSwift;
    }
    _userInterface = userInterface;
}

- (void)setLifecycle:(XCNAppLifecycle)lifecycle {
    if (lifecycle == XCNAppLifecycleSwiftUI) {
        _language = XCNLanguageSwift;
        _userInterface = XCNUserInterfaceSwiftUI;
    }
    _lifecycle = lifecycle;
}

// MARK: Private

static NSString *const kXcode3ProjectTemplateKindIdentifier = @"Xcode.Xcode3.ProjectTemplateKind";

+ (BOOL)initializeIDEIfNeededWithError:(NSError *__autoreleasing _Nullable *_Nullable)error {
    @synchronized(self) {
        return IDEInitializationCompleted(NULL) || IDEInitialize(1, error);
    }
}

- (IDETemplate *)singleViewAppProjectTemplateForKind:(IDETemplateKind *)kind {
    NSParameterAssert(kind != nil);
    DVTPlatform *iPhoneOSPlatform = [DVTPlatform platformForIdentifier:@"com.apple.platform.iphoneos"];
    for (IDETemplate *_template in [IDETemplate availableTemplatesOfTemplateKind:kind]) {
        if (!_template.hiddenFromChooser &&
            [_template.templateName isEqualToString:@"App"] &&
            [_template.templatePlatforms containsObject:iPhoneOSPlatform]) {
            return _template;
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
        } else if ([identifier isEqualToString:@"bundleIdentifierPrefix"]) {
            option.value = _organizationIdentifier;
        } else if ([identifier isEqualToString:@"hasUnitAndUITests"]) {
            option.booleanValue = ((_feature & XCNProjectFeatureUnitTests) == XCNProjectFeatureUnitTests) && ((_feature & XCNProjectFeatureUITests) == XCNProjectFeatureUITests);
        } else if ([identifier isEqualToString:@"coreData"]) {
            option.booleanValue = (_feature & XCNProjectFeatureCoreData) == XCNProjectFeatureCoreData;
        } else if ([identifier isEqualToString:@"coreDataCloudKit"]) {
            option.booleanValue = (_feature & XCNProjectFeatureCloudKit) == XCNProjectFeatureCloudKit;
        } else if ([identifier isEqualToString:@"userInterface"]) {
            option.value = NSStringFromXCNUserInterface(_userInterface);
        } else if ([identifier isEqualToString:@"appLifecycle"]) {
            option.value = NSStringFromXCNAppLifecycle(_lifecycle);
        }
    }
}

- (BOOL)synchronouslyInstantiateTemplateWithFactory:(IDETemplateFactory *)factory
                                            context:(IDETemplateInstantiationContext *)context
                                            timeout:(NSTimeInterval)timeout
                                              error:(NSError *__autoreleasing _Nullable *_Nullable)error {
    NSParameterAssert(factory != nil);
    NSParameterAssert(context != nil);
    NSParameterAssert(context.documentTemplate != nil);
    NSParameterAssert(context.documentFilePath != nil);
    NSParameterAssert(timeout > 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSError *instantiationError;
    [factory instantiateTemplateForContext:context
                                   options:nil
                                  whenDone:^(NSArray<DVTFilePath *> *paths, void *_unknown, NSError *error) {
                                      [paths makeObjectsPerformSelector:@selector(removeAssociatesWithRole:) withObject:@"PBXContainerAssociateRole"];
                                      instantiationError = error;
                                      dispatch_semaphore_signal(semaphore);
                                  }];
    if (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)))) {
        if (error) {
            *error = [NSError xcn_errorTemplateFactoryTimeoutWithTimeout:timeout];
        }
        return NO;
    }
    if (instantiationError) {
        if (error) {
            *error = instantiationError;
        }
        return NO;
    }
    return YES;
}

@end
