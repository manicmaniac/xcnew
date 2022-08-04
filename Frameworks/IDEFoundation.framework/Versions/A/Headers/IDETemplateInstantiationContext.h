//
//     Generated by class-dump 3.5-0.1.1 (64 bit) (forked by @manicmaniac).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>


@class DVTFilePath, IDEContainerItem, IDEGroup, IDETemplate, IDEWorkspace, NSArray, NSDictionary, NSString;
@protocol IDEProvisioningBasicTeam;

@interface IDETemplateInstantiationContext : NSObject<NSCopying>

// - (void).cxx_destruct;
@property (copy) NSString *nameOfInitialFileForEditor;        // @synthesize nameOfInitialFileForEditor=_nameOfInitialFileForEditor;
@property (retain) id<IDEProvisioningBasicTeam> team;         // @synthesize team=_team;
@property BOOL reuseFileReferences;                           // @synthesize reuseFileReferences=_reuseFileReferences;
@property BOOL alwaysReplaceFiles;                            // @synthesize alwaysReplaceFiles=_alwaysReplaceFiles;
@property (retain) IDEWorkspace *createdWorkspace;            // @synthesize createdWorkspace=_createdWorkspace;
@property BOOL showsOtherSection;                             // @synthesize showsOtherSection=_showsOtherSection;
@property BOOL showsCrossPlatformSection;                     // @synthesize showsCrossPlatformSection=_showsCrossPlatformSection;
@property (copy) NSArray *destinationBuildables;              // @synthesize destinationBuildables=_destinationBuildables;
@property unsigned long long destinationIndex;                // @synthesize destinationIndex=_destinationIndex;
@property (copy) id /* CDUnknownBlockType templateFilter */;  // @synthesize templateFilter=_templateFilter;
@property (retain) IDEGroup *destinationGroup;                // @synthesize destinationGroup=_destinationGroup;
@property (retain) IDEContainerItem *primaryInstantiatedItem; // @synthesize primaryInstantiatedItem=_primaryInstantiatedItem;
@property (copy) NSArray *instantiatedItems;                  // @synthesize instantiatedItems=_instantiatedItems;
@property (retain) DVTFilePath *documentFilePath;             // @synthesize documentFilePath=_documentFilePath;
@property (retain, nonatomic) IDETemplate *documentTemplate;  // @synthesize documentTemplate=_documentTemplate;
@property (retain, nonatomic) IDEWorkspace *workspace;        // @synthesize workspace=_workspace;
@property (readonly) NSDictionary *additionalMacroExpansions;
@property (readonly) NSArray *customDataStoresForTemplateMacros;
- (id)destinationBlueprintProvider;
- (id)sectionsForAvailableTemplatesOfKind:(id)arg1;
- (id)arrayBySortingSections:(id)arg1;
- (id)standardSectionNames;
- (id)description;
- (id)copyWithZone:(struct _NSZone *)arg1;

@end
