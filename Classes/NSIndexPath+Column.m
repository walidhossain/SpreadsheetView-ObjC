//
//  NSIndexPath+Column.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import "NSIndexPath+Column.h"

@implementation NSIndexPath (Column)

+ (instancetype)indexPathForRow:(NSInteger)row column:(NSInteger)column
{
    return [NSIndexPath indexPathForRow:row inSection:column];
}

- (NSInteger)column
{
    return self.section;
}

@end
