//
//  DVTFilePathTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <DVTFoundation/DVTFoundation.h>
#import <XCTest/XCTest.h>

@interface DVTFilePathTests : XCTestCase
@end

@implementation DVTFilePathTests {
    NSFileManager *_fileManager;
    NSURL *_temporaryDirectoryURL;
}

- (BOOL)setUpWithError:(NSError *__autoreleasing _Nullable *)error {
    _fileManager = NSFileManager.defaultManager;
    _temporaryDirectoryURL = [_fileManager URLForDirectory:NSItemReplacementDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:_fileManager.temporaryDirectory
                                                    create:YES
                                                     error:error];
    return !!_temporaryDirectoryURL;
}

- (BOOL)tearDownWithError:(NSError *__autoreleasing _Nullable *)error {
    return [_fileManager removeItemAtURL:_temporaryDirectoryURL error:error];
}

- (void)testRemoveAssociatesWithRole {
    NSURL *url = [_temporaryDirectoryURL URLByAppendingPathComponent:@"a non-existent file"];
    DVTFilePath *filePath = [DVTFilePath filePathForFileURL:url];
    id associate = [[NSObject alloc] init];
    NSString *role = @"xcnew-tests.DVTFilePathTests";
    [filePath addAssociate:associate withRole:role];
    XCTAssertEqual([[filePath associatesWithRole:role] count], 1);
    [filePath removeAssociatesWithRole:role];
    XCTAssertEqual([[filePath associatesWithRole:role] count], 0);
}

@end
