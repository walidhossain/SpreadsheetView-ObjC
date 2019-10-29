//
//  LayoutProperties.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/9/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellRange.h"
#import "Location.h"

@interface LayoutProperties : NSObject

@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger frozenColumns;
@property (nonatomic, assign) NSInteger frozenRows;

@property (nonatomic, assign) CGFloat frozenColumnWidth;
@property (nonatomic, assign) CGFloat frozenRowHeight;
@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *columnWidthCache;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *rowHeightCache;

@property (nonatomic, strong) NSMutableArray<CellRange*> *mergedCells;
@property (nonatomic, strong) NSMutableDictionary<Location*, CellRange*> *mergedCellLayouts;


+(LayoutProperties*)initWithNumberOfColumns:(NSInteger)numberOfColumns numberOfRows:(NSInteger)numberOfRows frozenColumns:(NSInteger)frozenColumns frozenRows:(NSInteger)frozenRows frozenColumnWidth:(CGFloat)frozenColumnWidth frozenRowHeight:(CGFloat)frozenRowHeight columnWidth:(CGFloat)columnWidth rowHeight:(CGFloat)rowHeight columnWidthCache:(NSMutableArray<NSNumber*>*)columnWidthCache rowHeightCache:(NSMutableArray<NSNumber*>*)rowHeightCache mergedCells:(NSMutableArray<CellRange*>*)mergedCells mergedCellLayouts:(NSMutableDictionary<Location*, CellRange*>*)mergedCellLayouts;

@end
