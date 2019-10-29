//
//  SPAddress.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import "SPAddress.h"

@implementation SPAddress

-(id)initWithRow:(NSInteger)row column:(NSInteger)column rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex
{
    self = [super init];
    if (self) {
        self.row = row;
        self.column = column;
        self.rowIndex = rowIndex;
        self.columnIndex = columnIndex;
    }
    return self;
}

- (NSUInteger)hash
{
    return 32768 * self.rowIndex + self.columnIndex;
}

- (BOOL)isEqual:(id)other
{
    if (other == self){
        return YES;
    }
    
    return (self.rowIndex == ((SPAddress *)other).rowIndex && self.columnIndex == ((SPAddress *)other).columnIndex)||(self.row == ((SPAddress *)other).row && self.column == ((SPAddress *)other).column);
}

- (id)copyWithZone:(NSZone *)zone
{
    SPAddress *copy = [[SPAddress alloc] init];
    copy.row = self.row;
    copy.column = self.column;
    copy.rowIndex = self.rowIndex;
    copy.columnIndex = self.columnIndex;
    
    return copy;
}
@end
