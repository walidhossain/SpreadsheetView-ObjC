//
//  LayoutEngine.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/8/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "LayoutEngine.h"
#import "GridLayout.h"
#import "GridStyleWithPriority.h"

@interface LayoutEngine (){
    CGRect visibleRect;
    CGPoint cellOrigin;
}

@property (nonatomic, strong) SpreadsheetView *spreadsheetView;
@property (nonatomic, strong) ScrollView *scrollView;
@property (nonatomic, assign) CGSize intercellSpacing;
@property (nonatomic, strong) GridStyle *defaultGridStyle;
@property (nonatomic, assign) CircularScrollingConfigurationOptions circularScrollingOptions;
@property (nonatomic, strong) NSString *blankCellReuseIdentifier;
@property (nonatomic, strong) NSMutableSet<NSIndexPath*> *highlightedIndexPaths;
@property (nonatomic, strong) NSMutableSet<NSIndexPath*> *selectedIndexPaths;

@property (nonatomic, assign) NSInteger frozenColumns;
@property (nonatomic, assign) NSInteger frozenRows;

@property (nonatomic, strong) NSMutableArray<NSNumber*> *columnWidthCache;//Float
@property (nonatomic, strong) NSMutableArray<NSNumber*> *rowHeightCache;//Float

@property (nonatomic, assign) NSInteger startColumn;
@property (nonatomic, assign) NSInteger startRow;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) CGPoint insets;

@property (nonatomic, strong) NSMutableArray<NSNumber*> *columnRecords;//Float
@property (nonatomic, strong) NSMutableArray<NSNumber*> *rowRecords;//Float

@property (nonatomic, strong) NSMutableSet<SPAddress*> *mergedCellAddresses;
@property (nonatomic, strong) NSMutableDictionary<SPAddress*,NSString*> *mergedCellRects;


@property (nonatomic, strong) NSMutableSet<SPAddress*> *visibleCellAddresses;

@property (nonatomic, strong) NSMutableDictionary<SPAddress*,GridLayout*> *horizontalGridLayouts;
@property (nonatomic, strong) NSMutableDictionary<SPAddress*,GridLayout*> *verticalGridLayouts;

@property (nonatomic, strong) NSMutableSet<SPAddress*> *visibleHorizontalGridAddresses;
@property (nonatomic, strong) NSMutableSet<SPAddress*> *visibleVerticalGridAddresses;
@property (nonatomic, strong) NSMutableSet<SPAddress*> *visibleBorderAddresses;
@end

@implementation LayoutEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _columnRecords = [[NSMutableArray<NSNumber*> alloc] init];
        _rowRecords = [[NSMutableArray<NSNumber*> alloc] init];
        
        _mergedCellAddresses = [[NSMutableSet<SPAddress*> alloc] init];
        _mergedCellRects = [[NSMutableDictionary<SPAddress*,NSString*> alloc] init];
        
        _visibleCellAddresses = [[NSMutableSet<SPAddress*> alloc] init];
        
        _horizontalGridLayouts = [[NSMutableDictionary<SPAddress*,GridLayout*> alloc] init];
        _verticalGridLayouts = [[NSMutableDictionary<SPAddress*,GridLayout*> alloc] init];
        
        _visibleHorizontalGridAddresses = [[NSMutableSet<SPAddress*> alloc] init];
        _visibleVerticalGridAddresses = [[NSMutableSet<SPAddress*> alloc] init];
        _visibleBorderAddresses = [[NSMutableSet<SPAddress*> alloc] init];
    }
    return self;
}

-(void)setSpreadsheetView:(SpreadsheetView *)spreadsheetView scrollView:(ScrollView *)scrollView
{
    self.spreadsheetView = spreadsheetView;
    self.scrollView = scrollView;
    
    self.intercellSpacing = spreadsheetView.intercellSpacing;
    self.defaultGridStyle = spreadsheetView.gridStyle;
    self.circularScrollingOptions = spreadsheetView->circularScrollingOptions;
    self.blankCellReuseIdentifier = spreadsheetView.blankCellReuseIdentifier;
    self.highlightedIndexPaths = spreadsheetView.highlightedIndexPaths;
    self.selectedIndexPaths = spreadsheetView.selectedIndexPaths;
    
    self.frozenColumns = spreadsheetView.layoutProperties.frozenColumns;
    self.frozenRows = spreadsheetView.layoutProperties.frozenRows;
    self.columnWidthCache = spreadsheetView.layoutProperties.columnWidthCache;
    self.rowHeightCache = spreadsheetView.layoutProperties.rowHeightCache;
    
    self->visibleRect = CGRectMake(scrollView->state.contentOffset.x, scrollView->state.contentOffset.y, scrollView->state.frame.size.width, scrollView->state.frame.size.height);
    self->cellOrigin = CGPointZero;
    
    self.startColumn = scrollView->layoutAttributes.startColumn;
    self.startRow = scrollView->layoutAttributes.startRow;
    self.numberOfColumns = scrollView->layoutAttributes.numberOfColumns;
    self.numberOfRows = scrollView->layoutAttributes.numberOfRows;
    self.columnCount = scrollView->layoutAttributes.columnCount;
    self.rowCount = scrollView->layoutAttributes.rowCount;
    self.insets = scrollView->layoutAttributes.insets;
    
    self.columnRecords = scrollView.columnRecords;
    self.rowRecords = scrollView.rowRecords;
}

-(void)layout
{
    if (!(self.startColumn != self.columnCount && self.startRow != self.rowCount)) {
        return;
    }
    
    NSInteger startRowIndex = [self.spreadsheetView findIndexInRecords:self.scrollView.rowRecords forOffset:self->visibleRect.origin.y - self.insets.y];
    self->cellOrigin.y = self.insets.y + self.scrollView.rowRecords[startRowIndex].integerValue + self.intercellSpacing.height;
    for(NSInteger rowIndex = (startRowIndex + self.startRow);rowIndex<self.rowCount;rowIndex++)
    {
        NSInteger row = rowIndex % self.numberOfRows;
        if ((self.circularScrollingOptions.tableStyle & RowHeaderNotRepeated)
            && self.startRow > 0
            && row < self.frozenRows)
        {
            continue;
        }
        
        BOOL stop = [self enumerateColumnsCurrentRow:row currentRowIndex:rowIndex];
        if (stop) {
            break;
        }
        self->cellOrigin.y += self.rowHeightCache[row].floatValue + self.intercellSpacing.height;
    }
    [self renderMergedCells];
    [self renderVerticalGridlines];
    [self renderHorizontalGridlines];
    [self renderBorders];
    [self returnReusableResouces];
}

-(BOOL)enumerateColumnsCurrentRow:(NSInteger)row currentRowIndex:(NSInteger)rowIndex
{
    NSInteger startColumnIndex = [self.spreadsheetView findIndexInRecords:self.columnRecords forOffset:self->visibleRect.origin.x - self.insets.x];
    self->cellOrigin.x = self.insets.x + self.columnRecords[startColumnIndex].integerValue + self.intercellSpacing.width;
    
    NSInteger columnIndex = startColumnIndex + self.startColumn;
    
    NSInteger columnStep = 1;
    for (;columnIndex < self.columnCount;columnIndex += columnStep)
    {
        NSInteger column = columnIndex % self.numberOfColumns;
        if (self.circularScrollingOptions.tableStyle & ColumnHeaderNotRepeated
            && self.startColumn > 0
            && column < self.frozenColumns) {
            continue;
        }
        
        NSInteger columnWidth = self.columnWidthCache[column].floatValue;
        CellRange *mergedCell = [self.spreadsheetView mergedCellForIndexPath:[[Location alloc] initWithRow:row column:column]];
        if (mergedCell) {
            CGFloat cellWidth = 0;
            CGFloat cellHeight = 0;
            
            CGSize cellSize = mergedCell->size;
            if (!CGSizeIsNull(cellSize)) {
                cellWidth = cellSize.width;
                cellHeight = cellSize.height;
            }else{
                for (NSInteger columnIndex=mergedCell.from.column; columnIndex<=mergedCell.to.column; columnIndex++) {
                    cellWidth += self.columnWidthCache[columnIndex].floatValue + self.intercellSpacing.width;
                }
                for (NSInteger rowIndex=mergedCell.from.row; rowIndex<=mergedCell.to.row; rowIndex++) {
                    cellHeight += self.rowHeightCache[rowIndex].floatValue + self.intercellSpacing.height;
                }
                mergedCell->size = CGSizeMake(cellWidth, cellHeight);
            }
            columnStep += (mergedCell.columnCount - (column - mergedCell.from.column)) - 1;
            SPAddress *address = [[SPAddress alloc] initWithRow:mergedCell.from.row column:mergedCell.from.column rowIndex:(rowIndex - (row - mergedCell.from.row)) columnIndex:(columnIndex - (column - mergedCell.from.column))];
            if (column < self.columnRecords.count) {
                CGFloat offsetWidth = self.columnRecords[column - self.startColumn].floatValue - self.columnRecords[mergedCell.from.column - self.startColumn].floatValue;
                self->cellOrigin.x -= offsetWidth;
            }else {
                CGFloat fromColumn = mergedCell.from.column;
                NSInteger endColumn = self.columnRecords.count - 1;
                
                CGFloat offsetWidth = self.columnRecords[endColumn].floatValue;
                for (NSInteger columnIndex = endColumn; columnIndex<column; columnIndex++){
                    offsetWidth += self.columnWidthCache[columnIndex].floatValue + self.intercellSpacing.width;
                }
                if (fromColumn < self.columnRecords.count) {
                    offsetWidth -= self.columnRecords[mergedCell.from.column].floatValue;
                } else {
                    offsetWidth -= self.columnRecords[endColumn].floatValue;
                    for (NSInteger columnIndex = endColumn; columnIndex<fromColumn; columnIndex++){
                        offsetWidth -= self.columnWidthCache[columnIndex].floatValue + self.intercellSpacing.width;
                    }
                }
                self->cellOrigin.x -= offsetWidth;
            }
            
            if ([self.visibleCellAddresses containsObject:address]) {
                if (self->cellOrigin.x <= CGRectGetMaxX(self->visibleRect)){}else{
                    self->cellOrigin.x += cellWidth;
                    return NO;
                }
                if (self->cellOrigin.y <= CGRectGetMaxY(self->visibleRect)){}else{
                    return YES;
                }
                self->cellOrigin.x += cellWidth;
                continue;
            }
            
            CGFloat offsetHeight = 0;
            if (row<self.rowRecords.count) {
                offsetHeight = self.rowRecords[row - self.startRow].floatValue - self.rowRecords[mergedCell.from.row - self.startRow].floatValue;
            }else{
                NSInteger fromRow = mergedCell.from.row;
                NSInteger endRow = self.rowRecords.count - 1;
                
                offsetHeight = self.rowRecords[endRow].floatValue;
                for (NSInteger rowIndex = endRow; rowIndex < row; rowIndex++) {
                    offsetHeight += self.rowHeightCache[rowIndex].floatValue + self.intercellSpacing.height;
                }
                if(fromRow < self.rowRecords.count) {
                    offsetHeight -= self.rowRecords[fromRow].floatValue;
                } else {
                    offsetHeight -= self.rowRecords[endRow].floatValue;
                    for(NSInteger rowIndex = endRow; rowIndex<fromRow; rowIndex++) {
                        offsetHeight -= self.rowHeightCache[rowIndex].floatValue + self.intercellSpacing.height;
                    }
                }
            }
            
            if(self->cellOrigin.x + cellWidth - self.intercellSpacing.width > CGRectGetMinX(self->visibleRect)) {}else{
                self->cellOrigin.x += cellWidth;
                continue;
            }
            if(self->cellOrigin.x <= CGRectGetMaxX(self->visibleRect)){}else {
                self->cellOrigin.x += cellWidth;
                return NO;
            }
            if(self->cellOrigin.y - offsetHeight + cellHeight - self.intercellSpacing.height > CGRectGetMinY(self->visibleRect)){}else {
                self->cellOrigin.x += cellWidth;
                continue;
            }
            if(self->cellOrigin.y - offsetHeight <= CGRectGetMaxY(self->visibleRect)){}else{
                return YES;
            }
            
            [self.visibleCellAddresses addObject:address];
            [self.mergedCellAddresses addObject:address];
            if ([self.mergedCellAddresses containsObject:address]) {
                self.mergedCellRects[address] = NSStringFromCGRect(CGRectMake(self->cellOrigin.x, self->cellOrigin.y - offsetHeight, cellWidth - self.intercellSpacing.width, cellHeight - self.intercellSpacing.height));
            }
            self->cellOrigin.x += cellWidth;
            continue;
        }
        
        CGFloat rowHeight = self.rowHeightCache[row].floatValue;
        
        if((self->cellOrigin.x + columnWidth) > CGRectGetMinX(self->visibleRect)){} else {
            self->cellOrigin.x += columnWidth + self.intercellSpacing.width;
            continue;
        }
        
        if(self->cellOrigin.x <= CGRectGetMaxX(self->visibleRect)){} else {
            self->cellOrigin.x += columnWidth + self.intercellSpacing.width;
            return NO;
        }
        
        if((self->cellOrigin.y + rowHeight) > CGRectGetMinY(self->visibleRect)) {}else {
            self->cellOrigin.x += columnWidth + self.intercellSpacing.width;
            continue;
        }
        
        if(self->cellOrigin.y <= CGRectGetMaxY(self->visibleRect)){} else {
            return YES;
        }
        
        SPAddress *address = [[SPAddress alloc] initWithRow:row column:column rowIndex:rowIndex columnIndex:columnIndex];
        [self.visibleCellAddresses addObject:address];
        
        CGSize cellSize = CGSizeMake(columnWidth, rowHeight);
        [self layoutCellAddress:address frame:CGRectMake(self->cellOrigin.x, self->cellOrigin.y, cellSize.width, cellSize.height)];
        
        self->cellOrigin.x += columnWidth + self.intercellSpacing.width;
    }
    
    return false;
}

-(void)layoutCellAddress:(SPAddress*)address frame:(CGRect)frame
{
    id <SpreadsheetViewDataSource> dataSource = self.spreadsheetView.dataSource;
    if (!dataSource) {
        return;
    }
    
    Gridlines *gridlines;
    Border *border;
    
    if ([self.scrollView.visibleCells containsMember:address]) {
        Cell *cell = self.scrollView.visibleCells[address];
        if (cell) {
            cell.frame = frame;
            gridlines = cell.gridlines;
            border = [[Border alloc] initWithBorders:cell.borders hasBorder:cell.hasBorder];
        } else{
            gridlines = nil;
            border = [[Border alloc] initWithBorders:nil hasBorder:NO];
        }
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:address.row column:address.column];
        id cell = [dataSource spreadsheetView:self.spreadsheetView cellForItemAt:indexPath];
        
        if (!((Cell *)cell).reuseIdentifier) {
            assert("the cell returned from `spreadsheetView(cellForItemAt:)` does not have a `reuseIdentifier` - cells must be retrieved by calling `dequeueReusableCell(withReuseIdentifier:for:)`");
        }
        ((Cell *)cell).indexPath = indexPath;
        ((Cell *)cell).frame = frame;
        ((Cell *)cell).highlighted = [self.highlightedIndexPaths containsObject:indexPath];
        ((Cell *)cell).selected = [self.selectedIndexPaths containsObject:indexPath];
        
        gridlines = ((Cell *)cell).gridlines;
        border = [[Border alloc] initWithBorders:((Cell *)cell).borders hasBorder:((Cell *)cell).hasBorder];
        
        [self.scrollView addSubview:cell];
        self.scrollView.visibleCells[address] = cell;
    }
    
    if (border.hasBorders) {
        [self.visibleBorderAddresses addObject:address];
    }
    
    if (gridlines) {
        [self layoutGridlinesAddress:address frame:frame gridlines:gridlines];
    }
}

-(void)layoutGridlinesAddress:(SPAddress *)address frame:(CGRect)frame gridlines:(Gridlines*)gridlines
{
    GridStyleWithPriority *topStyle = [self extractGridStyle:gridlines.top];
    GridStyleWithPriority *bottomStyle = [self extractGridStyle:gridlines.bottom];
    GridStyleWithPriority *leftStyle = [self extractGridStyle:gridlines.left];
    GridStyleWithPriority *rightStyle = [self extractGridStyle:gridlines.right];
    
    GridLayout *gridLayout = self.horizontalGridLayouts[address];
    if (gridLayout) {
        if (topStyle.priority > gridLayout.priority) {
            self.horizontalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:topStyle.width gridColor:topStyle.color origin:frame.origin length:frame.size.width edge:RectEdgeMake(leftStyle.width, rightStyle.width, Top) priority:topStyle.priority];
        }
    }else{
        self.horizontalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:topStyle.width gridColor:topStyle.color origin:frame.origin length:frame.size.width edge:RectEdgeMake(leftStyle.width, rightStyle.width, Top) priority:topStyle.priority];
    }
    
    SPAddress *underCellAddress = [[SPAddress alloc] initWithRow:address.row+1 column:address.column rowIndex:address.rowIndex+1 columnIndex:address.columnIndex];
    
    gridLayout = self.horizontalGridLayouts[underCellAddress];
    if (gridLayout) {
        if (bottomStyle.priority > gridLayout.priority) {
            self.horizontalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:bottomStyle.width gridColor:bottomStyle.color origin:CGPointMake(frame.origin.x, CGRectGetMaxY(frame)) length:frame.size.width edge:RectEdgeMake(leftStyle.width, rightStyle.width, Bottom) priority:bottomStyle.priority];
        }
    }else{
        self.horizontalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:bottomStyle.width gridColor:bottomStyle.color origin:CGPointMake(frame.origin.x, CGRectGetMaxY(frame)) length:frame.size.width edge:RectEdgeMake(leftStyle.width, rightStyle.width, Bottom) priority:bottomStyle.priority];
    }
    //
    gridLayout = self.verticalGridLayouts[address];
    if (gridLayout) {
        if (leftStyle.priority > gridLayout.priority) {
            self.verticalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:leftStyle.width gridColor:leftStyle.color origin:frame.origin length:frame.size.height edge:RectEdgeMake(topStyle.width, bottomStyle.width, Left) priority:leftStyle.priority];
        }
    }else{
        self.verticalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:leftStyle.width gridColor:leftStyle.color origin:frame.origin length:frame.size.height edge:RectEdgeMake(topStyle.width, bottomStyle.width, Left) priority:leftStyle.priority];
    }
    
    SPAddress *nextCellAddress = [[SPAddress alloc] initWithRow:address.row column:address.column+1 rowIndex:address.rowIndex columnIndex:address.columnIndex+1];
    
    gridLayout = self.horizontalGridLayouts[nextCellAddress];
    if (gridLayout) {
        if (rightStyle.priority > gridLayout.priority) {
            self.verticalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:rightStyle.width gridColor:rightStyle.color origin:CGPointMake(CGRectGetMaxX(frame), frame.origin.y) length:frame.size.height edge:RectEdgeMake(topStyle.width, bottomStyle.width, Right) priority:rightStyle.priority];
        }
    }else{
        self.verticalGridLayouts[address] = [[GridLayout alloc] initWithGridWidth:rightStyle.width gridColor:rightStyle.color origin:CGPointMake(CGRectGetMaxX(frame), frame.origin.y) length:frame.size.height edge:RectEdgeMake(topStyle.width, bottomStyle.width, Right) priority:rightStyle.priority];
    }
}

-(void)renderMergedCells
{
    for (SPAddress *address in self.mergedCellAddresses) {
        CGRect frame = CGRectFromString(self.mergedCellRects[address]);
        if (CGRectIsNull(frame)) {
            [self layoutCellAddress:address frame:frame];
        }
    }
}

-(void)renderHorizontalGridlines
{
    [self.horizontalGridLayouts enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, GridLayout *gridLayout, BOOL* stop) {
        CGRect frame = CGRectZero;
        frame.origin = gridLayout.origin;
        if (gridLayout.edge.position == Top) {
            RectEdge edge = gridLayout.edge;
            frame.origin.x -= edge.startWidth + (self.intercellSpacing.width - edge.endWidth)/2;
            frame.origin.y -= self.intercellSpacing.height - (self.intercellSpacing.height - gridLayout.gridWidth)/2;
            frame.size.width = gridLayout.length + edge.startWidth + (self.intercellSpacing.width - edge.startWidth)/2 + edge.endWidth + (self.intercellSpacing.width - edge.endWidth)/2;
        }
        if (gridLayout.edge.position == Bottom) {
            RectEdge edge = gridLayout.edge;
            frame.origin.x -= edge.startWidth + (self.intercellSpacing.width - edge.endWidth)/2;
            frame.origin.y -= (gridLayout.gridWidth - self.intercellSpacing.height)/2;
            frame.size.width = gridLayout.length + edge.startWidth + (self.intercellSpacing.width - edge.startWidth)/2 + edge.endWidth + (self.intercellSpacing.width - edge.endWidth)/2;
        }
        frame.size.height = gridLayout.gridWidth;
        
        if ([self.scrollView.visibleHorizontalGridlines containsMember:address]) {
            Gridline *gridline = self.scrollView.visibleHorizontalGridlines[address];
            gridline.frame = frame;
            gridline.color = gridLayout.gridColor;
            gridline.zPosition = gridLayout.priority;
        }else{
            Gridline *gridline = [self.spreadsheetView.horizontalGridlineReuseQueue dequeueOrCreate];
            gridline.frame = frame;
            gridline.color = gridLayout.gridColor;
            gridline.zPosition = gridLayout.priority;
            
            [self.scrollView.layer addSublayer:gridline];
            self.scrollView.visibleHorizontalGridlines[address] = gridline;
        }
        [self.visibleHorizontalGridAddresses addObject:address];
    }];
}

-(void)renderVerticalGridlines
{
    [self.verticalGridLayouts enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, GridLayout *gridLayout, BOOL* stop) {
        CGRect frame = CGRectZero;
        frame.origin = gridLayout.origin;
        if (gridLayout.edge.position == Left) {
            RectEdge edge = gridLayout.edge;
            frame.origin.x -= self.intercellSpacing.width - (self.intercellSpacing.width - gridLayout.gridWidth)/2;
            frame.origin.y -= edge.startWidth + (self.intercellSpacing.height - edge.startWidth)/2;
            frame.size.height = gridLayout.length + edge.startWidth + (self.intercellSpacing.height - edge.startWidth)/2 + edge.endWidth + (self.intercellSpacing.height - edge.endWidth)/2;
        }
        if (gridLayout.edge.position == Right) {
            RectEdge edge = gridLayout.edge;
            frame.origin.x -= (gridLayout.gridWidth - self.intercellSpacing.width)/2;
            frame.origin.y -= edge.startWidth + (self.intercellSpacing.height - edge.startWidth)/2;
            frame.size.height = gridLayout.length + edge.startWidth + (self.intercellSpacing.height - edge.startWidth)/2 + edge.endWidth + (self.intercellSpacing.height - edge.endWidth)/2;
        }
        frame.size.width = gridLayout.gridWidth;
        
        if ([self.scrollView.visibleVerticalGridlines containsMember:address]) {
            Gridline *gridline = self.scrollView.visibleVerticalGridlines[address];
            gridline.frame = frame;
            gridline.color = gridLayout.gridColor;
            gridline.zPosition = gridLayout.priority;
        }else{
            Gridline *gridline = [self.spreadsheetView.verticalGridlineReuseQueue dequeueOrCreate];
            gridline.frame = frame;
            gridline.color = gridLayout.gridColor;
            gridline.zPosition = gridLayout.priority;
            
            [self.scrollView.layer addSublayer:gridline];
            self.scrollView.visibleVerticalGridlines[address] = gridline;
        }
        [self.visibleVerticalGridAddresses addObject:address];
    }];
}

-(void)renderBorders
{
    for (SPAddress *address in self.visibleBorderAddresses) {
        Cell *cell = self.scrollView.visibleCells[address];
        if (cell) {
            if ([self.scrollView.visibleBorders containsMember:address]) {
                Border *border = self.scrollView.visibleBorders[address];
                if (border) {
                    border.borders = cell.borders;
                    border.frame = cell.frame;
                    [border setNeedsDisplay];
                }
            }else{
                Border *border = [self.spreadsheetView.borderReuseQueue dequeueOrCreate];
                border.borders = cell.borders;
                border.frame = cell.frame;
                
                [self.scrollView addSubview:border];
                self.scrollView.visibleBorders[address] = border;
            }
        }
    }
}

-(GridStyleWithPriority *)extractGridStyle:(GridStyle *)style
{
    GridStyleWithPriority *stylePriority = [[GridStyleWithPriority alloc] init];
    
    switch (style.gridStyle) {
        case GridStyleTypeStandard:
            switch (self.defaultGridStyle.gridStyle) {
                case GridStyleTypeSolid:
                    stylePriority.width = style.width;
                    stylePriority.color = style.color;
                    stylePriority.priority = 0;
                    break;
                    
                default:
                    stylePriority.width = 0;
                    stylePriority.color = UIColor.clearColor;
                    stylePriority.priority = 0;
                    break;
            }
            break;
            
        case GridStyleTypeSolid:
            stylePriority.width = style.width;
            stylePriority.color = style.color;
            stylePriority.priority = 200;
            break;
            
        case GridStyleTypeNone:
            stylePriority.width = 0;
            stylePriority.color = UIColor.clearColor;
            stylePriority.priority = 0;
            break;
            
        default:
            stylePriority.width = 0;
            stylePriority.color = UIColor.clearColor;
            stylePriority.priority = 0;
            break;
    }
    
    return stylePriority;
}

-(void)returnReusableResouces
{
    [self.scrollView.visibleCells minus:self.visibleCellAddresses];
    for (SPAddress *address in self.scrollView.visibleCells.addresses) {
        Cell *cell = self.scrollView.visibleCells[address];
        if (cell) {
            [cell removeFromSuperview];
            NSString *reuseIdentifier = cell.reuseIdentifier;
            ReuseQueue *reuseQueue = self.spreadsheetView.cellReuseQueues[cell.reuseIdentifier];
            if (reuseIdentifier && reuseQueue) {
                [reuseQueue enqueue:cell];
            }
            self.scrollView.visibleCells[address] = nil;
        }
    }
    self.scrollView.visibleCells.addresses = self.visibleCellAddresses;
    
    [self.scrollView.visibleVerticalGridlines minus:self.visibleVerticalGridAddresses];
    for (SPAddress *address in self.scrollView.visibleVerticalGridlines.addresses) {
        Gridline *gridline = self.scrollView.visibleVerticalGridlines[address];
        if (gridline) {
            [gridline removeFromSuperlayer];
            [self.spreadsheetView.verticalGridlineReuseQueue enqueue:gridline];
            self.scrollView.visibleVerticalGridlines[address] = nil;
        }
    }
    self.scrollView.visibleVerticalGridlines.addresses = self.visibleVerticalGridAddresses;
    
    [self.scrollView.visibleHorizontalGridlines minus:self.visibleHorizontalGridAddresses];
    for (SPAddress *address in self.scrollView.visibleHorizontalGridlines.addresses) {
        Gridline *gridline = self.scrollView.visibleHorizontalGridlines[address];
        if (gridline) {
            [gridline removeFromSuperlayer];
            [self.spreadsheetView.horizontalGridlineReuseQueue enqueue:gridline];
            self.scrollView.visibleHorizontalGridlines[address] = nil;
        }
    }
    self.scrollView.visibleHorizontalGridlines.addresses = self.visibleHorizontalGridAddresses;
    
    [self.scrollView.visibleBorders minus:self.visibleCellAddresses];
    for (SPAddress *address in self.scrollView.visibleBorders.addresses) {
        Border *border = self.scrollView.visibleBorders[address];
        if (border) {
            [border removeFromSuperview];
            [self.spreadsheetView.borderReuseQueue enqueue:border];
            self.scrollView.visibleBorders[address] = nil;
        }
    }
    self.scrollView.visibleBorders.addresses = self.visibleBorderAddresses;
}

BOOL CGSizeIsNull(CGSize size)
{
    return isnan(size.width) && isnan(size.height);
}
@end
