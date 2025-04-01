//
//  XCNProjectNormalizer.h
//  xcnew
//
//  Created by Ryosuke Ito on 4/2/25.
//  Copyright © 2025 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XCNProject;

/**
 * A class that normalizes XCNProject properties according to Xcode's constraints.
 */
@interface XCNProjectNormalizer : NSObject

/**
 * Normalizes the properties of the given project according to Xcode's constraints.
 * @param project The project to normalize.
 * @param error On input, a pointer to an error object. If an error occurs, this pointer is set to an actual error object containing the error information.
 * @return YES if the normalization was successful, NO otherwise.
 */
+ (BOOL)normalizeProject:(XCNProject *)project error:(NSError *_Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
