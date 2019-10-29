//
//  CircularScrolling.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/3/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "CircularScrolling.h"

@implementation CircularScrolling

ScaleFactor ScaleFactorMake(NSInteger horizontal, NSInteger vertical)
{
    ScaleFactor sf; sf.horizontal = horizontal; sf.vertical = vertical; return sf;
}
@end
