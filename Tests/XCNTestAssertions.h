//
//  XCNTestAssertions.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

@import XCTest;

#define XCNAssertFileExistsAtPath(path, ...) \
    do { \
        BOOL xcn_isDirectory = NO; \
        XCTAssert([NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&xcn_isDirectory] && !xcn_isDirectory, __VA_ARGS__); \
    } while (0)

#define XCNAssertFileOrDirectoryDoesNotExistAtPath(path, ...) \
    XCTAssertFalse([NSFileManager.defaultManager fileExistsAtPath:path], __VA_ARGS__)

#define XCNAssertDirectoryExistsAtPath(path, ...) \
    do { \
        BOOL xcn_isDirectory = NO; \
        XCTAssert([NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&xcn_isDirectory] && xcn_isDirectory, __VA_ARGS__); \
    } while (0)

#define XCNAssertFileContainsString(path, string, ...) \
    do { \
        NSError *xcn_error = nil; \
        NSString *xcn_contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&xcn_error]; \
        XCTAssertNil(xcn_error); \
        XCTAssert([xcn_contents containsString:string], __VA_ARGS__); \
    } while (0)
