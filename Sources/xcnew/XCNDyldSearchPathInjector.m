//
//  XCNDyldSearchPathInjector.m
//  xcnew
//
//  Created by Ryosuke Ito on 8/13/22.
//  Copyright © 2022 Ryosuke Ito. All rights reserved.
//

#import <xcselect.h>
#import "XCNDyldSearchPathInjector.h"
#import "XCNDyldEnvironment.h"
#import "XCNSearchPath.h"

@implementation XCNDyldSearchPathInjector {
    XCNExecvFunctionPointer _execv;
}

// MARK: Public

- (instancetype)initWithExecv:(XCNExecvFunctionPointer)execv {
    self = [super init];
    if (self) {
        _execv = execv;
    }
    return self;
}

- (instancetype)init {
    return [self initWithExecv:execv];
}

- (BOOL)restartProgramWithArgv:(char *const *)argv withUpdatingSearchPathOrReturnError:(NSError **)error {
    char *hostSDKPathCString;
    errno_t errorNumber = xcselect_host_sdk_path(XCSELECT_HOST_SDK_POLICY_MATCHING_PREFERRED, &hostSDKPathCString);
    if (errorNumber != 0) {
        if (error) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:strerror(errorNumber)]
                                                                 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errorNumber userInfo:userInfo];
        }
        return NO;
    }
    NSURL *hostSDKURL = [NSURL fileURLWithFileSystemRepresentation:hostSDKPathCString isDirectory:YES relativeToURL:nil];
    free(hostSDKPathCString);
    NSBundle *xcodeBundle = [self findXcodeBundleWithDescendantURL:hostSDKURL];
    if (!xcodeBundle) {
        if (error) {
            // raise error
        }
        return NO;
    }
    XCNDyldEnvironment *environment = [[XCNDyldEnvironment alloc] initWithGetenv:getenv setenv:setenv];
    XCNSearchPath *dyldFrameworkPath = [[XCNSearchPath alloc] initWithPaths:@[
        @"/usr/lib/swift",
        xcodeBundle.privateFrameworksPath,
        @"/Library/Developer/PrivateFrameworks/CoreDevice.framework/Versions/A/Frameworks",
        xcodeBundle.sharedFrameworksPath,
        xcodeBundle.builtInPlugInsPath
    ]];
    XCNSearchPath *dyldVersionedFrameworkPath = [[XCNSearchPath alloc] initWithPaths:@[
        [xcodeBundle.bundlePath stringByAppendingPathComponent:@"SystemFrameworks"],
        [xcodeBundle.bundlePath stringByAppendingPathComponent:@"InternalFrameworks"]
    ]];
    if ([dyldFrameworkPath isSubsetOfSearchPath:environment.dyldFrameworkPath] &&
        [dyldVersionedFrameworkPath isSubsetOfSearchPath:environment.dyldVersionedFrameworkPath]) {
        NSBundle *dvtFoundation = [NSBundle bundleWithURL:[xcodeBundle.sharedFrameworksURL URLByAppendingPathComponent:@"DVTFoundation.framework"]];
        [dvtFoundation load];
        NSBundle *ideFoundation = [NSBundle bundleWithURL:[xcodeBundle.privateFrameworksURL URLByAppendingPathComponent:@"IDEFoundation.framework"]];
        [ideFoundation load];
        return YES;
    }
    [environment.dyldFrameworkPath appendSearchPath:dyldFrameworkPath];
    [environment.dyldVersionedFrameworkPath appendSearchPath:dyldVersionedFrameworkPath];
    [environment save];
    _execv(argv[0], argv);
    return YES; // The program never reaches here.
}

// MARK: Private

static NSString *const kXcodeBundleIdentifier = @"com.apple.dt.Xcode";

- (nullable NSBundle *)findXcodeBundleWithDescendantURL:(NSURL *_Nonnull)url {
    if ([url.path isEqualToString:@"/"]) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    if ([bundle.bundleIdentifier isEqualToString:kXcodeBundleIdentifier]) {
        return bundle;
    }
    return [self findXcodeBundleWithDescendantURL:url.URLByDeletingLastPathComponent];
}

@end
