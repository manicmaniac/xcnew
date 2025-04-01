//
//  XCNProjectNormalizer.m
//  xcnew
//
//  Created by Ryosuke Ito on 4/2/25.
//  Copyright © 2025 Ryosuke Ito. All rights reserved.
//

#import "XCNProjectNormalizer.h"

#import "NSError+XCNErrorDomain.h"
#import "XCNAppLifecycle.h"
#import "XCNLanguage.h"
#import "XCNProject.h"
#import "XCNUserInterface.h"

@implementation XCNProjectNormalizer

+ (BOOL)normalizeProject:(XCNProject *)project error:(NSError *_Nullable *_Nullable)error {
    NSParameterAssert(project != nil);

    // Apply constraints based on language
    if (project.language == XCNLanguageObjectiveC) {
        // Objective-C requires Storyboard UI and Cocoa lifecycle
        if (project.userInterface != XCNUserInterfaceStoryboard) {
            if (error) {
                *error = [NSError errorWithDomain:XCNErrorDomain
                                             code:XCNErrorInvalidOption
                                         userInfo:@{NSLocalizedDescriptionKey : @"Objective-C projects must use Storyboard UI"}];
            }
            return NO;
        }

        if (project.lifecycle != XCNAppLifecycleCocoa) {
            if (error) {
                *error = [NSError errorWithDomain:XCNErrorDomain
                                             code:XCNErrorInvalidOption
                                         userInfo:@{NSLocalizedDescriptionKey : @"Objective-C projects must use Cocoa lifecycle"}];
            }
            return NO;
        }
    }

    // Apply constraints based on UI
    if (project.userInterface == XCNUserInterfaceSwiftUI) {
        // SwiftUI requires Swift language
        if (project.language != XCNLanguageSwift) {
            if (error) {
                *error = [NSError errorWithDomain:XCNErrorDomain
                                             code:XCNErrorInvalidOption
                                         userInfo:@{NSLocalizedDescriptionKey : @"SwiftUI requires Swift language"}];
            }
            return NO;
        }
    }

    // Apply constraints based on lifecycle
    if (project.lifecycle == XCNAppLifecycleSwiftUI) {
        // SwiftUI lifecycle requires Swift language and SwiftUI
        if (project.language != XCNLanguageSwift) {
            if (error) {
                *error = [NSError errorWithDomain:XCNErrorDomain
                                             code:XCNErrorInvalidOption
                                         userInfo:@{NSLocalizedDescriptionKey : @"SwiftUI lifecycle requires Swift language"}];
            }
            return NO;
        }

        if (project.userInterface != XCNUserInterfaceSwiftUI) {
            if (error) {
                *error = [NSError errorWithDomain:XCNErrorDomain
                                             code:XCNErrorInvalidOption
                                         userInfo:@{NSLocalizedDescriptionKey : @"SwiftUI lifecycle requires SwiftUI user interface"}];
            }
            return NO;
        }
    }

    return YES;
}

@end
