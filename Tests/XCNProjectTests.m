//
//  XCNProjectTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/13/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNProject.h"

@interface XCNProjectTests : XCTestCase
@end

@implementation XCNProjectTests {
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
        [self setContinueAfterFailure:NO];
        XCTFail(@"%@", error);
    }
}

- (void)tearDown {
    NSError *error;
    if (![_fileManager removeItemAtURL:_temporaryDirectoryURL error:&error]) {
        XCTFail(@"%@", error);
    }
}

- (void)testWriteToURL {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Product"];
    NSError *error = nil;
    XCTAssertTrue([project writeToURL:_temporaryDirectoryURL timeout:60 error:&error]);
    XCTAssertNil(error);
}

@end
