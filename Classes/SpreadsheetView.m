//
//  SpreadsheetView.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/3/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "SpreadsheetView.h"

@interface SpreadsheetView ()


@property (nonatomic, strong) NSMutableDictionary<NSString *,Class> *cellClasses;
@property (nonatomic, strong) NSMutableDictionary<NSString *,UINib *>  *cellNibs;

@property (nonatomic, assign) BOOL needsReload;


@end

@implementation SpreadsheetView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    
    self.rootView = [[UIScrollView alloc] init];
    self.overlayView = [[UIScrollView alloc] init];
    
    self.columnHeaderView = [[ScrollView alloc] init];
    self.rowHeaderView = [[ScrollView alloc] init];
    self.cornerView =[[ScrollView alloc] init];
    self.tableView = [[ScrollView alloc] init];
    
    self.cellClasses = [[NSMutableDictionary alloc] init];
    self.cellNibs = [[NSMutableDictionary alloc] init];
    self.cellReuseQueues = [[NSMutableDictionary alloc] init];
    
    self.needsReload = YES;
    
    self.intercellSpacing = CGSizeMake(1, 1);
    self.gridStyle = [[GridStyle alloc] initWithWidth:1 color:UIColor.darkGrayColor];
    self.layoutProperties = [[LayoutProperties alloc] init];
    self.allowsSelection = YES;
    self.allowsMultipleSelection = NO;
    self.showsHorizontalScrollIndicator = YES;
    self.showsVerticalScrollIndicator = YES;
    self.scrollsToTop = YES;
    self->circularScrollingOptions = [CircularScrollingConfigurationBuilder optionsForState:None];
    self.circularScrollScalingFactor = ScaleFactorMake(1, 1);
    self.centerOffset = CGPointZero;
    self.directionalLockEnabled = NO;
    self.stickyRowHeader = NO;
    self.stickyColumnHeader = NO;
    
    self.blankCellReuseIdentifier = [NSUUID UUID].UUIDString;
    
    self.horizontalGridlineReuseQueue = [[ReuseQueue alloc] initWithClassName:@"Gridline"];
    self.verticalGridlineReuseQueue = [[ReuseQueue alloc] initWithClassName:@"Gridline"];
    self.borderReuseQueue = [[ReuseQueue alloc] initWithClassName:@"Border"];
    
    self.highlightedIndexPaths = [[NSMutableSet alloc] init];
    self.selectedIndexPaths = [[NSMutableSet alloc] init];
    
    self.rootView.frame = self.bounds;
    self.rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.rootView.showsHorizontalScrollIndicator = NO;
    self.rootView.showsVerticalScrollIndicator = NO;
    self.rootView.delegate = self;
    [super addSubview:self.rootView];
    
    self.tableView.frame = self.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    
    self.columnHeaderView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 0, self.bounds.size.height);
    self.columnHeaderView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.columnHeaderView.autoresizesSubviews = NO;
    self.columnHeaderView.showsHorizontalScrollIndicator = NO;
    self.columnHeaderView.showsVerticalScrollIndicator = NO;
    self.columnHeaderView.hidden = YES;
    self.columnHeaderView.delegate = self;
    
    self.rowHeaderView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 0);
    self.rowHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.rowHeaderView.autoresizesSubviews = NO;
    self.rowHeaderView.showsHorizontalScrollIndicator = NO;
    self.rowHeaderView.showsVerticalScrollIndicator = NO;
    self.rowHeaderView.hidden = YES;
    self.rowHeaderView.delegate = self;
    
    self.cornerView.autoresizesSubviews = NO;
    self.cornerView.hidden = YES;
    self.cornerView.delegate = self;
    
    self.overlayView.frame = self.bounds;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.overlayView.autoresizesSubviews = NO;
    self.overlayView.userInteractionEnabled = NO;
    
    [self.rootView addSubview:self.tableView];
    [self.rootView addSubview:self.columnHeaderView];
    [self.rootView addSubview:self.rowHeaderView];
    [self.rootView addSubview:self.cornerView];
    [super addSubview:self.overlayView];
    
    [self addGestureRecognizer:self.columnHeaderView.panGestureRecognizer];
    self.columnHeaderView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addGestureRecognizer:self.rowHeaderView.panGestureRecognizer];
    self.rowHeaderView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addGestureRecognizer:self.cornerView.panGestureRecognizer];
    self.cornerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addGestureRecognizer:self.overlayView.panGestureRecognizer];
    self.overlayView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addGestureRecognizer:self.tableView.panGestureRecognizer];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

-(void)setDataSource:(id<SpreadsheetViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self resetTouchHandlersToScrollViews:[NSArray arrayWithObjects:self.tableView,self.columnHeaderView,self.rowHeaderView,self.cornerView, nil]];
    [self setNeedsReload];
}

-(void)setAllowsSelection:(BOOL)allowsSelection
{
    _allowsSelection = allowsSelection;
    if (!allowsSelection) {
        self.allowsMultipleSelection = NO;
    }
}

-(void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    if (allowsMultipleSelection) {
        self.allowsSelection = YES;
    }
}

-(void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    _overlayView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

-(void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    _overlayView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

-(void)setScrollsToTop:(BOOL)scrollsToTop
{
    _scrollsToTop = scrollsToTop;
    _tableView.scrollsToTop = scrollsToTop;
}

-(void)setCircularScrolling:(CircularScrollingConfiguration *)circularScrolling
{
    _circularScrolling = circularScrolling;
}

-(void)setCircularScrollingOptions:(CircularScrollingConfigurationOptions)circularScrollingOptions
{
    _circularScrollingOptions = circularScrollingOptions;
    
    if (circularScrollingOptions.direction & DirectionHorizontally) {
        self.showsHorizontalScrollIndicator = NO;
    }
    
    if (circularScrollingOptions.direction & DirectionVertically) {
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
    }
}

-(void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
    }
    _backgroundView = backgroundView;
    if (backgroundView) {
        backgroundView.frame = self.bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [super insertSubview:_backgroundView atIndex:0];
    }
}

-(void)setDirectionalLockEnabled:(BOOL)directionalLockEnabled
{
    _directionalLockEnabled = directionalLockEnabled;
    _tableView.directionalLockEnabled = directionalLockEnabled;
}

-(void)setBounces:(BOOL)bounces
{
    _tableView.bounces = bounces;
}

-(void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical
{
    _tableView.alwaysBounceVertical = alwaysBounceVertical;
}

-(BOOL)alwaysBounceVertical
{
    return _tableView.alwaysBounceVertical;
}

-(void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal
{
    _tableView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

-(BOOL)alwaysBounceHorizontal
{
    return _tableView.alwaysBounceHorizontal;
}

-(BOOL)bounces
{
    return self.tableView.bounces;
}

-(void)setPagingEnabled:(BOOL)pagingEnabled
{
    _tableView.pagingEnabled = pagingEnabled;
}

-(BOOL)isPagingEnabled
{
    return _tableView.pagingEnabled;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    _tableView.scrollEnabled = scrollEnabled;
    _overlayView.scrollEnabled = scrollEnabled;
}

-(BOOL)isScrollEnabled
{
    return _tableView.scrollEnabled;
}

-(void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle
{
    _overlayView.indicatorStyle = indicatorStyle;
}

-(UIScrollViewIndicatorStyle)indicatorStyle
{
    return _overlayView.indicatorStyle;
}

-(void)setDecelerationRate:(CGFloat)decelerationRate
{
    _tableView.decelerationRate = decelerationRate;
}

-(CGFloat)decelerationRate
{
    return _tableView.decelerationRate;
}

-(void)registerCellClass:(Class)class forCellWithReuseIdentifier:(NSString *)identifier
{
    self.cellClasses[identifier] = class;
}

-(void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    self.cellNibs[identifier] = nib;
}


-(void)reloadData
{
    self.layoutProperties = [self resetLayoutProperties];
    self.circularScrollScalingFactor = [self determineCircularScrollScalingFactor];
    self.centerOffset = [self calculateCenterOffset];
    
    self.cornerView->layoutAttributes = [self layoutAttributeForCornerView];
    self.columnHeaderView->layoutAttributes = [self layoutAttributeForColumnHeaderView];
    self.rowHeaderView->layoutAttributes = [self layoutAttributeForRowHeaderView];
    self.tableView->layoutAttributes = [self layoutAttributeForTableView];
    
    [self.cornerView resetReusableObjects];
    [self.columnHeaderView resetReusableObjects];
    [self.rowHeaderView resetReusableObjects];
    [self.tableView resetReusableObjects];
    
    [self resetContentSizeOf:self.cornerView];
    [self resetContentSizeOf:self.columnHeaderView];
    [self resetContentSizeOf:self.rowHeaderView];
    [self resetContentSizeOf:self.tableView];
    
    [self resetScrollViewFrame];
    [self resetScrollViewArrangement];
    
    if((self->circularScrollingOptions.direction & DirectionHorizontally) && self.tableView.contentOffset.x == 0) {
        [self scrollToHorizontalCenter];
    }
    if((self->circularScrollingOptions.direction & DirectionVertically) && self.tableView.contentOffset.y == 0) {
        [self scrollToVerticalCenter];
    }
    
    self.needsReload = NO;
    [self setNeedsLayout];
}

-(void)reloadDataIfNeeded {
    if(self.needsReload) {
        [self reloadData];
    }
}

-(void)setNeedsReload {
    self.needsReload = YES;
    [self setNeedsLayout];
}

-(Cell*)dequeueReusableCellWithReuseIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath
{
    if (self.cellReuseQueues[identifier]) {
        ReuseQueue<Cell *> *reuseQueue = self.cellReuseQueues[identifier];
        Cell *cell = [reuseQueue dequeue];
        if (cell) {
            [cell prepareForReuse];
            return cell;
        }
    } else {
        ReuseQueue<Cell *> *reuseQueue = [[ReuseQueue alloc] initWithClassName:@"Cell"];
        self.cellReuseQueues[identifier] = reuseQueue;
    }
    
    if ([identifier isEqualToString:self.blankCellReuseIdentifier]) {
        Cell *cell = [[BlankCell alloc] init];
        cell.reuseIdentifier = identifier;
        return cell;
    }
    if (self.cellClasses[identifier]) {
        Class clazz = self.cellClasses[identifier];
        id cell = [[clazz alloc] init];
        ((Cell *)cell).reuseIdentifier = identifier;
        return cell;
    }
    if (self.cellNibs[identifier]) {
        UINib *nib = self.cellNibs[identifier];
        Cell *cell = (Cell *)[nib instantiateWithOwner:nil options:nil].firstObject;
        if (cell) {
            cell.reuseIdentifier = identifier;
            return cell;
        }
    }
    assert("could not dequeue a view with identifier cell - must register a nib or a class for the identifier");
    return nil;
}

-(void)resetTouchHandlersToScrollViews:(NSArray<ScrollView*>*)scrollViews
{
    for (ScrollView *scrollView in scrollViews) {
        if (self.dataSource) {
            scrollView.touchesBegan = ^(NSSet<UITouch*>* touches, UIEvent *event){
                [self touchesBegan:touches withEvent:event];
            };
            scrollView.touchesEnded = ^(NSSet<UITouch*>* touches, UIEvent *event){
                [self touchesEnded:touches withEvent:event];
            };
            scrollView.touchesCancelled = ^(NSSet<UITouch*>* touches, UIEvent *event){
                [self touchesCancelled:touches withEvent:event];
            };
        }else{
            scrollView.touchesBegan = nil;
            scrollView.touchesEnded = nil;
            scrollView.touchesCancelled = nil;
        }
    }
}

-(void)scrollToHorizontalCenter
{
    self.rowHeaderView->state.contentOffset.x = self.centerOffset.x;
    self.tableView->state.contentOffset.x = self.centerOffset.x;
}

-(void)scrollToVerticalCenter
{
    self.rowHeaderView->state.contentOffset.y = self.centerOffset.y;
    self.tableView->state.contentOffset.y = self.centerOffset.y;
}

-(void)recenterHorizontallyIfNecessary
{
    CGPoint currentOffset = self.tableView->state.contentOffset;
    CGFloat distance = currentOffset.x - self.centerOffset.x;
    CGFloat threshold = self.tableView->state.contentSize.width / 4;
    if (fabs(distance) > threshold) {
        if(distance > 0) {
            self.rowHeaderView->state.contentOffset.x = distance;
            self.tableView->state.contentOffset.x = distance;
        } else {
            CGFloat offset = self.centerOffset.x + (self.centerOffset.x - threshold);
            self.rowHeaderView->state.contentOffset.x = offset;
            self.tableView->state.contentOffset.x = offset;
        }
    }
}

-(void)recenterVerticallyIfNecessary
{
    CGPoint currentOffset = self.tableView->state.contentOffset;
    CGFloat distance = currentOffset.y - self.centerOffset.y;
    CGFloat threshold = self.tableView->state.contentSize.height / 4;
    if (fabs(distance) > threshold) {
        if(distance > 0) {
            self.rowHeaderView->state.contentOffset.y = distance;
            self.tableView->state.contentOffset.y = distance;
        } else {
            CGFloat offset = self.centerOffset.y + (self.centerOffset.y - threshold);
            self.rowHeaderView->state.contentOffset.y = offset;
            self.tableView->state.contentOffset.y = offset;
        }
    }
}

-(ScaleFactor)determineCircularScrollScalingFactor
{
    return ScaleFactorMake([self determineHorizontalCircularScrollScalingFactor], [self determineVerticalCircularScrollScalingFactor]);
}

-(NSInteger)determineHorizontalCircularScrollScalingFactor
{
    if (!(self->circularScrollingOptions.direction & DirectionHorizontally)) {
        return 1;
    }
    NSInteger scalingFactor = 3;
    return scalingFactor;
}

-(NSInteger)determineVerticalCircularScrollScalingFactor
{
    if (!(self->circularScrollingOptions.direction & DirectionVertically)) {
        return 1;
    }
    NSInteger scalingFactor = 3;
    return scalingFactor;
}

-(NSInteger)findIndexInRecords:(NSArray<NSNumber*>*)records forOffset:(CGFloat)offset
{
    NSInteger index = [records insertionIndexOfElement:[NSNumber numberWithFloat:offset] usingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2){
        if (obj1.floatValue == obj2.floatValue) {
            return NSOrderedSame;
        }else if(obj1.floatValue < obj2.floatValue){
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    return index == 0 ? 0 : index - 1;
}

-(void)scrollToItemAt:(NSIndexPath*)indexPath atScrollPosition:(NSUInteger)scrollPosition animated:(BOOL)animated
{
    CGPoint contentOffset = [self contentOffsetForScrollingToItemAt:indexPath atScrollPosition:scrollPosition];
    [self.tableView setContentOffset:contentOffset animated:animated];
}

-(void)scrollToItemAt:(NSIndexPath*)indexPath animated:(BOOL)animated
{
    CGPoint contentOffset = [self contentOffsetForScrollingToItemAt:indexPath ];
    [self.tableView setContentOffset:contentOffset animated:animated];
}

-(CGPoint)contentOffsetForScrollingToItemAt:(NSIndexPath *)indexPath atScrollPosition:(ScrollPosition)scrollPosition{
    NSInteger column = indexPath.column;
    NSInteger row = indexPath.row;
    
    if (column < self.numberOfColumns && row < self.numberOfRows){} else {
        NSString *errorMessage = [NSString stringWithFormat:@"attempt to scroll to invalid index path: {column = %li, row = %li}",column,row];
        assert(errorMessage);
    }
    NSArray<NSNumber*> *columnRecords = [self.columnHeaderView.columnRecords arrayByAddingObjectsFromArray:self.tableView.columnRecords];
    NSArray<NSNumber*> *rowRecords = [self.rowHeaderView.rowRecords arrayByAddingObjectsFromArray:self.tableView.rowRecords];
    CGPoint contentOffset = CGPointMake(columnRecords[column].floatValue, rowRecords[row].floatValue);
    
    CGFloat width;
    CGFloat height;
    
    CellRange *mergedCell = [self mergedCellForIndexPath:[[Location alloc] initWithIndexPath:indexPath]];
    if (mergedCell) {
        width = self.intercellSpacing.width;
        for (NSInteger column=mergedCell.from.column; column<=mergedCell.to.column; column++) {
            width += self.layoutProperties.columnWidthCache[column].floatValue;
        }
        height = self.intercellSpacing.height;
        for (NSInteger row=mergedCell.from.row; row<=mergedCell.to.row; row++) {
            height += self.layoutProperties.rowHeightCache[row].floatValue;
        }
    }else{
        width = self.layoutProperties.columnWidthCache[indexPath.column].floatValue;
        height = self.layoutProperties.rowHeightCache[indexPath.row].floatValue;
    }
    
    if (self->circularScrollingOptions.direction & DirectionHorizontally) {
        if (contentOffset.x > self.centerOffset.x) {
            contentOffset.x -= self.centerOffset.x;
        }else{
            contentOffset.x += self.centerOffset.x;
        }
    }
    
    NSInteger horizontalGroupCount = 0;
    if (scrollPosition & ScrollPositionleft) {
        horizontalGroupCount += 1;
    }
    if (scrollPosition & ScrollPositionCenteredHorizontally) {
        horizontalGroupCount += 1;
        contentOffset.x = MAX(self.tableView.contentOffset.x+ (contentOffset.x-(self.tableView.contentOffset.x+(self.tableView.frame.size.width - (width+self.intercellSpacing.width*2)) / 2)),0);
    }
    if (scrollPosition & ScrollPositionRight) {
        horizontalGroupCount += 1;
        contentOffset.x = MAX(contentOffset.x - self.tableView.frame.size.width + width + self.intercellSpacing.width * 2, 0);
    }
    
    if (self->circularScrollingOptions.direction & DirectionVertically) {
        if (contentOffset.y > self.centerOffset.y) {
            contentOffset.y -= self.centerOffset.y;
        }else{
            contentOffset.y += self.centerOffset.y;
        }
    }
    
    NSInteger verticalGroupCount = 0;
    if (scrollPosition & ScrollPositionTop) {
        verticalGroupCount += 1;
    }
    if (scrollPosition & ScrollPositionCenteredVertically) {
        verticalGroupCount += 1;
        contentOffset.y = MAX(self.tableView.contentOffset.y+ contentOffset.y-(self.tableView.contentOffset.y+(self.tableView.frame.size.height - (height+self.intercellSpacing.height*2)) / 2),0);
    }
    if (scrollPosition & ScrollPositionBottom) {
        verticalGroupCount += 1;
        contentOffset.y = MAX(contentOffset.y - self.tableView.frame.size.height + height + self.intercellSpacing.height * 2, 0);
    }
    
    CGFloat distanceFromRightEdge = self.tableView.contentSize.width - contentOffset.x;
    if (distanceFromRightEdge < self.tableView.frame.size.width) {
        contentOffset.x -= self.tableView.frame.size.width - distanceFromRightEdge;
    }
    CGFloat distanceFromBottomEdge = self.tableView.contentSize.height - contentOffset.y;
    if (distanceFromBottomEdge < self.tableView.frame.size.height) {
        contentOffset.y -= self.tableView.frame.size.height - distanceFromBottomEdge;
    }
    
    if (horizontalGroupCount > 1) {
        assert("attempt to use a scroll position with multiple horizontal positioning styles");
    }
    if (verticalGroupCount > 1) {
        assert("attempt to use a scroll position with multiple vertical positioning styles");
    }
    
    if (contentOffset.x < 0) {
        contentOffset.x = 0;
    }
    if (contentOffset.y < 0) {
        contentOffset.y = 0;
    }
    
    return contentOffset;
}

-(CGPoint)contentOffsetForScrollingToItemAt:(NSIndexPath *)indexPath
{
    NSInteger column = indexPath.column;
    NSInteger row = indexPath.row;
    
    if (column < self.numberOfColumns && row < self.numberOfRows){} else {
        NSString *errorMessage = [NSString stringWithFormat:@"attempt to scroll to invalid index path: {column = %li, row = %li}",column,row];
        assert(errorMessage);
    }
    NSArray<NSNumber*> *columnRecords = [self.columnHeaderView.columnRecords arrayByAddingObjectsFromArray:self.tableView.columnRecords];
    NSArray<NSNumber*> *rowRecords = [self.rowHeaderView.rowRecords arrayByAddingObjectsFromArray:self.tableView.rowRecords];
    CGPoint contentOffset = CGPointMake(columnRecords[column].floatValue, rowRecords[row].floatValue);
    
    CGFloat width;
    CGFloat height;
    
    CellRange *mergedCell = [self mergedCellForIndexPath:[[Location alloc] initWithIndexPath:indexPath]];
    if (mergedCell) {
        width = self.intercellSpacing.width;
        for (NSInteger column=mergedCell.from.column; column<=mergedCell.to.column; column++) {
            width += self.layoutProperties.columnWidthCache[column].floatValue;
        }
        height = self.intercellSpacing.height;
        for (NSInteger row=mergedCell.from.row; row<=mergedCell.to.row; row++) {
            height += self.layoutProperties.rowHeightCache[row].floatValue;
        }
    }else{
        width = self.layoutProperties.columnWidthCache[indexPath.column].floatValue;
        height = self.layoutProperties.rowHeightCache[indexPath.row].floatValue;
    }
    
    CGFloat distanceFromRightEdge = self.tableView.contentSize.width - contentOffset.x;
    if (distanceFromRightEdge < self.tableView.frame.size.width) {
        contentOffset.x -= self.tableView.frame.size.width - distanceFromRightEdge;
    }
    CGFloat distanceFromBottomEdge = self.tableView.contentSize.height - contentOffset.y;
    if (distanceFromBottomEdge < self.tableView.frame.size.height) {
        contentOffset.y -= self.tableView.frame.size.height - distanceFromBottomEdge;
    }
    
    if (contentOffset.x < 0) {
        contentOffset.x = 0;
    }
    if (contentOffset.y < 0) {
        contentOffset.y = 0;
    }
    
    return contentOffset;
}

-(void)selectItemAt:(NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(NSUInteger)scrollPosition
{
    if (indexPath){} else {
        [self deselectAllItems:animated];
        return;
    }
    
    if (self.allowsSelection){} else {
        return;
    }
    
    if (!self.allowsMultipleSelection) {
        [self.selectedIndexPaths removeObject:indexPath];
        [self deselectAllItems:animated];
    }
    
    [self.selectedIndexPaths addObject:indexPath];
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        if (ScrollPositionIsValid(scrollPosition)) {
            [self scrollToItemAt:indexPath atScrollPosition:scrollPosition animated:animated];
            if (animated) {
                self.pendingSelectionIndexPath = indexPath;
                return;
            }
        }
        NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
        for (Cell *cell in cells) {
            [cell setSelected:YES animated:animated];
        }
    }
}

-(void)deselectItemAt:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
    for (Cell *cell in cells) {
        [cell setSelected:NO animated:animated];
    }
    [self.selectedIndexPaths removeObject:indexPath];
}

-(void)deselectAllItems:(BOOL)animated
{
    for(NSIndexPath *indexPath in self.selectedIndexPaths) {
        [self deselectItemAt:indexPath animated:animated];
    }
}

-(NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point
{
    NSInteger row = 0;
    NSInteger column = 0;
    
    if (CGRectContainsPoint([self.tableView convertRect:self.tableView.bounds toView:self], point)
            && [self indexPathForItemAt:point inView:self.tableView]) {
        NSIndexPath *indexPath = [self indexPathForItemAt:point inView:self.tableView];
        row = indexPath.row + self.frozenRows;
        column = indexPath.column + self.frozenColumns;
    }else if (CGRectContainsPoint([self.rowHeaderView convertRect:self.rowHeaderView.bounds toView:self], point)
              && [self indexPathForItemAt:point inView:self.rowHeaderView]) {
        NSIndexPath *indexPath = [self indexPathForItemAt:point inView:self.rowHeaderView];
        row = indexPath.row;
        column = indexPath.column + self.frozenColumns;
    }else if (CGRectContainsPoint([self.columnHeaderView convertRect:self.columnHeaderView.bounds toView:self], point)
              && [self indexPathForItemAt:point inView:self.columnHeaderView]) {
        NSIndexPath *indexPath = [self indexPathForItemAt:point inView:self.columnHeaderView];
        row = indexPath.row + self.frozenRows;
        column = indexPath.column;
    }else if (CGRectContainsPoint([self.cornerView convertRect:self.cornerView.bounds toView:self], point)
              && [self indexPathForItemAt:point inView:self.cornerView]) {
        NSIndexPath *indexPath = [self indexPathForItemAt:point inView:self.cornerView];
        row = indexPath.row;
        column = indexPath.column;
    }else {
        return nil;
    }
    
    row = row % self.numberOfRows;
    column = column % self.numberOfColumns;
    
    Location *location = [[Location alloc] initWithRow:row column:column];
    CellRange *mergedCell = [self mergedCellForIndexPath:location];
    if(mergedCell){
        return [NSIndexPath indexPathForRow:mergedCell.from.row column:mergedCell.from.column];
    }
    return [NSIndexPath indexPathForRow:row column:column];
}

-(NSIndexPath *)indexPathForItemAt:(CGPoint)location inView:(ScrollView *)scrollView
{
    CGFloat insetX = scrollView->layoutAttributes.insets.x;
    CGFloat insetY = scrollView->layoutAttributes.insets.y;
    
    BOOL (^isPointInColumn)(CGFloat, NSInteger) = ^BOOL(CGFloat x, NSInteger column){
        if (column < scrollView.columnRecords.count){} else {
            return NO;
        }
        
        CGFloat minX = scrollView.columnRecords[column].floatValue + self.intercellSpacing.width;
        CGFloat maxX = minX + self.layoutProperties.columnWidthCache[(column+scrollView->layoutAttributes.startColumn) % self.numberOfColumns].floatValue;
        return (x >= minX && x <= maxX);
    };
    
    BOOL (^isPointInRow)(CGFloat, NSInteger) = ^BOOL(CGFloat y, NSInteger row){
        if (row < scrollView.rowRecords.count){} else {
            return NO;
        }
        
        CGFloat minY = scrollView.rowRecords[row].floatValue + self.intercellSpacing.height;
        CGFloat maxY = minY + self.layoutProperties.rowHeightCache[(row+scrollView->layoutAttributes.startRow) % self.numberOfRows].floatValue;
        return (y >= minY && y <= maxY);
    };
    
    CGPoint point = [self convertPoint:location toView:scrollView];
    NSInteger column = [self findIndexInRecords:scrollView.columnRecords forOffset:(point.x - insetX)];
    NSInteger row = [self findIndexInRecords:scrollView.rowRecords forOffset:(point.y - insetY)];
    
    BOOL isInColumn = isPointInColumn(point.x-insetX,column);
    BOOL isInRow = isPointInRow(point.y,row);
    if (isInColumn == YES && isInRow == YES) {
        return [NSIndexPath indexPathForRow:row column:column];
    } else if (isInColumn == YES && isInRow == NO) {
        if (isPointInRow(point.y-insetY,row+1)) {
            return [NSIndexPath indexPathForRow:row+1 column:column];
        }
    }else if (isInColumn == NO && isInRow == YES) {
        if (isPointInColumn(point.x-insetX,column+1)) {
            return [NSIndexPath indexPathForRow:row column:column+1];
        }
    }else if (isInColumn == NO && isInRow == NO) {
        if (isPointInColumn(point.x-insetX,column+1) && isPointInRow(point.y-insetY,row+1)) {
            return [NSIndexPath indexPathForRow:row+1 column:column+1];
        }
    }
    return nil;
}

-(NSArray<Cell*> *)visibleCells
{
    NSArray<Cell*> *cells = [[[[NSArray arrayWithArray:self.columnHeaderView.visibleCells.allObjects] arrayByAddingObjectsFromArray:self.rowHeaderView.visibleCells.allObjects] arrayByAddingObjectsFromArray:self.cornerView.visibleCells.allObjects] arrayByAddingObjectsFromArray:self.tableView.visibleCells.allObjects];
    return cells;
}

-(NSArray<NSIndexPath*>*)indexPathsForVisibleItems
{
    NSArray<Cell*> *cells = self.visibleCells;
    NSMutableArray<NSIndexPath*>* indexPaths= [[NSMutableArray alloc] init];
    for (Cell *cell in cells) {
        [indexPaths addObject:cell.indexPath];
    }
    return indexPaths;
}

-(Cell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block Cell *returnCell = nil;
    [self.tableView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            if (cell) {
                returnCell = cell;
                returnCell.indexPath = indexPath;
                *stop = YES;
            }
        }
    }];
    if (returnCell) {
        return returnCell;
    }
    [self.rowHeaderView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            if (cell) {
                returnCell = cell;
                *stop = YES;
            }
        }
    }];
    if (returnCell) {
        return returnCell;
    }
    [self.columnHeaderView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            if (cell) {
                returnCell = cell;
                *stop = YES;
            }
        }
    }];
    if (returnCell) {
        return returnCell;
    }
    [self.cornerView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            if (cell) {
                returnCell = cell;
                *stop = YES;
            }
        }
    }];
    if (returnCell) {
        return returnCell;
    }
    return nil;
}

-(NSArray<Cell*> *)cellsForItemAt:(NSIndexPath *)indexPath
{
    NSMutableArray<Cell*> *cells = [[NSMutableArray alloc] init];
    [self.tableView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            [cells addObject:cell];
        }
    }];
    [self.rowHeaderView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            [cells addObject:cell];
        }
    }];
    [self.columnHeaderView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            [cells addObject:cell];
        }
    }];
    [self.cornerView.visibleCells.pairs enumerateKeysAndObjectsUsingBlock:^(SPAddress *address, Cell *cell, BOOL* stop){
        if (address.row == indexPath.row && address.column == indexPath.column) {
            [cells addObject:cell];
        }
    }];
    return cells;
}

-(CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.column >= 0 && indexPath.column < self.numberOfColumns && indexPath.row >= 0 && indexPath.row < self.numberOfRows){}else {
        return CGRectZero;
    }
    
    NSArray<NSNumber*> *columnRecords = [self.columnHeaderView.columnRecords arrayByAddingObjectsFromArray:self.tableView.columnRecords];
    NSArray<NSNumber*> *rowRecords = [self.rowHeaderView.rowRecords arrayByAddingObjectsFromArray:self.tableView.rowRecords];
    
    CGPoint origin;
    CGSize size;
    CGPoint (^originFor)(NSInteger, NSInteger) = ^(NSInteger column, NSInteger row){
        CGFloat x = columnRecords[column].floatValue + (column >= self.frozenColumns ? self.tableView.frame.origin.x : 0) + self.intercellSpacing.width;
        CGFloat y = rowRecords[row].floatValue + (row >= self.frozenRows ? self.tableView.frame.origin.y : 0) + self.intercellSpacing.height;
        return CGPointMake(x, y);
    };
    
    CellRange *mergedCell = [self mergedCellForIndexPath:[[Location alloc] initWithRow:indexPath.row column:indexPath.column]];
    if (mergedCell) {
        origin = originFor(mergedCell.from.column,mergedCell.from.row);
        CGFloat width = 0;
        CGFloat height = 0;
        for (NSInteger column=mergedCell.from.column; column <= mergedCell.to.column; column++) {
            width += self.layoutProperties.columnWidthCache[column].floatValue;
        }
        for (NSInteger row=mergedCell.from.row; row <= mergedCell.to.row; row++) {
            height += self.layoutProperties.rowHeightCache[row].floatValue;
        }
        size = CGSizeMake(width + self.intercellSpacing.width * (mergedCell.columnCount - 1), height + self.intercellSpacing.height * (mergedCell.rowCount - 1));
    }else{
        origin = originFor(indexPath.column,indexPath.row);
        CGFloat width = self.layoutProperties.columnWidthCache[indexPath.column].floatValue;
        CGFloat height = self.layoutProperties.rowHeightCache[indexPath.row].floatValue;
        size = CGSizeMake(width, height);
    }
    
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

-(CellRange *)mergedCellForIndexPath:(Location*)indexPath {
    return self.layoutProperties.mergedCellLayouts[indexPath];
}

-(CGPoint)calculateCenterOffset
{
    CGPoint centerOffset = CGPointZero;
    if (self->circularScrollingOptions.direction & DirectionHorizontally) {
        for (NSInteger column=0; column < self.layoutProperties.numberOfColumns;column++) {
            centerOffset.x += self.layoutProperties.columnWidthCache[(column % self.numberOfColumns)].floatValue + self.intercellSpacing.width;
        }
        if (self->circularScrollingOptions.tableStyle & ColumnHeaderNotRepeated) {
            for (NSInteger column=0; column < self.layoutProperties.frozenColumns; column++) {
                centerOffset.x -= self.layoutProperties.columnWidthCache[column].floatValue;
            }
            centerOffset.x -=  self.intercellSpacing.width * self.layoutProperties.frozenColumns;
        }
        centerOffset.x *= (CGFloat)self.circularScrollScalingFactor.horizontal / 3;
    }
    if (self->circularScrollingOptions.direction & DirectionVertically) {
        for (NSInteger row=0; row < self.layoutProperties.numberOfRows;row++) {
            centerOffset.y += self.layoutProperties.rowHeightCache[(row % self.numberOfRows)].floatValue + self.intercellSpacing.height;
        }
        if (self->circularScrollingOptions.tableStyle & RowHeaderNotRepeated) {
            for (NSInteger row=0; row < self.layoutProperties.frozenRows; row++) {
                centerOffset.y -= self.layoutProperties.rowHeightCache[row].floatValue;
            }
            centerOffset.y -=  self.intercellSpacing.height * self.layoutProperties.frozenRows;
        }
        centerOffset.y *= (CGFloat)self.circularScrollScalingFactor.vertical / 3;
    }
    
    return centerOffset;
}

-(LayoutProperties *)resetLayoutProperties
{
    id <SpreadsheetViewDataSource> dataSource = self.dataSource;
    if (self.dataSource){}else {
        return [[LayoutProperties alloc] init];
    }
    NSInteger numberOfColumns = [dataSource numberOfColumnsInSpreadsheetView:self];
    NSInteger numberOfRows = [dataSource numberOfRowsInSpreadsheetView:self];
    
    NSInteger frozenColumns = 0;
    if ([dataSource respondsToSelector:@selector(frozenColumnsInSpreadsheetView:)]) {
        frozenColumns = [dataSource frozenColumnsInSpreadsheetView:self];
    }
    
    NSInteger frozenRows = 0;
    if ([dataSource respondsToSelector:@selector(frozenRowsInSpreadsheetView:)]) {
        frozenRows = [dataSource frozenRowsInSpreadsheetView:self];
    }
    
    if(numberOfColumns >= 0){} else {
        assert("`numberOfColumns(in:)` must return a value greater than or equal to 0");
    }
    if(numberOfRows >= 0){} else {
        assert("`numberOfRows(in:)` must return a value greater than or equal to 0");
    }
    if(frozenColumns <= numberOfColumns){} else {
        assert("`frozenColumns(in:) must return a value less than or equal to `numberOfColumns(in:)`");
    }
    if(frozenRows <= numberOfRows){} else {
        assert("`frozenRows(in:) must return a value less than or equal to `numberOfRows(in:)`");
    }

    NSArray<CellRange *> *mergedCells;
    NSMutableDictionary<Location*, CellRange*> *mergedCellLayouts;
    if ([dataSource respondsToSelector:@selector(mergedCellsInSpreadsheetView:)]) {
        mergedCells = [dataSource mergedCellsInSpreadsheetView:self];
        mergedCellLayouts = [[NSMutableDictionary alloc] init];
        for (CellRange *mergedCell in mergedCells) {
            if ((mergedCell.from.column < frozenColumns && mergedCell.to.column >= frozenColumns) || (mergedCell.from.row < frozenRows && mergedCell.to.row >= frozenRows)) {
                assert("cannot merge frozen and non-frozen column or rows");
            }
            for (NSInteger column=mergedCell.from.column;column <= mergedCell.to.column;column++) {
                for (NSInteger row=mergedCell.from.row;row<=mergedCell.to.row;row++) {
                    if(column < numberOfColumns && row < numberOfRows){} else {
                        assert("the range of `mergedCell` cannot exceed the total column or row count");
                    }
                    Location* location = [[Location alloc] initWithRow:row column:column];
                    if (mergedCellLayouts[location]) {
                        if([mergedCellLayouts[location] containsCellRange:mergedCell]) {
                            continue;
                        }
                        if ([mergedCell containsCellRange:mergedCellLayouts[location]]) {
                            mergedCellLayouts[location] = nil;
                        } else {
                            assert("cannot merge cells in a range that overlap existing merged cells");
                        }
                    }
                    mergedCell->size = CGSizeZero;
                    mergedCellLayouts[location] = mergedCell;
                }
            }
        }
        
    }
    NSMutableArray<NSNumber *> *columnWidthCache = [[NSMutableArray alloc] init];
    CGFloat frozenColumnWidth = 0;
    for(NSInteger column = 0; column<frozenColumns;column++) {
        CGFloat width = [dataSource spreadsheetView:self widthForColumn:column];
        [columnWidthCache addObject:[NSNumber numberWithFloat:width]];
        frozenColumnWidth += width;
    }
    CGFloat tableWidth = 0;
    for(NSInteger column = frozenColumns;column<numberOfColumns;column++ ){
        CGFloat width = [dataSource spreadsheetView:self widthForColumn:column];
        [columnWidthCache addObject:[NSNumber numberWithFloat:width]];
        tableWidth += width;
    }
    CGFloat columnWidth = frozenColumnWidth + tableWidth;
    
    NSMutableArray<NSNumber *> *rowHeightCache = [[NSMutableArray alloc] init];
    CGFloat frozenRowHeight = 0;
    for(NSInteger row = 0; row<frozenRows;row++) {
        CGFloat height = [dataSource spreadsheetView:self heightForRow:row];
        [rowHeightCache addObject:[NSNumber numberWithFloat:height]];
        frozenRowHeight += height;
    }
    CGFloat tableHeight = 0;
    for(NSInteger row = frozenRows;row<numberOfRows;row++) {
        CGFloat height = [dataSource spreadsheetView:self heightForRow:row];
        [rowHeightCache addObject:[NSNumber numberWithFloat:height]];
        tableHeight += height;
    }
    CGFloat rowHeight = frozenRowHeight + tableHeight;
    
    return [LayoutProperties initWithNumberOfColumns:numberOfColumns numberOfRows:numberOfRows frozenColumns:frozenColumns frozenRows:frozenRows frozenColumnWidth:frozenColumnWidth frozenRowHeight:frozenRowHeight columnWidth:columnWidth rowHeight:rowHeight columnWidthCache:columnWidthCache rowHeightCache:rowHeightCache mergedCells:mergedCells mergedCellLayouts:mergedCellLayouts];
}

-(LayoutAttributes)layoutAttributeForCornerView
{
    LayoutAttributes la;
    la.startColumn = 0;
    la.startRow = 0;
    la.numberOfColumns = self.frozenColumns;
    la.numberOfRows = self.frozenRows;
    la.columnCount = self.frozenColumns;
    la.rowCount = self.frozenRows;
    la.insets = CGPointZero;
    return la;
}

-(LayoutAttributes)layoutAttributeForColumnHeaderView
{
    CGFloat y = self.intercellSpacing.height * self.layoutProperties.frozenRows;
    for (int i=0; i<self.frozenRows; i++) {
        y += self.layoutProperties.rowHeightCache[i].floatValue;
    }
    CGPoint insets = (self->circularScrollingOptions.headerStyle == ColumnHeaderStartsFirstRow) ?CGPointMake(0, y):CGPointZero;
    LayoutAttributes la;
    la.startColumn = 0;
    la.startRow = self.layoutProperties.frozenRows;
    la.numberOfColumns = self.layoutProperties.frozenColumns;
    la.numberOfRows = self.layoutProperties.numberOfRows;
    la.columnCount = self.layoutProperties.frozenColumns;
    la.rowCount = self.layoutProperties.numberOfRows * self.circularScrollScalingFactor.vertical;
    la.insets = insets;
    return la;
}

-(LayoutAttributes)layoutAttributeForRowHeaderView
{
    CGFloat x = self.intercellSpacing.width * self.layoutProperties.frozenColumns;
    for (int i=0; i<self.frozenColumns; i++) {
        x += self.layoutProperties.columnWidthCache[i].floatValue;
    }
    CGPoint insets = (self->circularScrollingOptions.headerStyle == RowHeaderStartsFirstColumn) ?CGPointMake(x, 0):CGPointZero;
    LayoutAttributes la;
    la.startColumn = self.layoutProperties.frozenColumns;
    la.startRow = 0;
    la.numberOfColumns = self.layoutProperties.numberOfColumns;
    la.numberOfRows = self.layoutProperties.frozenRows;
    la.columnCount = self.layoutProperties.numberOfColumns * self.circularScrollScalingFactor.horizontal ;
    la.rowCount = self.layoutProperties.frozenRows;
    la.insets = insets;
    return la;
}

-(LayoutAttributes)layoutAttributeForTableView {
    LayoutAttributes la;
    la.startColumn = self.layoutProperties.frozenColumns;
    la.startRow = self.layoutProperties.frozenRows;
    la.numberOfColumns = self.layoutProperties.numberOfColumns;
    la.numberOfRows = self.layoutProperties.numberOfRows;
    la.columnCount = self.layoutProperties.numberOfColumns * self.circularScrollScalingFactor.horizontal ;
    la.rowCount = self.layoutProperties.numberOfRows * self.circularScrollScalingFactor.vertical;
    la.insets = CGPointZero;
    return la;
}

-(void)resetContentSizeOf:(ScrollView*)scrollView {
    
    [scrollView.columnRecords removeAllObjects];
    [scrollView.rowRecords removeAllObjects];
    
    NSInteger startColumn = scrollView->layoutAttributes.startColumn;
    NSInteger columnCount = scrollView->layoutAttributes.columnCount;
    CGFloat width = 0;
    for(NSInteger column = startColumn; column<columnCount; column++) {
        [scrollView.columnRecords addObject:[NSNumber numberWithFloat:width]];
        NSInteger index = column % self.numberOfColumns;
        if(!(self->circularScrollingOptions.tableStyle & ColumnHeaderNotRepeated) || index >= startColumn) {
            width += self.layoutProperties.columnWidthCache[index].floatValue + self.intercellSpacing.width;
        }
    }
    
    NSInteger startRow = scrollView->layoutAttributes.startRow;
    NSInteger rowCount = scrollView->layoutAttributes.rowCount;
    CGFloat height = 0;
    for(NSInteger row = startRow; row<rowCount; row++) {
        [scrollView.rowRecords addObject:[NSNumber numberWithFloat:height]];
        NSInteger index = row % self.numberOfRows;
        if (!(self->circularScrollingOptions.tableStyle & RowHeaderNotRepeated)  || index >= startRow) {
            height += self.layoutProperties.rowHeightCache[index].floatValue + self.intercellSpacing.height;
        }
    }
    
    scrollView->state.contentSize = CGSizeMake(width + self.intercellSpacing.width, height + self.intercellSpacing.height);
    
    scrollView.contentSize = scrollView->state.contentSize;
}

-(void)resetScrollViewFrame
{
    UIEdgeInsets contentInset;
    contentInset = self.rootView.adjustedContentInset;
    CGFloat horizontalInset = contentInset.left + contentInset.right;
    CGFloat verticalInset = contentInset.top + contentInset.bottom;
    
    self.cornerView->state.frame = CGRectMake(0, 0, self.cornerView->state.contentSize.width, self.cornerView->state.contentSize.height);
    self.columnHeaderView->state.frame = CGRectMake(0, 0, self.columnHeaderView->state.contentSize.width, self.frame.size.height);
    self.rowHeaderView->state.frame = CGRectMake(0, 0, self.frame.size.width, self.rowHeaderView->state.contentSize.height);
    self.tableView->state.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    
    if(self.frozenColumns > 0) {
        self.tableView->state.frame.origin.x = self.columnHeaderView->state.frame.size.width - self.intercellSpacing.width;
        self.tableView->state.frame.size.width = (self.frame.size.width - horizontalInset) - (self.columnHeaderView->state.frame.size.width - self.intercellSpacing.width);
        
        if (self->circularScrollingOptions.headerStyle != RowHeaderStartsFirstColumn) {
            self.rowHeaderView->state.frame.origin.x = self.tableView->state.frame.origin.x;
            self.rowHeaderView->state.frame.size.width = self.tableView->state.frame.size.width;
        }
    } else {
        self.tableView->state.frame.size.width = self.frame.size.width - horizontalInset;
    }
    
    if(self.frozenRows > 0) {
        self.tableView->state.frame.origin.y = self.rowHeaderView->state.frame.size.height - self.intercellSpacing.height;
        self.tableView->state.frame.size.height = (self.frame.size.height - verticalInset) - (self.rowHeaderView->state.frame.size.height - self.intercellSpacing.height);
        
        if(self->circularScrollingOptions.headerStyle != ColumnHeaderStartsFirstRow) {
            self.columnHeaderView->state.frame.origin.y = self.tableView->state.frame.origin.y;
            self.columnHeaderView->state.frame.size.height = self.tableView->state.frame.size.height;
        }
    } else {
        self.tableView->state.frame.size.height = self.frame.size.height - verticalInset;
    }
    
    [self resetOverlayViewContentSize:contentInset];
    
    self.cornerView.frame = self.cornerView->state.frame;
    self.columnHeaderView.frame = self.columnHeaderView->state.frame;
    self.rowHeaderView.frame = self.rowHeaderView->state.frame;
    self.tableView.frame = self.tableView->state.frame;
}

-(void)resetOverlayViewContentSize:(UIEdgeInsets)contentInset {
    CGFloat width = contentInset.left + contentInset.right + self.tableView->state.frame.origin.x + self.tableView->state.contentSize.width;
    CGFloat height = contentInset.top + contentInset.bottom + self.tableView->state.frame.origin.y + self.tableView->state.contentSize.height;
    self.overlayView.contentSize = CGSizeMake(width, height);
    self.overlayView.contentOffset = CGPointMake(self.tableView->state.contentOffset.x - contentInset.left,self.tableView->state.contentOffset.y - contentInset.top);
}

-(void)resetScrollViewArrangement {
    [self.tableView removeFromSuperview];
    [self.columnHeaderView removeFromSuperview];
    [self.rowHeaderView removeFromSuperview];
    [self.cornerView removeFromSuperview];
    if (self->circularScrollingOptions.headerStyle == ColumnHeaderStartsFirstRow) {
        [self.rootView addSubview:self.tableView];
        [self.rootView addSubview:self.rowHeaderView];
        [self.rootView addSubview:self.columnHeaderView];
        [self.rootView addSubview:self.cornerView];
    } else {
        [self.rootView addSubview:self.tableView];
        [self.rootView addSubview:self.columnHeaderView ];
        [self.rootView addSubview:self.rowHeaderView];
        [self.rootView addSubview:self.cornerView];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.currentTouch == nil){}else {
        return;
    }
    self.currentTouch = [touches.allObjects firstObject];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self unhighlightAllItems];
    [self highlightItemsOnTouches:touches];
    
    UITouch *touch = touches.allObjects.firstObject;
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:[touch locationInView:self]];
    Cell *cell = [self cellForItemAtIndexPath:indexPath];
    if (!self.allowsMultipleSelection && touch && indexPath && cell && cell.isUserInteractionEnabled) {
        for (NSIndexPath *selectedIndexPath in self.selectedIndexPaths) {
            NSArray<Cell*> *cells = [self cellsForItemAt:selectedIndexPath];
            for (Cell *cell in cells) {
                cell.selected = NO;
            }
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.allObjects.firstObject == self.currentTouch){}else {
        return;
    }
    NSSet<NSIndexPath*> *highlightedItems = [self.highlightedIndexPaths copy];
    [self unhighlightAllItems];
    
    UITouch *touch = touches.allObjects.firstObject;
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:[touch locationInView:self]];
    Cell *cell = [self cellForItemAtIndexPath:indexPath];
    if (self.allowsMultipleSelection && touch && indexPath && cell && cell.isUserInteractionEnabled && [self.selectedIndexPaths containsObject:indexPath]) {
        if ([self.delegate respondsToSelector:@selector(spreadsheetView:shouldDeselectItemAt:)]) {
            if ([self.delegate spreadsheetView:self shouldDeselectItemAt:indexPath]) {
                [self deselectItemAtIndexPath:indexPath];
            }
        }
    }else{
        [self selectItemsOnTouches:touches highlightedItems:highlightedItems];
    }
    
    [self performSelector:@selector(clearCurrentTouch) withObject:nil afterDelay:0];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self unhighlightAllItems];
    [self performSelector:@selector(restorePreviousSelection) withObject:touches afterDelay:0];
    [self performSelector:@selector(clearCurrentTouch) withObject:nil afterDelay:0];
}

-(void)highlightItemsOnTouches:(NSSet<UITouch*> *)touches
{
    if (self.allowsSelection){} else {
        return;
    }
    UITouch *touch = [touches.allObjects firstObject];
    if (touch) {
        NSIndexPath *indexPath = [self indexPathForItemAtPoint:[touch locationInView:self]];
        if (indexPath){}else {
            return;
        }
        Cell *cell = [self cellForItemAtIndexPath:indexPath];
        if (cell && cell.isUserInteractionEnabled){}else {
            return;
        }
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(spreadsheetView:shouldHighlightItemAt:)]) {
                if ([self.delegate spreadsheetView:self shouldHighlightItemAt:indexPath]) {
                    [self.highlightedIndexPaths addObject:indexPath];
                    NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
                    for (Cell *cell in cells) {
                        cell.highlighted = YES;
                    }
                    if (self.delegate) {
                        [self.delegate spreadsheetView:self didHighlightItemAt:indexPath];
                    }
                }
            }
        }
    }
}

-(void)unhighlightAllItems
{
    for (NSIndexPath *indexPath in self.highlightedIndexPaths) {
        NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
        for (Cell *cell in cells) {
            cell.highlighted = NO;
        }
        if (self.delegate) {
            [self.delegate spreadsheetView:self didUnhighlightItemAt:indexPath];
        }
    }
    [self.highlightedIndexPaths removeAllObjects];
}

-(void)selectItemsOnTouches:(NSSet<UITouch*>*)touches highlightedItems:(NSSet<NSIndexPath*>*)highlightedItems
{
    if(self.allowsSelection){} else {
        return;
    }
    UITouch *touch = touches.allObjects.firstObject;
    if (touch) {
        NSIndexPath *indexPath = [self indexPathForItemAtPoint:[touch locationInView:self]];
        if (indexPath && [highlightedItems containsObject:indexPath]) {
            [self selectItemAtIndexPath:indexPath];
        }
    }
}

-(void)selectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
    if ([self.delegate respondsToSelector:@selector(spreadsheetView:shouldSelectItemAt:)]) {
        if (cells.count>0 && [self.delegate spreadsheetView:self shouldSelectItemAt:indexPath]) {
            if (!self.allowsMultipleSelection) {
                [self.selectedIndexPaths removeObject:indexPath];
                [self deselectAllItems];
            }
            for (Cell *cell in cells) {
                cell.selected = YES;
            }
            if (self.delegate) {
                [self.delegate spreadsheetView:self didSelectItemAt:indexPath];
                [self.selectedIndexPaths addObject:indexPath];
            }
        }
    }
}

-(void)deselectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
    for (Cell *cell in cells) {
        cell.selected = NO;
    }
    if (self.delegate) {
        [self.delegate spreadsheetView:self didDeselectItemAt:indexPath];
        [self.selectedIndexPaths removeObject:indexPath];
    }
}

-(void)deselectAllItems
{
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        [self deselectItemAtIndexPath:indexPath];
    }
}

-(void)restorePreviousSelection
{
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
        for (Cell *cell in cells) {
            cell.selected = YES;
        }
    }
}

-(void)clearCurrentTouch
{
    self.currentTouch = nil;
}

-(NSInteger)numberOfColumns
{
    return self.layoutProperties.numberOfColumns;
}

-(NSInteger)numberOfRows
{
    return self.layoutProperties.numberOfRows;
}

-(NSInteger)frozenColumns
{
    return self.layoutProperties.frozenColumns;
}

-(NSInteger)frozenRows
{
    return self.layoutProperties.frozenRows;
}

-(NSArray<CellRange*>*)mergedCells
{
    return self.layoutProperties.mergedCells;
}

-(UIScrollView*)scrollView
{
    return self.overlayView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.delegate = nil;
    self.columnHeaderView.delegate = nil;
    self.rowHeaderView.delegate = nil;
    self.cornerView.delegate = nil;
    
    self.cornerView->state.frame = self.cornerView.frame;
    self.columnHeaderView->state.frame = self.columnHeaderView.frame;
    self.rowHeaderView->state.frame = self.rowHeaderView.frame;
    self.tableView->state.frame = self.tableView.frame;
    
    self.cornerView->state.contentSize = self.cornerView.contentSize;
    self.columnHeaderView->state.contentSize = self.columnHeaderView.contentSize;
    self.rowHeaderView->state.contentSize = self.rowHeaderView.contentSize;
    self.tableView->state.contentSize = self.tableView.contentSize;
    
    self.cornerView->state.contentOffset = self.cornerView.contentOffset;
    self.columnHeaderView->state.contentOffset = self.columnHeaderView.contentOffset;
    self.rowHeaderView->state.contentOffset = self.rowHeaderView.contentOffset;
    self.tableView->state.contentOffset = self.tableView.contentOffset;
    
    [self reloadDataIfNeeded];
    
    if(self.numberOfColumns > 0 && self.numberOfRows > 0){} else {
        return;
    }
    
    if (self->circularScrollingOptions.direction & DirectionHorizontally) {
        [self recenterHorizontallyIfNecessary];
    }
    if (self->circularScrollingOptions.direction & DirectionVertically) {
        [self recenterVerticallyIfNecessary];
    }
    
    [self layoutCornerView];
    [self layoutRowHeaderView];
    [self layoutColumnHeaderView];
    [self layoutTableView];
    
    self.cornerView.contentSize = self.cornerView->state.contentSize;
    self.columnHeaderView.contentSize = self.columnHeaderView->state.contentSize;
    self.rowHeaderView.contentSize = self.rowHeaderView->state.contentSize;
    self.tableView.contentSize = self.tableView->state.contentSize;
    
    self.cornerView.contentOffset = self.cornerView->state.contentOffset;
    self.columnHeaderView.contentOffset = self.columnHeaderView->state.contentOffset;
    self.rowHeaderView.contentOffset = self.rowHeaderView->state.contentOffset;
    self.tableView.contentOffset = self.tableView->state.contentOffset;
    
    self.tableView.delegate = self;
    self.columnHeaderView.delegate = self;
    self.rowHeaderView.delegate = self;
    self.cornerView.delegate = self;
}

-(void)layout:(ScrollView*)scrollView
{
    LayoutEngine *layoutEngine = [[LayoutEngine alloc] init];
    [layoutEngine setSpreadsheetView:self scrollView:scrollView];
    [layoutEngine layout];
}

-(void)layoutCornerView
{
    if(self.frozenColumns > 0 && self.frozenRows > 0 && self->circularScrollingOptions.headerStyle == HeaderStyleNone){} else {
        self.cornerView.hidden = YES;
        return;
    }
    self.cornerView.hidden = NO;
    [self layout:self.cornerView];
}

-(void)layoutColumnHeaderView
{
    if(self.frozenColumns > 0){} else {
        self.columnHeaderView.hidden = YES;
        return;
    }
    self.columnHeaderView.hidden = NO;
    [self layout:self.columnHeaderView];
}

-(void)layoutRowHeaderView
{
    if(self.frozenRows > 0){} else {
        self.rowHeaderView.hidden = YES;
        return;
    }
    self.rowHeaderView.hidden = NO;
    [self layout:self.rowHeaderView];
}

-(void)layoutTableView
{
    [self layout:self.tableView];
}

-(void)flashScrollIndicators
{
    [self.overlayView flashScrollIndicators];
}

-(void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [self.tableView setContentOffset:contentOffset animated:animated];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    self.rowHeaderView.delegate = nil;
    self.columnHeaderView.delegate = nil;
    self.tableView.delegate = nil;
    
    if (self.tableView.contentOffset.x < 0 && !self.stickyColumnHeader) {
        CGFloat offset = self.tableView.contentOffset.x * -1;
        CGRect frame = self.cornerView.frame;
        frame.origin.x = offset;
        self.cornerView.frame = frame;
        frame = self.columnHeaderView.frame;
        frame.origin.x = offset;
        self.columnHeaderView.frame = frame;
    } else {
        CGRect frame = self.cornerView.frame;
        frame.origin.x = 0;
        self.cornerView.frame = frame;
        frame = self.columnHeaderView.frame;
        frame.origin.x = 0;
        self.columnHeaderView.frame = frame;
    }
    if (self.tableView.contentOffset.y < 0 && !self.stickyRowHeader) {
        CGFloat offset = self.tableView.contentOffset.y * -1;
        CGRect frame = self.cornerView.frame;
        frame.origin.y = offset;
        self.cornerView.frame = frame;
        frame = self.rowHeaderView.frame;
        frame.origin.y = offset;
        self.rowHeaderView.frame = frame;
    } else {
        CGRect frame = self.cornerView.frame;
        frame.origin.y = 0;
        self.cornerView.frame = frame;
        frame = self.rowHeaderView.frame;
        frame.origin.y = 0;
        self.rowHeaderView.frame = frame;
    }
    CGPoint contentOffset = self.rowHeaderView.contentOffset;
    contentOffset.x = self.tableView.contentOffset.x;
    self.rowHeaderView.contentOffset = contentOffset;
    
    contentOffset = self.columnHeaderView.contentOffset;
    contentOffset.y = self.tableView.contentOffset.y;
    self.columnHeaderView.contentOffset = contentOffset;
    
    [self setNeedsLayout];
    
    self.rowHeaderView.delegate = self;
    self.columnHeaderView.delegate = self;
    self.tableView.delegate = self;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = self.pendingSelectionIndexPath;
    if(indexPath){}else {
        return;
    }
    NSArray<Cell*> *cells = [self cellsForItemAt:indexPath];
    for (Cell *cell in cells) {
        [cell setSelected:YES animated:YES];
    }
    [self.delegate spreadsheetView:self didSelectItemAt:indexPath];
    self.pendingSelectionIndexPath = nil;
}

-(void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:rect animated:animated];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return [super forwardingTargetForSelector:aSelector];
}

-(UIEdgeInsets)adjustedContentInset
{
    return self.rootView.adjustedContentInset;
}

-(BOOL)isKindOfClass:(Class)aClass
{
    return [super isKindOfClass:aClass];
}

#pragma mark - UIScrollView

-(void)setContentOffset:(CGPoint)contentOffset
{
    self.tableView.contentOffset = contentOffset;
}

-(CGPoint)contentOffset
{
    return self.tableView.contentOffset;
}

-(void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets
{
    self.overlayView.scrollIndicatorInsets = scrollIndicatorInsets;
}

-(UIEdgeInsets)scrollIndicatorInsets
{
    return self.overlayView.scrollIndicatorInsets;
}

-(CGSize)contentSize
{
    return self.rootView.contentSize;
}

-(void)setContentInset:(UIEdgeInsets)contentInset
{
    self.rootView.contentInset = contentInset;
    self.overlayView.contentInset = contentInset;
}

-(UIEdgeInsets)contentInset
{
    return self.rootView.contentInset;
}

#pragma mark - UIViewHierarchy

-(void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [self.overlayView insertSubview:view atIndex:index];
}

-(void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    [self.overlayView exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
}

-(void)addSubview:(UIView *)view
{
    [self.overlayView addSubview:view];
}

-(void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    [self.overlayView insertSubview:view belowSubview:siblingSubview];
}

-(void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    [self.overlayView insertSubview:view aboveSubview:siblingSubview];
}

-(void)bringSubviewToFront:(UIView *)view
{
    [self.overlayView bringSubviewToFront:view];
}

-(void)sendSubviewToBack:(UIView *)view
{
    [self.overlayView sendSubviewToBack:view];
}

- (void) safeAreaInsetsDidChange {
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        [super insertSubview:self.backgroundView atIndex:0];
    }
}

@end
