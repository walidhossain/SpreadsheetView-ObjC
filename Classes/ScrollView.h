//
//  ScrollView.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/2/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
#import "Gridline.h"
#import "Border.h"
#import "LayoutEngine.h"
#import "ReusableCollection.h"

struct State{
    CGRect frame;
    CGSize contentSize;
    CGPoint contentOffset;
};

typedef struct State State;

State StateZero(void);

struct LayoutAttributes {
    NSInteger startColumn;
    NSInteger startRow;
    NSInteger numberOfColumns;
    NSInteger numberOfRows;
    NSInteger columnCount;
    NSInteger rowCount;
    CGPoint insets;
};

typedef struct LayoutAttributes LayoutAttributes;

typedef NS_OPTIONS(NSUInteger, ScrollPosition) {
    
    ScrollPositionTop                   = 1 << 1,//2
    ScrollPositionCenteredVertically    = 2 << 1,//4
    ScrollPositionBottom                = 3 << 1,//6
    
    ScrollPositionleft                  = 1 << 4,//16
    ScrollPositionCenteredHorizontally  = 2 << 4,//32
    ScrollPositionRight                 = 3 << 4 //48
    
};

BOOL ScrollPositionIsValid(ScrollPosition scrollPosition);

typedef void (^TouchHandler)(NSSet<UITouch*>* touches, UIEvent *event);

@interface ScrollView : UIScrollView <UIGestureRecognizerDelegate>{
    @public State state;
    @public LayoutAttributes layoutAttributes;
}

@property (nonatomic, strong) NSMutableArray<NSNumber*> *columnRecords;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *rowRecords;

@property (nonatomic, strong) ReusableCollection<Cell *> *visibleCells;
@property (nonatomic, strong) ReusableCollection<Gridline *> *visibleVerticalGridlines;
@property (nonatomic, strong) ReusableCollection<Gridline *> *visibleHorizontalGridlines;
@property (nonatomic, strong) ReusableCollection<Border *> *visibleBorders;

@property (nonatomic, copy) TouchHandler touchesBegan;
@property (nonatomic, copy) TouchHandler touchesEnded;
@property (nonatomic, copy) TouchHandler touchesCancelled;

@property (nonatomic, readonly) BOOL hasDisplayedContent;



-(void)resetReusableObjects;

@end
