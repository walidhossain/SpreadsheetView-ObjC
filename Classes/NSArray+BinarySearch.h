//
//  NSArray+BinarySearch.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BinarySearch)

- (NSInteger)insertionIndexOfElement:(id)element usingComparator:(NSComparisonResult(^)(id obj1, id obj2))comparator;

@end
