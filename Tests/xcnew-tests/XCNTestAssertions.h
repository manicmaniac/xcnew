//
//  XCNTestAssertions.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/5/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#ifndef XCNTestAssertions_h
#define XCNTestAssertions_h

#define XCNAssertFileExistsAtPath(path, ...) \
    do { \
        BOOL isDirectory = NO; \
        XCTAssert([NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory, __VA_ARGS__); \
    } while (0)

#define XCNAssertFileOrDirectoryDoesNotExistAtPath(path, ...) \
    XCTAssertFalse([NSFileManager.defaultManager fileExistsAtPath:path], __VA_ARGS__)

#define XCNAssertDirectoryExistsAtPath(path, ...) \
    do { \
        BOOL isDirectory = NO; \
        XCTAssert([NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory, __VA_ARGS__); \
    } while (0)

#define XCNAssertFileContainsString(path, string, ...) \
    do { \
        NSError *error; \
        NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]; \
        XCTAssertNil(error); \
        XCTAssert([contents containsString:string], __VA_ARGS__); \
    } while (0)

#define XCNAssertFileDoesNotContainString(path, string, ...) \
    do { \
        NSError *error; \
        NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]; \
        XCTAssertNil(error); \
        XCTAssertFalse([contents containsString:string], __VA_ARGS__); \
    } while (0)

#endif /* XCNTestAssertions_h */
