//
//  Cell.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSIndexPath+Column.h"
#import "Borders.h"
#import "Gridlines.h"

@interface Cell : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) Borders *borders;
@property (nonatomic, strong) Gridlines *gridlines;
@property (nonatomic, assign, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, readonly) BOOL hasBorder;

-(BOOL)isSmallerThan:(Cell *)cell;
-(void)setSelected:(BOOL)selected animated:(BOOL)animated;
-(void)prepareForReuse;

@end

@interface BlankCell : Cell

@end
