//
//  XCNSecureTemporaryDirectory.h
//  xcnew-tests
//
//  Created by Ryosuke Ito on 2/15/20.
//  Copyright © 2020 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSString *_Nullable XCNCreateSecureTemporaryDirectoryWithBasename(NSString *basename, NSError *__autoreleasing _Nullable *error);

NS_ASSUME_NONNULL_END
