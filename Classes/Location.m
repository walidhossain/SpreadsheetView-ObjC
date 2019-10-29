//
//  Location.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWithRow:(NSInteger)row column:(NSInteger)column
{
    self = [super init];
    if (self) {
        self.row = row;
        self.column = column;
    }
    return self;
}

-(id)initWithIndexPath:(NSIndexPath *)indexPath
{
    return [self initWithRow:indexPath.row column:indexPath.column];
}

@end
