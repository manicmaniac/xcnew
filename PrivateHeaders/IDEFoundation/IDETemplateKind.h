//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Aug  5 2019 01:19:34).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>

@class DVTExtension, IDETemplateFactory, NSArray, NSString;

@interface IDETemplateKind : NSObject {
    Class _instantiationContextClass;
    IDETemplateFactory *_factory;
    NSArray *_conformedToTemplateKinds;
    DVTExtension *_extension;
    NSString *_assistantIdentifier;
}

+ (id)targetTemplateKind;
+ (id)packageTemplateKind;
+ (id)projectTemplateKind;
+ (id)playgroundTemplateKind;
+ (id)fileTemplateKind;
+ (id)allTemplateKinds;
+ (id)templateKindForIdentifier:(id)arg1;
+ (id)_templateKindForExtension:(id)arg1;
+ (void)initialize;
@property (readonly, copy) NSString *assistantIdentifier; // @synthesize assistantIdentifier=_assistantIdentifier;
@property (readonly) DVTExtension *extension;             // @synthesize extension=_extension;

- (id)nextAssistantIdentifierForWorkspace:(id)arg1;
- (id)newTemplateInstantiationContext;
- (Class)instantiationContextClass;
@property (readonly, nonatomic) BOOL prefersStandaloneWorkspace;
@property (readonly, nonatomic) BOOL requiresProject;
@property (readonly, nonatomic) BOOL wantsToolbarInSimpleFilesWorkspace;
@property (readonly, nonatomic) BOOL wantsSimpleFilesWorkspace;
@property (readonly) NSString *createdObjectTypeName;
- (id)_possiblyInheritedValueForExtensionKey:(id)arg1;
- (BOOL)conformsToTemplateKind:(id)arg1;
@property (readonly, copy) NSArray *conformedToTemplateKinds; // @synthesize conformedToTemplateKinds=_conformedToTemplateKinds;
@property (readonly) Class templateClass;
@property (readonly) IDETemplateFactory *factory; // @synthesize factory=_factory;
- (id)description;
- (id)initWithExtension:(id)arg1;

@end
