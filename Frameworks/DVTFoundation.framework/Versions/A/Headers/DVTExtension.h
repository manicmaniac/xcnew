// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 11.0.0 | SDK: 13.0.0


#ifndef DVTEXTENSION_H
#define DVTEXTENSION_H


#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

@class DVTDispatchLock;
@class DVTPlugInManager;
@class DVTPlugIn;
@class DVTExtensionPoint;
#import "DVTPropertyListEncoding-Protocol.h"

@interface DVTExtension : NSObject<DVTPropertyListEncoding>




@property (readonly) NSDictionary *extensionData;     // ivar: _extensionData
@property (readonly) DVTPlugInManager *plugInManager; // ivar: _plugInManager
@property (readonly, copy) NSString *identifier;      // ivar: _identifier
@property (readonly, copy) NSString *name;            // ivar: _name
@property (readonly) NSBundle *bundle;
@property (readonly, getter=isValid) char valid;
@property (readonly) DVTPlugIn *plugIn;                 // ivar: _plugIn
@property (readonly) DVTExtensionPoint *extensionPoint; // ivar: _extensionPoint
@property (readonly, copy) NSXMLElement *extensionElement;
@property (readonly, copy) NSString *version;
@property (readonly) NSUInteger hash;
@property (readonly) Class superclass;
@property (readonly, copy) NSString *description;
@property (readonly, copy) NSString *debugDescription;


- (id)initWithExtensionData:(id)arg0 plugIn:(id)arg1;
- (id)initWithPropertyList:(id)arg0 owner:(id)arg1;
- (void)awakeFromPropertyList;
- (void)encodeIntoPropertyList:(id)arg0;
- (id)_valueForKey:(id)arg0 inParameterData:(id)arg1 usingSchema:(id)arg2 assertingOnError:(char)arg3 error:(id *)arg4;
- (id)valueForKey:(id)arg0;
- (id)valueForKey:(id)arg0 error:(id *)arg1;
- (char)_hasValueForKey:(id)arg0 inParameterData:(id)arg1 usingSchema:(id)arg2;
- (char)hasValueForKey:(id)arg0;
- (id)stringForKey:(id)arg0;
- (id)requiredStringForKey:(id)arg0;
- (char)boolForKey:(id)arg0;
- (CGFloat)doubleForKey:(id)arg0;
- (NSInteger)integerForKey:(id)arg0;
- (Class)classForKey:(id)arg0 error:(id *)arg1;
- (Class)requiredClassForKey:(id)arg0;
- (id)requiredClassNameForKey:(id)arg0;
- (Class)classForKey:(id)arg0 inheritsFrom:(Class)arg1;
- (Class)requiredClassForKey:(id)arg0 inheritsFrom:(Class)arg1;
- (Class)classForKey:(id)arg0 conformsTo:(id)arg1;
- (Class)requiredClassForKey:(id)arg0 conformsTo:(id)arg1;
- (id)extensionParametersForKey:(id)arg0;
- (id)objectForKeyedSubscript:(id)arg0;
- (id)requiredValueForKey:(id)arg0;
- (char)_adjustParameterData:(id)arg0 usingSchema:(id)arg1;
- (char)_adjustAttribute:(id)arg0 forKey:(id)arg1 inParameterData:(id)arg2;
- (char)_adjustElement:(id)arg0 forKey:(id)arg1 inParameterData:(id)arg2;
- (void)_adjustClassAttribute:(id)arg0 forKey:(id)arg1 inParameterData:(id)arg2;
- (void)_adjustElementClassAttributes:(id)arg0 forKey:(id)arg1 inParameterData:(id)arg2;
- (void)_adjustClassReferencesInParameterData:(id)arg0 usingSchema:(id)arg1;
- (char)_fireExtensionFaultAssertingOnError:(char)arg0 error:(id *)arg1;
+ (void)initialize;


@end


#endif