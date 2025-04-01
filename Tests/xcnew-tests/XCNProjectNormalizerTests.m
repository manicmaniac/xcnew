//
//  XCNProjectNormalizerTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 4/2/25.
//  Copyright © 2025 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNAppLifecycle.h"
#import "XCNLanguage.h"
#import "XCNProject.h"
#import "XCNProjectNormalizer.h"
#import "XCNUserInterface.h"

@interface XCNProjectNormalizerTests : XCTestCase
@end

@implementation XCNProjectNormalizerTests

- (void)testNormalizeProjectWithValidSwiftAndStoryboard {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageSwift;
    project.userInterface = XCNUserInterfaceStoryboard;
    project.lifecycle = XCNAppLifecycleCocoa;

    NSError *error;
    XCTAssertTrue([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNil(error);
    XCTAssertEqual(project.language, XCNLanguageSwift);
    XCTAssertEqual(project.userInterface, XCNUserInterfaceStoryboard);
    XCTAssertEqual(project.lifecycle, XCNAppLifecycleCocoa);
}

- (void)testNormalizeProjectWithValidSwiftAndSwiftUI {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageSwift;
    project.userInterface = XCNUserInterfaceSwiftUI;
    project.lifecycle = XCNAppLifecycleCocoa;

    NSError *error;
    XCTAssertTrue([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNil(error);
    XCTAssertEqual(project.language, XCNLanguageSwift);
    XCTAssertEqual(project.userInterface, XCNUserInterfaceSwiftUI);
    XCTAssertEqual(project.lifecycle, XCNAppLifecycleCocoa);
}

- (void)testNormalizeProjectWithValidSwiftAndSwiftUILifecycle {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageSwift;
    project.userInterface = XCNUserInterfaceSwiftUI;
    project.lifecycle = XCNAppLifecycleSwiftUI;

    NSError *error;
    XCTAssertTrue([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNil(error);
    XCTAssertEqual(project.language, XCNLanguageSwift);
    XCTAssertEqual(project.userInterface, XCNUserInterfaceSwiftUI);
    XCTAssertEqual(project.lifecycle, XCNAppLifecycleSwiftUI);
}

- (void)testNormalizeProjectWithValidObjectiveCConfiguration {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageObjectiveC;
    project.userInterface = XCNUserInterfaceStoryboard;
    project.lifecycle = XCNAppLifecycleCocoa;

    NSError *error;
    XCTAssertTrue([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNil(error);
    XCTAssertEqual(project.language, XCNLanguageObjectiveC);
    XCTAssertEqual(project.userInterface, XCNUserInterfaceStoryboard);
    XCTAssertEqual(project.lifecycle, XCNAppLifecycleCocoa);
}

- (void)testNormalizeProjectWithInvalidObjectiveCAndSwiftUI {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageObjectiveC;
    project.userInterface = XCNUserInterfaceSwiftUI;
    project.lifecycle = XCNAppLifecycleCocoa;

    NSError *error;
    XCTAssertFalse([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.localizedDescription, @"Objective-C projects must use Storyboard UI");
}

- (void)testNormalizeProjectWithInvalidObjectiveCAndSwiftUILifecycle {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageObjectiveC;
    project.userInterface = XCNUserInterfaceStoryboard;
    project.lifecycle = XCNAppLifecycleSwiftUI;

    NSError *error;
    XCTAssertFalse([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.localizedDescription, @"Objective-C projects must use Cocoa lifecycle");
}

- (void)testNormalizeProjectWithInvalidSwiftUILifecycleAndStoryboard {
    XCNProject *project = [[XCNProject alloc] initWithProductName:@"Example"];
    project.language = XCNLanguageSwift;
    project.userInterface = XCNUserInterfaceStoryboard;
    project.lifecycle = XCNAppLifecycleSwiftUI;

    NSError *error;
    XCTAssertFalse([XCNProjectNormalizer normalizeProject:project error:&error]);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.localizedDescription, @"SwiftUI lifecycle requires SwiftUI user interface");
}

@end
