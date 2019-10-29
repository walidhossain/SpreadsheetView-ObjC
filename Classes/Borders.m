//
//  Borders.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "Borders.h"

@implementation Borders

+(Borders *)all:(BorderStyle *)style
{
    Borders *borders = [[Borders alloc] init];
    borders.top     = style;
    borders.bottom  = style;
    borders.left    = style;
    borders.right   = style;
    
    return borders;
}
@end
