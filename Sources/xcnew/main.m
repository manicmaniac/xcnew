//
//  main.m
//  xcnew
//
//  Created by Ryosuke Ito on 7/31/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNOptionParseResult.h"
#import "XCNOptionParser.h"
#import "XCNProject.h"

int main(int argc, char *const argv[]) {
    @autoreleasepool {
        NSError *error;
        XCNOptionParseResult *result = [XCNOptionParser.sharedOptionParser parseArguments:argv count:argc error:&error];
        [result.project writeToURL:result.outputURL timeout:60 error:&error];
        if (error) {
            NSMutableString *message = [NSMutableString stringWithFormat:@"xcnew: %@", error.localizedDescription];
            if (error.localizedFailureReason) {
                [message appendFormat:@" %@", error.localizedFailureReason];
            }
            fprintf(stderr, "%s\n", message.UTF8String);
            return (int)error.code;
        }
    }
    return EXIT_SUCCESS;
}
