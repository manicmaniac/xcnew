//
//  XCNUserInterface.h
//  xcnew
//
//  Created by Ryosuke Ito on 2/13/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNMacroDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XCNUserInterface) {
    XCNUserInterfaceSwiftUI,
    XCNUserInterfaceStoryboard,
};

XCN_EXTERN NSString *NSStringFromXCNUserInterface(XCNUserInterface userInterface);

NS_ASSUME_NONNULL_END
