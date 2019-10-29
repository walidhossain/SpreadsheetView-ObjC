//
//  SpreadsheetView.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/3/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
#import "GridStyle.h"
#import "CellRange.h"
#import "CircularScrolling.h"
#import "CircularScrollingConfiguration.h"
#import "ReuseQueue.h"
#import "Gridline.h"
#import "Border.h"
#import "ScrollView.h"
#import "LayoutEngine.h"
#import "LayoutProperties.h"
#import "NSArray+BinarySearch.h"
#import "CircularScrollingConfigurationBuilder.h"

@class ScrollView;

@protocol SpreadsheetViewDataSource;
@protocol SpreadsheetViewDelegate;

@interface SpreadsheetView : UIView <UIScrollViewDelegate>
{
    @public CircularScrollingConfigurationOptions circularScrollingOptions;
}

@property (nonatomic, strong, nullable) id <SpreadsheetViewDataSource> dataSource;
@property (nonatomic, strong, nullable) id <SpreadsheetViewDelegate> delegate;
@property (nonatomic, assign) CGSize intercellSpacing;
@property (nonatomic, nonnull) GridStyle *gridStyle;
@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL scrollsToTop;
@property (nonatomic, strong) CircularScrollingConfiguration *circularScrolling;
@property (nonatomic, assign) ScaleFactor circularScrollScalingFactor;
@property (nonatomic, assign) CircularScrollingConfigurationOptions circularScrollingOptions;
@property (nonatomic, assign) CGPoint centerOffset;
@property (nonatomic, strong, nullable) UIView *backgroundView;
@property (nonatomic, strong) NSArray<Cell*>  *visibleCells;
@property (nonatomic, strong) NSArray<NSIndexPath*> *indexPathsForVisibleItems;
@property (nonatomic, strong) NSIndexPath *indexPathForSelectedItem;
@property (nonatomic, strong) NSArray<NSIndexPath*> *indexPathsForSelectedItems;
@property (nonatomic, getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) BOOL alwaysBounceVertical;
@property (nonatomic, assign) BOOL alwaysBounceHorizontal;
@property (nonatomic, assign) BOOL stickyRowHeader;
@property (nonatomic, assign) BOOL stickyColumnHeader;
@property (nonatomic, getter=isPagingEnabled) BOOL pagingEnabled;
@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign) UIScrollViewIndicatorStyle indicatorStyle;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, readonly) NSInteger numberOfColumns;
@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) NSInteger frozenColumns;
@property (nonatomic, readonly) NSInteger frozenRows;
@property (nonatomic, strong) NSArray<CellRange*> *mergedCells;
@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) LayoutProperties *layoutProperties;
@property (nonatomic, strong) UIScrollView *rootView;
@property (nonatomic, strong) UIScrollView *overlayView;

@property (nonatomic, strong) ScrollView *columnHeaderView;
@property (nonatomic, strong) ScrollView *rowHeaderView;
@property (nonatomic, strong) ScrollView *cornerView;
@property (nonatomic, strong) ScrollView *tableView;

@property (nonatomic, strong) NSMutableDictionary<NSString *,ReuseQueue<Cell *> *>  *cellReuseQueues;
@property (nonatomic, strong) NSString *blankCellReuseIdentifier;
@property (nonatomic, strong) ReuseQueue<Gridline *> *horizontalGridlineReuseQueue;
@property (nonatomic, strong) ReuseQueue<Gridline *> *verticalGridlineReuseQueue;
@property (nonatomic, strong) ReuseQueue<Border *> *borderReuseQueue;

@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *highlightedIndexPaths;
@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *selectedIndexPaths;
@property (nonatomic, strong) NSIndexPath* pendingSelectionIndexPath;
@property (nonatomic, strong) UITouch *currentTouch;

@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, assign) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) UIEdgeInsets adjustedContentInset;

-(void)registerCellClass:(Class)class forCellWithReuseIdentifier:(NSString *)identifier;
-(void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

-(NSInteger)findIndexInRecords:(NSArray<NSNumber*>*)records forOffset:(CGFloat)offset;
-(CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath;
-(CellRange *)mergedCellForIndexPath:(Location*)indexPath;
-(Cell*)dequeueReusableCellWithReuseIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath;
-(void)reloadData;
-(void)flashScrollIndicators;
-(void)selectItemAt:(NSIndexPath*)indexPath animated:(BOOL)animated scrollPosition:(NSUInteger)scrollPosition;
-(void)scrollToItemAt:(NSIndexPath*)indexPath atScrollPosition:(NSUInteger)scrollPosition animated:(BOOL)animated;
-(void)scrollToItemAt:(NSIndexPath*)indexPath animated:(BOOL)animated;
-(Cell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol SpreadsheetViewDataSource<NSObject>

@required
-(NSUInteger)numberOfColumnsInSpreadsheetView:(SpreadsheetView *)spreadsheetView;
-(NSUInteger)numberOfRowsInSpreadsheetView:(SpreadsheetView *)spreadsheetView;
-(CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSUInteger)column;
-(CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSUInteger)row;
-(Cell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath;

@optional
-(NSArray<CellRange *> *)mergedCellsInSpreadsheetView:(SpreadsheetView *)spreadsheetView;
-(NSUInteger)frozenColumnsInSpreadsheetView:(SpreadsheetView *)spreadsheetView;
-(NSUInteger)frozenRowsInSpreadsheetView:(SpreadsheetView *)spreadsheetView;

@end

@protocol SpreadsheetViewDelegate<NSObject>

@optional
-(BOOL)spreadsheetView:(SpreadsheetView *)spreadsheetView shouldHighlightItemAt:(NSIndexPath *)indexPath;
-(void)spreadsheetView:(SpreadsheetView *)spreadsheetView didHighlightItemAt:(NSIndexPath *)indexPath;
-(void)spreadsheetView:(SpreadsheetView *)spreadsheetView didUnhighlightItemAt:(NSIndexPath *)indexPath;
-(BOOL)spreadsheetView:(SpreadsheetView *)spreadsheetView shouldSelectItemAt:(NSIndexPath *)indexPath;
-(BOOL)spreadsheetView:(SpreadsheetView *)spreadsheetView shouldDeselectItemAt:(NSIndexPath *)indexPath;
-(void)spreadsheetView:(SpreadsheetView *)spreadsheetView didSelectItemAt:(NSIndexPath *)indexPath;
-(void)spreadsheetView:(SpreadsheetView *)spreadsheetView didDeselectItemAt:(NSIndexPath *)indexPath;
@end
