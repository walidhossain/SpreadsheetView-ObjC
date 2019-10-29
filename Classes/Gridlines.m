//
//  Gridlines.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "Gridlines.h"

@implementation Gridlines

+(Gridlines *)all:(GridStyle *)style
{
    Gridlines *gridlines = [[Gridlines alloc] init];
    gridlines.top     = style;
    gridlines.bottom  = style;
    gridlines.left    = style;
    gridlines.right   = style;
    
    return gridlines;
}

@end
