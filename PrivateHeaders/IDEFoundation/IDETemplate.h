//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Aug  5 2019 01:19:34).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

@import Foundation.NSObject;

#import "IDETemplateOptionParent-Protocol.h"

@class DVTFilePath, IDETemplateKind, IDETemplateOption, IDEWorkspace, NSArray, NSDictionary, NSString;

@interface IDETemplate : NSObject <IDETemplateOptionParent>
{
    BOOL _chooserOnly;
    BOOL _hiddenFromLibrary;
    BOOL _hiddenFromChooser;
    NSString *_defaultCompletionName;
    NSString *_mainTemplateFile;
    NSArray *_allowedTypes;
    NSDictionary *_templateInfo;
    DVTFilePath *_filePath;
    IDETemplateKind *_templateKind;
    NSString *_templateName;
    NSString *_templateSummary;
    NSString *_templateDescription;
    NSString *_templateCategory;
    NSArray *_templatePlatforms;
    NSArray *_templateOptions;
    NSString *_buildableType;
    long long _sortOrder;
    IDEWorkspace *_workspace;
    IDETemplateOption *_optionWithMainTemplateFiles;
    IDETemplateOption *_optionWithAllowedTypes;
}

+ (id)availableTemplatesOfTemplateKind:(id)arg1;
+ (id)_extraTemplateFolderPaths;
+ (id)additionalAvailableTemplatesOfTemplateKind:(id)arg1;
+ (void)_processChildrenOfFilePath:(id)arg1 enumerator:(CDUnknownBlockType)arg2;
+ (void)initialize;
+ (id)_templateInfoForTemplateAtURL:(id)arg1 error:(id *)arg2;
@property(retain) IDETemplateOption *optionWithAllowedTypes; // @synthesize optionWithAllowedTypes=_optionWithAllowedTypes;
@property(retain) IDETemplateOption *optionWithMainTemplateFiles; // @synthesize optionWithMainTemplateFiles=_optionWithMainTemplateFiles;
@property(retain, nonatomic) IDEWorkspace *workspace; // @synthesize workspace=_workspace;
@property long long sortOrder; // @synthesize sortOrder=_sortOrder;
@property(readonly, copy) NSString *buildableType; // @synthesize buildableType=_buildableType;
@property(readonly) BOOL hiddenFromChooser; // @synthesize hiddenFromChooser=_hiddenFromChooser;
@property(readonly) BOOL hiddenFromLibrary; // @synthesize hiddenFromLibrary=_hiddenFromLibrary;
@property(readonly) BOOL chooserOnly; // @synthesize chooserOnly=_chooserOnly;
@property(readonly, copy) NSArray *templateOptions; // @synthesize templateOptions=_templateOptions;
@property(readonly) NSArray *templatePlatforms; // @synthesize templatePlatforms=_templatePlatforms;
@property(readonly, copy) NSString *templateCategory; // @synthesize templateCategory=_templateCategory;
@property(copy) NSString *templateDescription; // @synthesize templateDescription=_templateDescription;
@property(readonly, copy) NSString *templateSummary; // @synthesize templateSummary=_templateSummary;
@property(readonly, copy) NSString *templateName; // @synthesize templateName=_templateName;
@property(retain) IDETemplateKind *templateKind; // @synthesize templateKind=_templateKind;
@property(readonly) DVTFilePath *filePath; // @synthesize filePath=_filePath;
@property(readonly, copy) NSDictionary *templateInfo; // @synthesize templateInfo=_templateInfo;
@property(readonly, copy) NSArray *allowedTypes; // @synthesize allowedTypes=_allowedTypes;
@property(readonly, copy) NSString *mainTemplateFile; // @synthesize mainTemplateFile=_mainTemplateFile;
- (void)valueDidChangeForOption:(id)arg1;
@property(readonly) NSString *currentOptionsIdentifierValue;
@property(readonly) IDETemplateOption *productNameOption;
@property(readonly) NSString *currentCompletionName;
@property(readonly, copy) NSString *defaultCompletionName; // @synthesize defaultCompletionName=_defaultCompletionName;
- (long long)templateCompare:(id)arg1;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
- (BOOL)isEqual:(id)arg1;
@property(readonly, copy) NSString *identifier;
- (Class)templateOptionClass;
- (id)initWithTemplateInfo:(id)arg1 filePath:(id)arg2;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly) Class superclass;

@end

