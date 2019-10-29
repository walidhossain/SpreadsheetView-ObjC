//
//  LayoutProperties.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/9/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "LayoutProperties.h"

@implementation LayoutProperties

+(LayoutProperties*)initWithNumberOfColumns:(NSInteger)numberOfColumns numberOfRows:(NSInteger)numberOfRows frozenColumns:(NSInteger)frozenColumns frozenRows:(NSInteger)frozenRows frozenColumnWidth:(CGFloat)frozenColumnWidth frozenRowHeight:(CGFloat)frozenRowHeight columnWidth:(CGFloat)columnWidth rowHeight:(CGFloat)rowHeight columnWidthCache:(NSMutableArray<NSNumber*>*)columnWidthCache rowHeightCache:(NSMutableArray<NSNumber*>*)rowHeightCache mergedCells:(NSMutableArray<CellRange*>*)mergedCells mergedCellLayouts:(NSMutableDictionary<Location*, CellRange*>*)mergedCellLayouts
{
    LayoutProperties *lp = [[LayoutProperties alloc] init];
    lp.numberOfColumns = numberOfColumns;
    lp.numberOfRows = numberOfRows;
    lp.frozenColumns = frozenColumns;
    lp.frozenRows = frozenRows;
    lp.frozenColumnWidth = frozenColumnWidth;
    lp.frozenRowHeight = frozenRowHeight;
    lp.columnWidthCache = columnWidthCache;
    lp.rowHeightCache = rowHeightCache;
    lp.mergedCells = mergedCells;
    lp.mergedCellLayouts = mergedCellLayouts;
    return lp;
}

-(void)setFrozenRows:(NSInteger)frozenRows
{
    _frozenRows = frozenRows;
}
@end
