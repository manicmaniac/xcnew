//
//  XCNMacroDefinitions.h
//  xcnew
//
//  Created by Ryosuke Ito on 8/6/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#ifndef XCNMacroDefinitions_h
#define XCNMacroDefinitions_h

#import <Foundation/Foundation.h>

#define XCN_PROGRAM_VERSION "0.3.2"

#ifdef __cplusplus
#define XCN_EXTERN extern "C"
#else
#define XCN_EXTERN extern
#endif

#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#define XCN_FINAL_CLASS __attribute__((objc_subclassing_restricted))
#else
#define XCN_FINAL_CLASS
#endif

#define XCN_SWIFT_UI_IS_AVAILABLE (XCODE_VERSION_ACTUAL >= 1100)

#endif /* XCNMacroDefinions_h */
