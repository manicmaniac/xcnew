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
        BOOL _XCNIsDirectory = NO; \
        XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&_XCNIsDirectory] && !_XCNIsDirectory, __VA_ARGS__); \
    } while (0)

#define XCNAssertFileOrDirectoryDoesNotExistAtPath(path, ...) \
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path], __VA_ARGS__)

#define XCNAssertDirectoryExistsAtPath(path, ...) \
    do { \
        BOOL _XCNIsDirectory = NO; \
        XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&_XCNIsDirectory] && _XCNIsDirectory, __VA_ARGS__); \
    } while (0)
