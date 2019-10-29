//
//  Cell.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "Cell.h"

@implementation Cell

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

- (void)setup
{
    self.backgroundColor = UIColor.whiteColor;
    self.contentView = [[UIView alloc] init];
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
    [self insertSubview:self.contentView atIndex:0];
}

-(void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView) {
        [_backgroundView removeFromSuperview];
    }
    if (backgroundView) {
        _backgroundView = backgroundView;
        _backgroundView.frame = self.bounds;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
        [self insertSubview:_backgroundView atIndex:0];
    }
}

-(void)setSelectedBackgroundView:(UIView *)selectedBackgroundView
{
    if (_selectedBackgroundView) {
        [_backgroundView removeFromSuperview];
    }
    if (selectedBackgroundView) {
        _selectedBackgroundView = selectedBackgroundView;
        _selectedBackgroundView.frame = self.bounds;
        _selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight ;
        if (_backgroundView) {
            [self insertSubview:_selectedBackgroundView aboveSubview:_backgroundView];
        }else{
            [self insertSubview:_selectedBackgroundView atIndex:0];
        }
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    if (_selectedBackgroundView) {
        _selectedBackgroundView.alpha = _highlighted || _selected ? 1: 0;
    }
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_selectedBackgroundView) {
        _selectedBackgroundView.alpha = _selected ? 1: 0;
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:CATransaction.animationDuration animations:^{
            self.selected = selected;
        }];
    }else
    {
        self.selected = selected;
    }
}

-(BOOL)isSmallerThan:(Cell *)cell
{
    return [self.indexPath compare:cell.indexPath] == NSOrderedAscending;
}

-(BOOL)hasBorder
{
    if (self.borders) {
        return self.borders.top.borderStyle != BorderStyleTypeNone || self.borders.bottom.borderStyle != BorderStyleTypeNone || self.borders.left.borderStyle != BorderStyleTypeNone || self.borders.right.borderStyle != BorderStyleTypeNone;
    }
    return NO;
}

-(void)prepareForReuse
{
    
}

@end

@implementation BlankCell
@end
