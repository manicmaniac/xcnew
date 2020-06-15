//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Aug  5 2019 01:19:34).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>

@class NSArray, NSDictionary, NSMutableDictionary, NSString;
@protocol IDETemplateOptionParent;

@interface IDETemplateOption : NSObject {
    NSDictionary *_requiredOptions;
    NSString *_emptyReplacement;
    NSString *_fallbackHeader;
    BOOL _required;
    BOOL _notPersisted;
    NSMutableDictionary *_subclassCache;
    BOOL _indented;
    BOOL _enabled;
    BOOL _disabledByConstraints;
    NSString *_displayValue;
    id<IDETemplateOptionParent> _parent;
    NSString *_identifier;
    NSString *_name;
    NSString *_optionDescription;
    NSString *_type;
    NSString *_placeholder;
    NSString *_defaultValue;
    NSString *_value;
    NSString *_prefix;
    NSString *_suffix;
    NSArray *_values;
    NSDictionary *_requiredOptionsForDisplayValues;
    NSDictionary *_suffixes;
    NSDictionary *_mainTemplateFiles;
    NSDictionary *_allowedTypes;
    NSDictionary *_variables;
    long long _sortOrder;
}

+ (id)keyPathsForValuesAffectingBooleanValue;
+ (id)keyPathsForValuesAffectingDisplayValues;
+ (id)keyPathsForValuesAffectingHasValidValue;
+ (id)keyPathsForValuesAffectingDisplayValue;
+ (id)allowedTemplateOptionTypes;

@property (copy) NSDictionary *requiredOptions;                     // @synthesize requiredOptions=_requiredOptions;
@property (nonatomic) BOOL disabledByConstraints;                   // @synthesize disabledByConstraints=_disabledByConstraints;
@property (nonatomic) BOOL enabled;                                 // @synthesize enabled=_enabled;
@property (nonatomic) BOOL indented;                                // @synthesize indented=_indented;
@property long long sortOrder;                                      // @synthesize sortOrder=_sortOrder;
@property (readonly) NSDictionary *variables;                       // @synthesize variables=_variables;
@property (readonly) NSDictionary *allowedTypes;                    // @synthesize allowedTypes=_allowedTypes;
@property (readonly) NSDictionary *mainTemplateFiles;               // @synthesize mainTemplateFiles=_mainTemplateFiles;
@property (readonly) NSDictionary *suffixes;                        // @synthesize suffixes=_suffixes;
@property (readonly) NSDictionary *requiredOptionsForDisplayValues; // @synthesize requiredOptionsForDisplayValues=_requiredOptionsForDisplayValues;
@property (copy) NSArray *values;                                   // @synthesize values=_values;
@property (copy, nonatomic) NSString *suffix;                       // @synthesize suffix=_suffix;
@property (copy, nonatomic) NSString *prefix;                       // @synthesize prefix=_prefix;
@property (copy, nonatomic) NSString *value;                        // @synthesize value=_value;
@property (copy) NSString *defaultValue;                            // @synthesize defaultValue=_defaultValue;
@property (copy) NSString *placeholder;                             // @synthesize placeholder=_placeholder;
@property (copy) NSString *type;                                    // @synthesize type=_type;
@property (copy) NSString *optionDescription;                       // @synthesize optionDescription=_optionDescription;
@property (copy) NSString *name;                                    // @synthesize name=_name;
@property (copy) NSString *identifier;                              // @synthesize identifier=_identifier;
@property id<IDETemplateOptionParent> parent;                       // @synthesize parent=_parent;
- (void)addImportMacroToEngine:(id)arg1;
- (id)_importStringFromWorkspaceVisibilityForFilePath:(id)arg1;
@property (readonly) NSString *identifierValue;
@property (readonly) BOOL shouldPersistValue;
- (void)addMacroToEngine:(id)arg1;
- (unsigned long long)hash;
- (BOOL)isEqual:(id)arg1;
- (id)uniqueIdentifier;
@property BOOL booleanValue;
- (void)updateFilteredDisplayValuesWithOptions:(id)arg1;
@property (readonly) NSArray *displayValues;
@property (readonly) BOOL hasExplicitValues;
@property (readonly) BOOL hasValidValue;
- (void)updateValueWithBuildables:(id)arg1;
- (void)updateValueWithOptions:(id)arg1;
- (void)updateEnabledWithOptions:(id)arg1;
- (id)staticValueWithOptions:(id)arg1;
- (void)setConstrainedDisplayValue:(id)arg1;
@property (copy, nonatomic) NSString *displayValue; // @synthesize displayValue=_displayValue;
- (BOOL)validateValue:(id *)arg1 forKey:(id)arg2 error:(id *)arg3;
- (BOOL)isValue:(id)arg1 usableWithOptions:(id)arg2;
- (BOOL)isUsableWithOptions:(id)arg1;
- (id)init;
- (id)initWithOptionInfo:(id)arg1 filePath:(id)arg2;

@end
