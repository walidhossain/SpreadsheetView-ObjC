//
//  CellRange.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "CellRange.h"

@interface CellRange()

@property (nonatomic, strong) Location *from;
@property (nonatomic, strong) Location *to;

@property (nonatomic, readwrite) NSInteger columnCount;
@property (nonatomic, readwrite) NSInteger rowCount;

@end

@implementation CellRange

-(id)initWithLocation:(Location *)from to:(Location *)to
{
    if (!(from.column <= to.column && from.row <= to.row)) {
        NSAssert(NO,@"the value of `from` must be less than or equal to the value of `to`");
    }
    self = [super init];
    if (self) {
        self.from   = from;
        self.to     = to;
        self.columnCount = to.column - from.column +1;
        self.rowCount    = to.row - from.row +1;
    }
    return self;
}

-(id)initWithIndexPath:(NSIndexPath *)from to:(NSIndexPath *)to
{
    return [self initWithLocation:[[Location alloc] initWithRow:from.row column:from.column] to:[[Location alloc] initWithRow:to.row column:to.column]];
}

-(id)initFrom:(CellIndex)from to:(CellIndex)to
{
    return [self initWithLocation:[[Location alloc] initWithRow:from.row column:from.column] to:[[Location alloc] initWithRow:to.row column:to.column]];
}


-(BOOL)containsIndexPath:(NSIndexPath *)indexPath
{
    return  self.from.column <= indexPath.column && self.to.column >= indexPath.column &&
    self.from.row <= indexPath.row && self.to.row >= indexPath.row;
}

-(BOOL)containsCellRange:(CellRange *)cellRange
{
    return self.from.column <= cellRange.from.column && self.to.column >= cellRange.to.column &&
    self.from.row <= cellRange.from.row && self.to.row >= cellRange.to.row;
}

CellIndex CellIndexMake(NSInteger row, NSInteger column)
{
    CellIndex ci; ci.row = row; ci.column = column; return ci;
}
@end
