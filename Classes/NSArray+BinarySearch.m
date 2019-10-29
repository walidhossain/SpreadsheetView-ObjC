//
//  NSArray+BinarySearch.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import "NSArray+BinarySearch.h"

@implementation NSArray (BinarySearch)

- (NSInteger)insertionIndexOfElement:(id)element usingComparator:(NSComparisonResult(^)(id obj1, id obj2))comparator
{
    NSInteger lower = 0;
    NSInteger upper = self.count - 1;
    while (lower <= upper) {
        NSInteger middle = (lower + upper) / 2;
        if (comparator(self[middle],element) == NSOrderedAscending) {
            lower = middle + 1;
        }else if (comparator(element,self[middle]) == NSOrderedAscending) {
            upper = middle - 1;
        }else{
            return middle;
        }
    }
    return lower;
}

@end
