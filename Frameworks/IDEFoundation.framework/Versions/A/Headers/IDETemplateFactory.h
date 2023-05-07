// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0


#ifndef IDETEMPLATEFACTORY_H
#define IDETEMPLATEFACTORY_H


#import <Foundation/Foundation.h>


@interface IDETemplateFactory : NSObject



- (char)canInstantiateTemplateForContext:(id)arg0;
- (id)proposedFilePathsForContext:(id)arg0 options:(id)arg1 error:(id *)arg2;
- (void)instantiateTemplateForContext:(id)arg0 options:(id)arg1 whenDone:(id)arg2;
- (char)_isHiddenFilePath:(id)arg0;
- (char)shouldProcessPath:(id)arg0 forContext:(id)arg1 inTemplate:(id)arg2;
- (id)mainFileNameForContext:(id)arg0;


@end


#endif