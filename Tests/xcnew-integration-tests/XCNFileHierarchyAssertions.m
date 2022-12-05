//
//  XCNFileHierarchyAssertions.m
//  xcnew-integration-tests
//
//  Created by Ryosuke Ito on 3/31/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import "XCNFileHierarchyAssertions.h"

static NSURL *XCNFindFileHierarchySpecificationURLWithName(XCTestCase *testCase, NSString *specificationName);
static void XCNTestCaseRecordError(XCTestCase *testCase, NSError *error, NSString *file, NSUInteger line);
static void XCNTestCaseRecordFailureWithDescription(XCTestCase *testCase, NSString *description, NSString *file, NSUInteger line);

// MARK: Public

NSErrorDomain const XCNMtreeErrorDomain = @"XCNMtreeErrorDomain";

void XCNPrimitiveAssertFileHierarchyEqualsToSpecificationName(XCTestCase *self, NSURL *url, NSString *specificationName, NSString *file, NSUInteger line) {
    NSURL *specificationURL = XCNFindFileHierarchySpecificationURLWithName(self, specificationName);
    XCNPrimitiveAssertFileHierarchyEqualsToSpecificationURL(self, url, specificationURL, file, line);
}

void XCNPrimitiveAssertFileHierarchyEqualsToSpecificationURL(XCTestCase *self, NSURL *url, NSURL *specificationURL, NSString *file, NSUInteger line) {
    NSCParameterAssert(self != nil);
    NSCParameterAssert(url != nil);
    NSCParameterAssert(url.isFileURL);
    NSCParameterAssert(specificationURL != nil);
    NSCParameterAssert(specificationURL.isFileURL);
    NSCParameterAssert(file != nil);
    NSTask *task = [[NSTask alloc] init];
    task.currentDirectoryURL = url;
    task.executableURL = [NSURL fileURLWithPath:@"/usr/sbin/mtree"];
    task.arguments = @[ @"-f", specificationURL.path ];
    NSPipe *outputPipe = [NSPipe pipe];
    task.standardOutput = outputPipe;
    NSPipe *errorPipe = [NSPipe pipe];
    task.standardError = errorPipe;
    NSError *error;
    if (![task launchAndReturnError:&error]) {
        return XCNTestCaseRecordError(self, error, file, line);
    }
    [task waitUntilExit];
    if (!([outputPipe.fileHandleForWriting closeAndReturnError:&error] &&
          [errorPipe.fileHandleForWriting closeAndReturnError:&error])) {
        return XCNTestCaseRecordError(self, error, file, line);
    }
    NSData *outputData = [outputPipe.fileHandleForReading readDataToEndOfFileAndReturnError:&error];
    if (!outputData) {
        return XCNTestCaseRecordError(self, error, file, line);
    }
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSData *errorData = [errorPipe.fileHandleForReading readDataToEndOfFileAndReturnError:&error];
    if (!errorData) {
        return XCNTestCaseRecordError(self, error, file, line);
    }
    NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    switch (task.terminationReason) {
        case NSTaskTerminationReasonExit:
            break;
        case NSTaskTerminationReasonUncaughtSignal: {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:NSUserCancelledError
                                             userInfo:@{NSLocalizedDescriptionKey : errorString}];
            return XCNTestCaseRecordError(self, error, file, line);
        }
    }
    switch (task.terminationStatus) {
        case 0:
            break;
        case 2:
            return XCNTestCaseRecordFailureWithDescription(self, outputString, file, line);
        default: {
            NSError *error = [NSError errorWithDomain:XCNMtreeErrorDomain
                                                 code:task.terminationStatus
                                             userInfo:@{NSLocalizedDescriptionKey : errorString}];
            return XCNTestCaseRecordError(self, error, file, line);
        }
    }
}

// MARK: Private

static NSURL *XCNFindFileHierarchySpecificationURLWithName(XCTestCase *testCase, NSString *specificationName) {
    NSCParameterAssert(testCase != nil);
    NSCParameterAssert(specificationName != nil);
    NSBundle *bundle = [NSBundle bundleForClass:[testCase class]];
    return [bundle URLForResource:specificationName withExtension:@"dist"];
}

static void XCNTestCaseRecordError(XCTestCase *testCase, NSError *error, NSString *file, NSUInteger line) {
    NSCParameterAssert(testCase != nil);
    NSCParameterAssert(file != nil);
    NSCParameterAssert(error != nil);
    XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:file lineNumber:line];
    XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:location];
    XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeThrownError
                                  compactDescription:error.localizedDescription
                                 detailedDescription:error.description
                                   sourceCodeContext:context
                                     associatedError:error
                                         attachments:@[]];
    [testCase recordIssue:issue];
}

static void XCNTestCaseRecordFailureWithDescription(XCTestCase *testCase, NSString *description, NSString *file, NSUInteger line) {
    NSCParameterAssert(testCase != nil);
    NSCParameterAssert(description != nil);
    NSCParameterAssert(file != nil);
    XCTSourceCodeLocation *location = [[XCTSourceCodeLocation alloc] initWithFilePath:file lineNumber:line];
    XCTSourceCodeContext *context = [[XCTSourceCodeContext alloc] initWithLocation:location];
    XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeThrownError
                                  compactDescription:description
                                 detailedDescription:nil
                                   sourceCodeContext:context
                                     associatedError:nil
                                         attachments:@[]];
    [testCase recordIssue:issue];
}
