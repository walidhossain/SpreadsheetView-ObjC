//
//  BorderStyle.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    BorderStyleTypeNone = 0,
    BorderStyleTypeSolid
} BorderStyleType;

@interface BorderStyle : NSObject

@property (nonatomic, assign) BorderStyleType borderStyle;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong)   UIColor *color;

-(id) __unavailable init;
-(id)initWithBorderStyleTypeNone;
-(id)initWithBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
