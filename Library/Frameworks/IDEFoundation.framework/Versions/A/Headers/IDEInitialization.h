//
//  IDEInitialization.h
//  IDEFoundation
//
//  Created by Ryosuke Ito on 3/25/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT BOOL IDEInitialize(int initializationOptions, NSError *__autoreleasing _Nullable *_Nullable error);
OBJC_EXPORT BOOL IDEInitializationCompleted(int *_Nullable initializationOptions);
