//
//  XCNUserInterface.m
//  xcnew
//
//  Created by Ryosuke Ito on 2/14/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import "XCNUserInterface.h"

NSString *NSStringFromXCNUserInterface(XCNUserInterface userInterface) {
    switch (userInterface) {
        case XCNUserInterfaceSwiftUI:
            return @"SwiftUI";
        case XCNUserInterfaceStoryboard:
            return @"Storyboard";
        default:
            [NSException raise:NSInvalidArgumentException format:@"XCNUserInterface %lu doesn't exist.", userInterface];
    }
}
