//
//  BorderStyle.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "BorderStyle.h"

@implementation BorderStyle

-(id)initWithBorderStyleTypeNone
{
    self = [super init];
    if (self) {
        self.borderStyle = BorderStyleTypeNone;
    }
    return self;
}

-(id)initWithBorderWidth:(CGFloat)width color:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.borderStyle = BorderStyleTypeSolid;
        self.width = width;
        self.color = color;
    }
    return self;
}

-(BOOL)isEqual:(id)object
{
    if (self.borderStyle == BorderStyleTypeNone && ((BorderStyle *) object).borderStyle == BorderStyleTypeNone) {
        return YES;
    }else if (self.borderStyle == BorderStyleTypeSolid && ((BorderStyle *) object).borderStyle == BorderStyleTypeSolid) {
        return self.width == ((BorderStyle *) object).width && [self.color isEqual:((BorderStyle *) object).color] ;
    }else {
        return NO;
    }
}

@end
