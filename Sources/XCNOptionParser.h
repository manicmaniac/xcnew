//
//  XCNOptionParser.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

@import Foundation;

#import "XCNLanguage.h"
#import "XCNMacroDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSString *productName;
    NSString *_Nullable organizationName;
    NSString *_Nullable organizationIdentifier;
    BOOL hasUnitTests;
    BOOL hasUITests;
    BOOL useCoreData;
    XCNLanguage language;
    NSString *outputPath;
} XCNOptionSet;

XCN_FINAL_CLASS
@interface XCNOptionParser : NSObject

@property (class, readonly) XCNOptionParser *sharedOptionParser;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (BOOL)parseArguments:(char *const _Nullable *_Nullable)argv count:(int)argc optionSet:(out XCNOptionSet *)optionSet error:(NSError *__autoreleasing _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
