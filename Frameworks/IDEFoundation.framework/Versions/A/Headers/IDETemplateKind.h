// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef IDETEMPLATEKIND_H
#define IDETEMPLATEKIND_H

@class DVTExtension, NSString, NSArray;

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


@end


#endif