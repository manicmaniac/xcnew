//
//     Generated by class-dump 3.5 (64 bit) (forked by @manicmaniac).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//

#import <Foundation/Foundation.h>

@class DVTFilePath;

@interface IDETemplateFactory : NSObject {
}

- (id)mainFileNameForContext:(id)arg1;
- (BOOL)shouldProcessPath:(id)arg1 forContext:(id)arg2 inTemplate:(id)arg3;
- (BOOL)_isHiddenFilePath:(id)arg1;
- (void)instantiateTemplateForContext:(id)arg1 options:(id)arg2 whenDone:(void (^)(NSArray<DVTFilePath *> *filePaths, void *_unknown, NSError *error))arg3;
- (id)proposedFilePathsForContext:(id)arg1 options:(id)arg2 error:(id *)arg3;
- (BOOL)canInstantiateTemplateForContext:(id)arg1;

@end
