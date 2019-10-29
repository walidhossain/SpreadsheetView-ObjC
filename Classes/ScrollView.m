//
//  ScrollView.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/2/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.columnRecords = [[NSMutableArray alloc] init];
        self.rowRecords = [[NSMutableArray alloc] init];
        self.visibleCells = [[ReusableCollection alloc] initWithClassName:@"Cell"];
        self.visibleVerticalGridlines = [[ReusableCollection alloc] initWithClassName:@"Gridline"];
        self.visibleHorizontalGridlines = [[ReusableCollection alloc] initWithClassName:@"Gridline"];
        self.visibleBorders = [[ReusableCollection alloc] initWithClassName:@"Border"];
        self->state = StateZero();
        self->layoutAttributes.startColumn = 0;
        self->layoutAttributes.startRow = 0;
        self->layoutAttributes.numberOfColumns = 0;
        self->layoutAttributes.numberOfRows = 0;
        self->layoutAttributes.columnCount = 0;
        self->layoutAttributes.rowCount = 0;
        self->layoutAttributes.insets = CGPointZero;
    }
    return self;
}

-(BOOL)hasDisplayedContent
{
    return self.columnRecords.count > 0 || self.rowRecords.count > 0;
}

-(void)resetReusableObjects
{
    for (SPAddress *address in self.visibleCells) {
        Cell *cell = self.visibleCells[address];
        [cell removeFromSuperview];
    }
    
    for (SPAddress *address in self.visibleVerticalGridlines) {
        Gridline *gridline = self.visibleVerticalGridlines[address];
        [gridline removeFromSuperlayer];
    }
    
    for (SPAddress *address in self.visibleHorizontalGridlines) {
        Gridline *gridline = self.visibleHorizontalGridlines[address];
        [gridline removeFromSuperlayer];
    }
    
    for (SPAddress *address in self.visibleBorders) {
        Border *border  = self.visibleBorders[address];
        [border removeFromSuperview];
    }
    
    self.visibleCells = [[ReusableCollection alloc] initWithClassName:@"Cell"];
    self.visibleVerticalGridlines = [[ReusableCollection alloc] initWithClassName:@"Gridline"];
    self.visibleHorizontalGridlines = [[ReusableCollection alloc] initWithClassName:@"Gridline"];
    self.visibleBorders = [[ReusableCollection alloc] initWithClassName:@"Border"];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWith:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    return result;
}

-(BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return self.hasDisplayedContent;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.hasDisplayedContent){}else {
        return;
    }
    self.touchesBegan(touches, event);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.hasDisplayedContent){}else {
        return;
    }
    self.touchesEnded(touches, event);
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.hasDisplayedContent){}else {
        return;
    }
    self.touchesCancelled(touches, event);
}

BOOL ScrollPositionIsValid(ScrollPosition scrollPosition)
{
    return scrollPosition>=2 && scrollPosition <=54;
}

State StateZero()
{
    State state;
    state.frame = CGRectZero;
    state.contentSize = CGSizeZero;
    state.contentOffset = CGPointZero;
    return state;
}

-(NSString*)debugDescription
{
    return [NSString stringWithFormat:@"%@\n\n%li",[super debugDescription],self.visibleCells.allObjects.count];
}

@end
