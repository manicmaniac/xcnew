//
//  main.m
//  xcnew
//
//  Created by Ryosuke Ito on 7/31/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNOptionParser.h"
#import "XCNOptionSet.h"
#import "XCNProject.h"

int main(int argc, char *const argv[]) {
    @autoreleasepool {
        NSError *error;
        XCNOptionSet *optionSet = [XCNOptionParser.sharedOptionParser parseArguments:argv count:argc error:&error];
        if (optionSet) {
            XCNProject *project = [[XCNProject alloc] initWithProductName:optionSet.productName];
            project.organizationName = optionSet.organizationName;
            project.organizationIdentifier = optionSet.organizationIdentifier;
            project.feature = optionSet.feature;
            project.language = optionSet.language;
            project.userInterface = optionSet.userInterface;
            project.lifecycle = optionSet.lifecycle;
            [project writeToURL:optionSet.outputURL timeout:60 error:&error];
        }
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
