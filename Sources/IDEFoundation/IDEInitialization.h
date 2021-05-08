//
//  IDEInitialization.h
//  IDEFoundation
//
//  Created by Ryosuke Ito on 5/8/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL IDEInitialize(int initializationOptions, NSError *__autoreleasing _Nullable *_Nullable error);
extern BOOL IDEInitializationCompleted(int *_Nullable initializationOptions);
