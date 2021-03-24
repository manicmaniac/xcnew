//
//  DVTFilePathTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/17/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <DVTFoundation/DVTFilePath.h>
#import <XCTest/XCTest.h>

@interface DVTFilePathTests : XCTestCase
@end

@implementation DVTFilePathTests {
    NSFileManager *_fileManager;
    NSURL *_temporaryDirectoryURL;
}

- (void)setUp {
    _fileManager = NSFileManager.defaultManager;
    NSError *error;
    _temporaryDirectoryURL = [_fileManager URLForDirectory:NSItemReplacementDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:_fileManager.temporaryDirectory
                                                    create:YES
                                                     error:&error];
    if (!_temporaryDirectoryURL) {
        self.continueAfterFailure = NO;
        XCTFail(@"%@", error);
    }
}

- (void)tearDown {
    NSError *error;
    if (![_fileManager removeItemAtURL:_temporaryDirectoryURL error:&error]) {
        XCTFail(@"%@", error);
    }
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
