//
//  XCNFileHierarchyAssertions.m
//  xcnew-integration-tests
//
//  Created by Ryosuke Ito on 3/31/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import "XCNFileHierarchyAssertions.h"

static NSURL *XCNFindFileHierarchySpecificationURLWithName(NSString *specificationName);
static void XCNTestCaseRecordFailureWithDescription(XCTestCase *testCase, NSString *description, NSString *file, NSUInteger line, NSError *error);

// MARK: Public

NSErrorDomain const XCNMtreeErrorDomain = @"XCNMtreeErrorDomain";

void XCNPrimitiveAssertFileHierarchyEqualsToSpecificationName(XCTestCase *self, NSURL *url, NSString *specificationName, NSString *file, NSUInteger line) {
    NSURL *specificationURL = XCNFindFileHierarchySpecificationURLWithName(specificationName);
    XCNPrimitiveAssertFileHierarchyEqualsToSpecificationURL(self, url, specificationURL, file, line);
}

void XCNPrimitiveAssertFileHierarchyEqualsToSpecificationURL(XCTestCase *self, NSURL *url, NSURL *specificationURL, NSString *file, NSUInteger line) {
    NSTask *task = [[NSTask alloc] init];
    task.currentDirectoryURL = url;
    task.executableURL = [NSURL fileURLWithPath:@"/usr/sbin/mtree"];
    task.arguments = @[ @"-f", specificationURL.path ];
    NSPipe *outputPipe = [NSPipe pipe];
    task.standardOutput = outputPipe;
    NSPipe *errorPipe = [NSPipe pipe];
    task.standardError = errorPipe;
    [task launch];
    [task waitUntilExit];
    [outputPipe.fileHandleForWriting closeFile];
    [errorPipe.fileHandleForWriting closeFile];
    NSData *outputData = [outputPipe.fileHandleForReading readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSData *errorData = [errorPipe.fileHandleForReading readDataToEndOfFile];
    NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    switch (task.terminationReason) {
        case NSTaskTerminationReasonExit:
            switch (task.terminationStatus) {
                case 0:
                    break;
                case 2:
                    XCNTestCaseRecordFailureWithDescription(self, outputString, file, line, nil);
                    break;
                default: {
                    NSError *error = [NSError errorWithDomain:XCNMtreeErrorDomain code:task.terminationStatus userInfo:@{
                        NSLocalizedDescriptionKey: errorString
                    }];
                    XCNTestCaseRecordFailureWithDescription(self, errorString, file, line, error);
                    break;
                }
            }
            break;
        case NSTaskTerminationReasonUncaughtSignal: {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
            XCNTestCaseRecordFailureWithDescription(self, errorString, file, line, error);
            break;
        }
    }
}

// MARK: Private

static NSURL *XCNFindFileHierarchySpecificationURLWithName(NSString *specificationName) {
    NSArray *specificationNameVariants = @[
#if XCODE_VERSION_MAJOR >= 0x1200
        [specificationName stringByAppendingString:@"@Xcode12"],
#endif
#if XCODE_VERSION_MAJOR >= 0x1100
        [specificationName stringByAppendingString:@"@Xcode11"],
#endif
#if XCODE_VERSION_MAJOR >= 0x1000
        [specificationName stringByAppendingString:@"@Xcode10"],
#endif
        specificationName,
    ];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.github.manicmaniac.xcnew-integration-tests"];
    for (NSString *specificationNameVariant in specificationNameVariants) {
        NSURL *url = [bundle URLForResource:specificationNameVariant withExtension:@"dist"];
        if (url) {
            return url;
        }
    }
    return nil;
}

static void XCNTestCaseRecordFailureWithDescription(XCTestCase *testCase, NSString *description, NSString *file, NSUInteger line, NSError *error) {
#if XCODE_VERSION_MAJOR >= 0x1200
    XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:file lineNumber:line];
    XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:location];
    XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeThrownError
                                  compactDescription:description
                                 detailedDescription:nil
                                   sourceCodeContext:context
                                     associatedError:error
                                         attachments:@[]];
    [testCase recordIssue:issue];
#else
    [testCase recordFailureWithDescription:description inFile:file atLine:line expected:!error];
#endif
}

