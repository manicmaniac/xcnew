// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef DVTPLATFORM_H
#define DVTPLATFORM_H

@class NSDictionary, NSHashTable, NSArray, NSString, NSSet;

#import <Foundation/Foundation.h>

@class DVTSDK;
@class DVTExtendedPlatformInfo;
@class DVTPlatformFamily;
@class DVTVersion;
@class DVTFilePath;

@interface DVTPlatform : NSObject<NSCopying>




@property (readonly) DVTExtendedPlatformInfo *dvt_extendedInfo;
@property (nonatomic, readonly) NSArray *allSupportedArchitectures;
@property (nonatomic, readonly) DVTSDK *latestPublicOrInternalSDK;
@property (nonatomic, readonly) DVTSDK *latestInternalOrPublicSDK;
@property (retain) DVTPlatformFamily *family;               // ivar: _family
@property (readonly, copy) NSArray *alternateNames;         // ivar: _alternateNames
@property (readonly, copy) NSDictionary *deviceProperties;  // ivar: _deviceProperties
@property (readonly, copy) NSString *platformDirectoryName; // ivar: _platformDirectoryName
@property (readonly, copy) NSString *identifier;            // ivar: _identifier
@property (readonly, copy) NSString *name;                  // ivar: _name
@property (readonly) DVTVersion *minimumSDKVersion;         // ivar: _minimumSDKVersion
@property (readonly, copy) NSSet *SDKs;
@property (readonly) DVTSDK *defaultSDKForPlatformInstallation;
@property (readonly) DVTFilePath *platformPath;       // ivar: _platformPath
@property (readonly) DVTFilePath *iconPath;           // ivar: _iconPath
@property (readonly, copy) NSString *userDescription; // ivar: _userDescription
@property (readonly, copy) NSString *platformVersion; // ivar: _platformVersion
@property (readonly) char isDeploymentPlatform;       // ivar: _isDeploymentPlatform
@property (readonly) char isWatchPlatform;
@property (readonly) char isWatchDevice;
@property (readonly) char isiOSDevice;
@property (readonly, copy) NSString *sdkName;
@property (readonly, copy) NSString *internalSDKName;


- (id)dvt_extendedInfoOrError:(id *)arg0;
- (id)initWithPropertyListDictionary:(id)arg0 path:(id)arg1;
- (id)initWithPath:(id)arg0;
- (id)propertyListDictionary;
- (id)internalPropertyListDictionary;
- (void)addSDK:(id)arg0;
- (id)mappedOperatingSystemVersionForPlatformFamily:(id)arg0 version:(id)arg1;
- (id)mappedOperatingSystemVersionForPlatformFamilyName:(id)arg0 version:(id)arg1;
- (id)mappedOperatingSystemVersionForPlatformFamilyName:(id)arg0 version:(id)arg1 reverse:(char)arg2;
- (id)description;
- (char)isEqual:(id)arg0;
- (NSUInteger)hash;
- (id)copyWithZone:(struct _NSZone *)arg0;


@end


#endif