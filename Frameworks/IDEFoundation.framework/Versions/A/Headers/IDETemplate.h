// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef IDETEMPLATE_H
#define IDETEMPLATE_H

@class NSString, NSDictionary, DVTFilePath, NSArray;

#import <Foundation/Foundation.h>

@class IDETemplateOption;
@class IDETemplateKind;
@class IDEWorkspace;
#import "IDETemplateOptionParent-Protocol.h"

@interface IDETemplate : NSObject<IDETemplateOptionParent>



@property (retain) IDETemplateOption *optionWithMainTemplateFiles; // ivar: _optionWithMainTemplateFiles
@property (retain) IDETemplateOption *optionWithAllowedTypes;      // ivar: _optionWithAllowedTypes
@property (copy) NSString *templateDescription;                    // ivar: _templateDescription
@property (retain) IDETemplateKind *templateKind;                  // ivar: _templateKind
@property char isDebug;                                            // ivar: _isDebug
@property char skipOptionsAssistant;                               // ivar: _skipOptionsAssistant
@property (readonly, copy) NSDictionary *templateInfo;             // ivar: _templateInfo
@property (readonly) DVTFilePath *filePath;                        // ivar: _filePath
@property (readonly, copy) NSString *templateName;                 // ivar: _templateName
@property (readonly, copy) NSString *templateSummary;              // ivar: _templateSummary
@property (readonly, copy) NSString *templateCategory;             // ivar: _templateCategory
@property (readonly) NSArray *templatePlatforms;                   // ivar: _templatePlatforms
@property (readonly, copy) NSArray *templateOptions;               // ivar: _templateOptions
@property (readonly) char supportsSwiftPackage;                    // ivar: _supportsSwiftPackage
@property (readonly) char chooserOnly;                             // ivar: _chooserOnly
@property (readonly) char hiddenFromLibrary;                       // ivar: _hiddenFromLibrary
@property (readonly) char hiddenFromChooser;                       // ivar: _hiddenFromChooser
@property (readonly, copy) NSString *buildableType;                // ivar: _buildableType
@property NSInteger sortOrder;                                     // ivar: _sortOrder
@property (readonly, copy) NSString *mainTemplateFile;             // ivar: _mainTemplateFile
@property (readonly, copy) NSString *nameOfInitialFileForEditor;   // ivar: _nameOfInitialFileForEditor
@property (readonly, copy) NSArray *allowedTypes;                  // ivar: _allowedTypes
@property (readonly, copy) NSString *defaultCompletionName;        // ivar: _defaultCompletionName
@property (retain, nonatomic) IDEWorkspace *workspace;             // ivar: _workspace
@property (readonly) NSString *currentOptionsIdentifierValue;
@property (readonly) NSString *currentCompletionName;
@property (readonly) IDETemplateOption *productNameOption;
@property (readonly, copy) NSString *identifier; // ivar: _templateIdentifier
@property (readonly) NSUInteger hash;
@property (readonly) Class superclass;
@property (readonly, copy) NSString *description;
@property (readonly, copy) NSString *debugDescription;


- (id)initWithTemplateInfo:(id)arg0 filePath:(id)arg1;
- (Class)templateOptionClass;
- (char)isEqual:(id)arg0;
- (NSInteger)templateCompare:(id)arg0;
- (void)valueDidChangeForOption:(id)arg0;


@end


#endif