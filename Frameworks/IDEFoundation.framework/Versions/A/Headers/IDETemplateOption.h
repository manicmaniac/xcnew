// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 11.0.0 | SDK: 13.0.0


#ifndef IDETEMPLATEOPTION_H
#define IDETEMPLATEOPTION_H


#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import "IDETemplateOptionParent-Protocol.h"

@interface IDETemplateOption : NSObject


@property (copy) NSDictionary *requiredOptions;        // ivar: _requiredOptions
@property (copy) NSString *identifier;                 // ivar: _identifier
@property (copy) NSString *name;                       // ivar: _name
@property (copy) NSString *optionDescription;          // ivar: _optionDescription
@property (copy) NSString *type;                       // ivar: _type
@property (copy) NSString *defaultValue;               // ivar: _defaultValue
@property (copy) NSString *overrideValue;              // ivar: _overrideValue
@property (copy) NSString *placeholder;                // ivar: _placeholder
@property (retain) id<IDETemplateOptionParent> parent; // ivar: _parent
@property (copy, nonatomic) NSString *value;           // ivar: _value
@property (copy, nonatomic) NSString *displayValue;    // ivar: _displayValue
@property (copy, nonatomic) NSString *prefix;          // ivar: _prefix
@property (copy, nonatomic) NSString *suffix;          // ivar: _suffix
@property char booleanValue;
@property (copy) NSArray *values; // ivar: _values
@property (readonly) char hasExplicitValues;
@property (readonly) NSArray *displayValues;
@property (readonly) NSDictionary *requiredOptionsForDisplayValues; // ivar: _requiredOptionsForDisplayValues
@property (readonly) NSDictionary *suffixes;                        // ivar: _suffixes
@property (readonly) NSDictionary *mainTemplateFiles;               // ivar: _mainTemplateFiles
@property (readonly) NSDictionary *allowedTypes;                    // ivar: _allowedTypes
@property (readonly) NSDictionary *variables;                       // ivar: _variables
@property NSInteger sortOrder;                                      // ivar: _sortOrder
@property (nonatomic) char warnForProblematicProductNames;          // ivar: _warnForProblematicProductNames
@property (nonatomic) char indented;                                // ivar: _indented
@property (nonatomic) char enabled;                                 // ivar: _enabled
@property (nonatomic) char disabledByConstraints;                   // ivar: _disabledByConstraints
@property (readonly) char hasValidValue;
@property (readonly) NSString *assistantWarningString;
@property (readonly) char shouldPersistValue;
@property (readonly) NSString *identifierValue;


- (id)initWithOptionInfo:(id)arg0 filePath:(id)arg1;
- (id)init;
- (id)description;
- (char)isUsableWithOptions:(id)arg0;
- (char)isValue:(id)arg0 usableWithOptions:(id)arg1;
- (char)validateValue:(id *)arg0 forKey:(id)arg1 error:(id *)arg2;
- (void)setConstrainedDisplayValue:(id)arg0;
- (id)staticValueWithOptions:(id)arg0;
- (void)updateEnabledWithOptions:(id)arg0;
- (void)updateValueWithOptions:(id)arg0;
- (void)updateValueWithBuildables:(id)arg0;
- (void)updateFilteredDisplayValuesWithOptions:(id)arg0;
- (id)uniqueIdentifier;
- (char)isEqual:(id)arg0;
- (NSUInteger)hash;
- (void)addMacroToEngine:(id)arg0;
- (id)_importStringFromWorkspaceVisibilityForFilePath:(id)arg0;
- (void)addImportMacroToEngine:(id)arg0;
+ (id)allowedTemplateOptionTypes;
+ (id)keyPathsForValuesAffectingDisplayValue;
+ (id)keyPathsForValuesAffectingHasValidValue;
+ (id)keyPathsForValuesAffectingAssistantWarningString;
+ (id)keyPathsForValuesAffectingDisplayValues;
+ (id)keyPathsForValuesAffectingBooleanValue;


@end


#endif