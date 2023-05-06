// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 11.0.0 | SDK: 13.0.0


#ifndef IDETEMPLATEKIND_H
#define IDETEMPLATEKIND_H


#import <CoreFoundation/CoreFoundation.h>
#import <DVTFoundation/DVTExtension.h>
#import <Foundation/Foundation.h>

@class IDETemplateFactory;

@interface IDETemplateKind : NSObject


@property (readonly) DVTExtension *extension;     // ivar: _extension
@property (readonly) IDETemplateFactory *factory; // ivar: _factory
@property (readonly) Class templateClass;
@property (readonly, copy) NSString *assistantIdentifier;     // ivar: _assistantIdentifier
@property (readonly, copy) NSArray *conformedToTemplateKinds; // ivar: _conformedToTemplateKinds
@property (readonly) NSString *createdObjectTypeName;
@property (readonly, nonatomic) char wantsSimpleFilesWorkspace;
@property (readonly, nonatomic) char wantsToolbarInSimpleFilesWorkspace;
@property (readonly, nonatomic) char requiresProject;
@property (readonly, nonatomic) char prefersStandaloneWorkspace;


- (id)initWithExtension:(id)arg0;
- (id)description;
- (char)conformsToTemplateKind:(id)arg0;
- (id)_possiblyInheritedValueForExtensionKey:(id)arg0;
- (Class)instantiationContextClass;
- (id)newTemplateInstantiationContext;
- (id)nextAssistantIdentifierForWorkspace:(id)arg0;
+ (void)initialize;
+ (id)_templateKindForExtension:(id)arg0;
+ (id)templateKindForIdentifier:(id)arg0;
+ (id)allTemplateKinds;
+ (id)fileTemplateKind;
+ (id)playgroundTemplateKind;
+ (id)projectTemplateKind;
+ (id)packageTemplateKind;
+ (id)targetTemplateKind;


@end


#endif