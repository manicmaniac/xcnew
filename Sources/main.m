//
//  main.m
//  xcnew
//
//  Created by Ryosuke Ito on 7/31/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCNErrors.h"
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
            project.hasUnitTests = optionSet.hasUnitTests;
            project.hasUITests = optionSet.hasUITests;
            project.useCoreData = optionSet.useCoreData;
            project.language = optionSet.language;
            project.userInterface = optionSet.userInterface;
            [project writeToURL:optionSet.outputURL error:&error];
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
