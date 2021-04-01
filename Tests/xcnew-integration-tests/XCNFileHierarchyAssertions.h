//
//  XCNFileHierarchyAssertions.h
//  xcnew-integration-tests
//
//  Created by Ryosuke Ito on 3/31/21.
//  Copyright © 2021 Ryosuke Ito. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Asserts that file hierarchy matches to the specification file written in `mtree(8)` syntax.
 *
 * You can create specification files with `/usr/sbin/mtree -nck mode -X .mtreeignore > /path/to/specification.dist`.
 */
#define XCNAssertFileHierarchyEqualsToSpecificationName(url, specificationName) XCNPrimitiveAssertFileHierarchyEqualsToSpecificationName(self, (url), (specificationName), @__FILE__, __LINE__)
#define XCNAssertFileHierarchyEqualsToSpecificationURL(url, specificationURL) XCNPrimitiveAssertFileHierarchyEqualsToSpecification(self, (url), (specificationURL), @__FILE__, __LINE__)

OBJC_EXPORT NSErrorDomain const XCNMtreeErrorDomain;

OBJC_EXPORT void XCNPrimitiveAssertFileHierarchyEqualsToSpecificationName(XCTestCase *self, NSURL *url, NSString *specificationName, NSString *file, NSUInteger line);
OBJC_EXPORT void XCNPrimitiveAssertFileHierarchyEqualsToSpecificationURL(XCTestCase *self, NSURL *url, NSURL *specificationURL, NSString *file, NSUInteger line);

NS_ASSUME_NONNULL_END
