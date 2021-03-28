//
//  XCNProjectTests.m
//  xcnew-tests
//
//  Created by Ryosuke Ito on 3/13/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCNMacroDefinitions.h"
#import "XCNProject.h"

@interface XCNProjectTests : XCTestCase

@property (nonatomic, readonly) NSFileWrapper *fileWrapper;

@end

@implementation XCNProjectTests {
    NSFileManager *_fileManager;
    NSURL *_temporaryDirectoryURL;
    XCNProject *_project;
    NSURL *_url;
    NSFileWrapper *_fileWrapper;
}

static NSString *const kProductName = @"Example";

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
        return XCTFail(@"%@", error);
    }
    _project = [[XCNProject alloc] initWithProductName:kProductName];
    _url = [_temporaryDirectoryURL URLByAppendingPathComponent:kProductName];
}

- (void)tearDown {
    NSError *error;
    if (![_fileManager removeItemAtURL:_temporaryDirectoryURL error:&error]) {
        XCTFail(@"%@", error);
    }
}

- (void)testWriteToURLWithDefaultProperties {
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

- (void)testWriteToURLWithOrganizationName {
    _project.organizationName = @"Organization";
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    if (XCN_ORGANIZATION_IS_INCLUDED_IN_APP_DELEGATE) {
        XCTAssertTrue([appDelegateContents containsString:@"Organization"]);
    } else {
        XCTAssertFalse([appDelegateContents containsString:@"Organization"]);
    }
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

- (void)testWriteToURLWithOrganizationIdentifier {
    static NSString *const organizationIdentifier = @"com.example.organization";
    _project.organizationIdentifier = organizationIdentifier;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    NSFileWrapper *projectFileWrapper = self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"];
    NSString *projectContents = [[NSString alloc] initWithData:projectFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([projectContents containsString:organizationIdentifier]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

- (void)testWriteToURLWithUnitAndUITests {
    _project.feature |= (XCNProjectFeatureUnitTests | XCNProjectFeatureUITests);
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"ExampleTests"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"ExampleUITests"].fileWrappers[@"Info.plist"].isRegularFile);
}

#if !XCN_TEST_OPTION_IS_UNIFIED

- (void)testWriteToURLWithUnitTests {
    _project.feature |= XCNProjectFeatureUnitTests;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"ExampleTests"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

- (void)testWriteToURLWithUITests {
    _project.feature |= XCNProjectFeatureUITests;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"ExampleUITests"].fileWrappers[@"Info.plist"].isRegularFile);
}

#endif // !XCN_TEST_OPTION_IS_UNIFIED

- (void)testWriteToURLWithCoreData {
    _project.feature |= XCNProjectFeatureCoreData;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue([appDelegateContents containsString:@"NSPersistentContainer"]);
    XCTAssertFalse([appDelegateContents containsString:@"NSPersistentCloudKitContainer"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"].isDirectory);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

#if XCN_CLOUD_KIT_IS_AVAILABLE
- (void)testWriteToURLWithCoreDataCloudKit {
    _project.feature |= XCNProjectFeatureCloudKit;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertFalse([appDelegateContents containsString:@"NSPersistentContainer"]);
    XCTAssertTrue([appDelegateContents containsString:@"NSPersistentCloudKitContainer"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"].isDirectory);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}
#endif

- (void)testWriteToURLWithObjectiveC {
    _project.language = XCNLanguageObjectiveC;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"]);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.m"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

- (void)testWriteToURLWithStoryboard {
    _project.userInterface = XCNUserInterfaceStoryboard;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.m"]);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

#if XCN_SWIFT_UI_IS_AVAILABLE

- (void)testWriteToURLWithSwiftUI {
    _project.userInterface = XCNUserInterfaceSwiftUI;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.m"]);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

#endif

- (void)testWriteToURLWithCocoaLifecycle {
    _project.lifecycle = XCNAppLifecycleCocoa;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.m"]);
    NSFileWrapper *appDelegateFileWrapper = self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"];
    NSString *appDelegateContents = [[NSString alloc] initWithData:appDelegateFileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
    XCTAssertTrue([appDelegateContents containsString:@"Example"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ExampleApp.swift"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

#if XCN_SWIFT_UI_LIFECYCLE_IS_AVAILABLE

- (void)testWriteToURLWithSwiftUILifecycle {
    _project.lifecycle = XCNAppLifecycleSwiftUI;
    NSError *error;
    XCTAssertTrue([_project writeToURL:_url timeout:10 error:&error]);
    XCTAssertNil(error);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example.xcodeproj"].fileWrappers[@"project.pbxproj"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Info.plist"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.m"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"AppDelegate.swift"]);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ExampleApp.swift"].isRegularFile);
    XCTAssertTrue(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"ContentView.swift"].isRegularFile);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Base.lproj"].fileWrappers[@"Main.storyboard"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@".git"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"Example"].fileWrappers[@"Example.xcdatamodeld"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleTests"]);
    XCTAssertNil(self.fileWrapper.fileWrappers[@"ExampleUITests"]);
}

#endif

- (void)testSetLanguageObjectiveCWhenSwiftUIIsSetAsUserInterface {
    _project.userInterface = XCNUserInterfaceSwiftUI;
    _project.lifecycle = XCNAppLifecycleSwiftUI;
    _project.language = XCNLanguageObjectiveC;
    XCTAssertEqual(_project.userInterface, XCNUserInterfaceStoryboard);
    XCTAssertEqual(_project.lifecycle, XCNAppLifecycleCocoa);
}

- (void)testSetUserInterfaceSwiftUIWhenObjectiveCIsSetAsLanguage {
    _project.language = XCNLanguageObjectiveC;
    _project.userInterface = XCNUserInterfaceSwiftUI;
    XCTAssertEqual(_project.language, XCNLanguageSwift);
}

- (void)testSetLifecycleSwiftUIWhenObjectiveCIsSetAsLanguage {
    _project.language = XCNLanguageObjectiveC;
    _project.lifecycle = XCNAppLifecycleSwiftUI;
    XCTAssertEqual(_project.language, XCNLanguageSwift);
}

- (void)testSetLifecycleSwiftUIWhenStoryboardIsSetAsUserInterface {
    _project.userInterface = XCNUserInterfaceStoryboard;
    _project.lifecycle = XCNAppLifecycleSwiftUI;
    XCTAssertEqual(_project.userInterface, XCNUserInterfaceSwiftUI);
}

- (NSFileWrapper *)fileWrapper {
    @synchronized(self) {
        if (!_fileWrapper) {
            NSError *error;
            _fileWrapper = [[NSFileWrapper alloc] initWithURL:_url
                                                      options:(NSFileWrapperReadingOptions)0
                                                        error:&error];
            if (!_fileWrapper) {
                self.continueAfterFailure = NO;
                XCTFail(@"%@", error);
                return nil;
            }
        }
        return _fileWrapper;
    }
}

@end
