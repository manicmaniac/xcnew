// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef DVTFILEPATH_H
#define DVTFILEPATH_H

@class NSString, NSURL, NSArray, NSDate, NSDictionary, NSNumber;

#import <Foundation/Foundation.h>

@class DVTFilePath;
@class DVTFileSystemVNode;
@class DVTFileDataType;
#import "DVTFileSystemRepresentationProviding-Protocol.h"

@interface DVTFilePath : NSObject<NSCopying, DVTFileSystemRepresentationProviding, NSSecureCoding>




@property (readonly) DVTFilePath *parentFilePath;
@property (readonly) DVTFilePath *volumeFilePath;
@property (readonly) NSString *pathString;
@property (readonly) NSArray *pathComponents;
@property (readonly) NSURL *fileURL;
@property (readonly) NSString *fileName;
@property (readonly) NSString *pathExtension;
@property (readonly) char existsInFileSystem;
@property (readonly) char isReadable;
@property (readonly) char isWritable;
@property (readonly) char isDeletable;
@property (readonly) char isExecutable;
@property (readonly) char isSymbolicLink;
@property (readonly) char isExcludedFromBackup;
@property (readonly) NSString *fileTypeAttribute;
@property (readonly) NSDate *modificationDate;
@property (readonly) NSArray *directoryContents;
@property (readonly) NSArray *sortedDirectoryContents;
@property (readonly) char isDirectory;
@property (readonly) NSDictionary *fileAttributes;
@property (readonly) NSDictionary *fileSystemAttributes;
@property (readonly) NSURL *fileReferenceURL;
@property (readonly) DVTFilePath *symbolicLinkDestinationFilePath;
@property (readonly) DVTFileDataType *fileDataTypeFromFileContent;
@property (readonly) DVTFileDataType *fileDataTypePresumed;
@property (readonly) NSNumber *recursiveFileSize;


- (void)dealloc;
- (void)_invokeWithLockedChildPaths:(id)arg0;
- (void)_invokeWithLockedAssociates:(id)arg0;
- (id)init;
- (id)copyWithZone:(struct _NSZone *)arg0;
- (id)initWithCoder:(id)arg0;
- (void)encodeWithCoder:(id)arg0;
- (char)isAncestorOfFilePath:(id)arg0;
- (id)firstAncestorPassingTest:(id)arg0;
- (id)filePathForRelativeFileSystemRepresentation:(char *)arg0 length:(NSUInteger)arg1;
- (id)filePathForRelativeFileSystemRepresentation:(char *)arg0;
- (id)filePathForRelativePathString:(id)arg0;
- (id)filePathForUniqueRelativeFileWithPrefix:(id)arg0 error:(id *)arg1;
- (id)filePathForUniqueRelativeDirectoryWithPrefix:(id)arg0 error:(id *)arg1;
- (char)getFullFileSystemRepresentationIntoBuffer:(char **)arg0 ofLength:(NSUInteger)arg1 allowAllocation:(char)arg2;
- (char)_fileNameHasSuffix:(char *)arg0 suffixLength:(NSInteger)arg1;
- (char *)fileNameFSRepReturningLength:(NSInteger *)arg0;
- (void)invokeWithAccessToHeapAllocatedFileSystemRepresentationAndLength:(id)arg0;
- (void)invokeWithAccessToFileSystemRepresentationAndLength:(id)arg0;
- (void)invokeWithAccessToFileSystemRepresentation:(id)arg0;
- (id)relativePathStringFromAncestorFilePath:(id)arg0;
- (id)relativePathStringFromFilePath:(id)arg0;
- (char)isEqual:(id)arg0;
- (char)isSameFileAsFilePath:(id)arg0;
- (void)_locked_tentativelyInvalidateChildrenRecursivelyWithChildrenShouldBeTentativelyInvalid:(char)arg0;
- (void)_locked_validateTentativelyInvalidatedChildrenRecursively;
- (void)_invalidateChildrenRecursivelyKnownDoesNotExist:(char)arg0;
- (void)_invalidateKnownDoesNotExist:(char)arg0 explicitlyInvalidateChildren:(char)arg1;
- (void)invalidateFilePath;
- (void)_invalidateFilePathAndChildren;
- (void)_invalidateFilePathAndChildrenIncludingEquivalents;
- (id)_locked_vnodeKnownDoesNotExist:(char)arg0;
- (id)_locked_vnode;
- (char)_hasResolvedVnode;
- (void)excludeFromBackup;
- (void)performCoordinatedReadRecursively:(char)arg0;
- (id)directoryContentsWithError:(id *)arg0;
- (id)machOArchitecturesWithError:(id *)arg0;
- (id)recursiveFileSizeWithError:(id *)arg0;
- (id)cachedValueForKey:(id)arg0;
- (char)_addInfoForObserversOfChangedFilePath:(id)arg0 toObjects:(id)arg1 roles:(id)arg2 blocks:(id)arg3 dispatchQueues:(id)arg4 operationQueues:(id)arg5;
- (char)_hasChangeObservers;
- (void)_notifyAssociatesOfChange;
- (void)_addAssociatesWithRole:(id)arg0 toArray:(id *)arg1;
- (id)associatesWithRole:(id)arg0 forAllPathsToSameFile:(char)arg1;
- (id)associatesWithRole:(id)arg0;
- (void)addAssociate:(id)arg0 withRole:(id)arg1;
- (void)addAssociate:(id)arg0 withRole:(id)arg1 observingDidChangeRecursively:(char)arg2 onDispatchQueue:(id)arg3 block:(id)arg4;
- (void)addAssociate:(id)arg0 withRole:(id)arg1 observingDidChangeRecursively:(char)arg2 onOperationQueue:(id)arg3 block:(id)arg4;
- (void)removeAssociate:(id)arg0 withRole:(id)arg1;
- (void)removeAssociatesWithRole:(id)arg0;
- (void)removeAssociate:(id)arg0;
- (void)removeAllAssociates;
- (void)simulateFileSystemNotificationAndNotifyAssociatesForUnitTests;
- (NSInteger)comparePathString:(id)arg0;
- (void)dvt_provideFileSystemRepresentationToBlock:(id)arg0;
- (id)description;
- (id)_descriptionOfAssociates;


@end


#endif