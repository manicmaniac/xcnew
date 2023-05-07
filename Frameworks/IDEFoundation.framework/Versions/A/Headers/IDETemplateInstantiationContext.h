// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef IDETEMPLATEINSTANTIATIONCONTEXT_H
#define IDETEMPLATEINSTANTIATIONCONTEXT_H

@class DVTFilePath, NSArray, NSDictionary, NSString;

#import <Foundation/Foundation.h>

@class IDEWorkspace;
@class IDETemplate;
@class IDEContainerItem;
@class IDEGroup;
@protocol IDEProvisioningBasicTeam;

@interface IDETemplateInstantiationContext : NSObject<NSCopying>



@property (retain, nonatomic) IDEWorkspace *workspace;        // ivar: _workspace
@property (retain, nonatomic) IDETemplate *documentTemplate;  // ivar: _documentTemplate
@property (retain) DVTFilePath *documentFilePath;             // ivar: _documentFilePath
@property (copy) NSArray *instantiatedItems;                  // ivar: _instantiatedItems
@property (retain) IDEContainerItem *primaryInstantiatedItem; // ivar: _primaryInstantiatedItem
@property (retain) IDEGroup *destinationGroup;                // ivar: _destinationGroup
@property (copy) id templateFilter;                           // ivar: _templateFilter
@property NSUInteger destinationIndex;                        // ivar: _destinationIndex
@property (copy) NSArray *destinationBuildables;              // ivar: _destinationBuildables
@property char showsCrossPlatformSection;                     // ivar: _showsCrossPlatformSection
@property char showsOtherSection;                             // ivar: _showsOtherSection
@property (retain) IDEWorkspace *createdWorkspace;            // ivar: _createdWorkspace
@property char alwaysReplaceFiles;                            // ivar: _alwaysReplaceFiles
@property char reuseFileReferences;                           // ivar: _reuseFileReferences
@property (retain) NSObject<IDEProvisioningBasicTeam> *team;  // ivar: _team
@property (readonly) NSArray *customDataStoresForTemplateMacros;
@property (readonly) NSDictionary *additionalMacroExpansions;
@property (copy) NSString *nameOfInitialFileForEditor; // ivar: _nameOfInitialFileForEditor


- (id)copyWithZone:(struct _NSZone *)arg0;
- (id)description;
- (id)standardSectionNames;
- (id)arrayBySortingSections:(id)arg0;
- (id)sectionsForAvailableTemplatesOfKind:(id)arg0;
- (id)destinationBlueprintProvider;


@end


#endif