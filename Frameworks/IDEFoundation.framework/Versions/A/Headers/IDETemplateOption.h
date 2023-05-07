// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef IDETEMPLATEOPTION_H
#define IDETEMPLATEOPTION_H

// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'
// Failed to load a property with AttributeError: 'dyld_chained_ptr_64_rebase' object has no attribute 'name'

@class NSString, NSMutableDictionary, NSArray, NSDictionary;

#import <Foundation/Foundation.h>

#import "IDETemplateOptionParent-Protocol.h"

@interface IDETemplateOption : NSObject


@property (copy) NSDictionary *requiredOptions; // ivar: _requiredOptions
@property (copy) NSString *identifier;          // ivar: _identifier
@property (copy) NSString *name;                // ivar: _name
@property (copy) NSString *optionDescription;   // ivar: _optionDescription
@property (copy) NSString *type;                // ivar: _type
@property (copy) NSString *defaultValue;        // ivar: _defaultValue
@property (copy) NSString *overrideValue;       // ivar: _overrideValue


- (id)initWithOptionInfo:(id)arg0 filePath:(id)arg1;
- (id)init;
- (id)description;
- (char)isUsableWithOptions:(id)arg0;
- (char)isValue:(id)arg0 usableWithOptions:(id)arg1;
- (char)validateValue:(id *)arg0 forKey:(id)arg1 error:(id *)arg2;
- (void)setValue:(id)arg0;
- (id)displayValue;
- (void)setDisplayValue:(id)arg0;
- (void)setConstrainedDisplayValue:(id)arg0;
- (void)setPrefix:(id)arg0;
- (void)setSuffix:(id)arg0;
- (id)staticValueWithOptions:(id)arg0;
- (void)updateEnabledWithOptions:(id)arg0;
- (void)setDisabledByConstraints:(char)arg0;
- (void)updateValueWithOptions:(id)arg0;
- (void)updateValueWithBuildables:(id)arg0;
- (char)hasValidValue;
- (id)assistantWarningString;
- (char)hasExplicitValues;
- (id)displayValues;
- (void)updateFilteredDisplayValuesWithOptions:(id)arg0;
- (char)booleanValue;
- (void)setBooleanValue:(char)arg0;
- (void)setEnabled:(char)arg0;
- (id)uniqueIdentifier;
- (char)isEqual:(id)arg0;
- (NSUInteger)hash;
- (void)addMacroToEngine:(id)arg0;
- (char)shouldPersistValue;
- (id)_importStringFromWorkspaceVisibilityForFilePath:(id)arg0;
- (void)addImportMacroToEngine:(id)arg0;
- (id)parent;
- (void)setParent:(id)arg0;
- (id)placeholder;
- (void)setPlaceholder:(id)arg0;
- (id)value;
- (id)prefix;
- (id)suffix;
- (id)values;
- (void)setValues:(id)arg0;
- (id)suffixes;
- (id)mainTemplateFiles;
- (id)allowedTypes;
- (id)variables;
- (NSInteger)sortOrder;
- (void)setSortOrder:(NSInteger)arg0;
- (char)warnForProblematicProductNames;
- (void)setWarnForProblematicProductNames:(char)arg0;
- (char)indented;
- (void)setIndented:(char)arg0;
- (char)enabled;
- (char)disabledByConstraints;


@end


#endif