//
//  GridStyle.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    GridStyleTypeStandard = 0,
    GridStyleTypeNone,
    GridStyleTypeSolid
} GridStyleType;

@interface GridStyle : NSObject

@property (nonatomic, assign) GridStyleType gridStyle;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;

-(instancetype)initWithWidth:(CGFloat)width color:(UIColor*)color;

@end
