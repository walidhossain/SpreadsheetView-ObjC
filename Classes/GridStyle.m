//
//  GridStyle.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "GridStyle.h"

@implementation GridStyle


-(instancetype)initWithWidth:(CGFloat)width color:(UIColor*)color
{
    self = [super init];
    if (self) {
        self.width = width;
        self.color = color;
        self.gridStyle = GridStyleTypeSolid;
    }
    return self;
}

-(BOOL)isEqual:(id)object
{
    if (self.gridStyle == GridStyleTypeNone && ((GridStyle *) object).gridStyle == GridStyleTypeNone) {
        return YES;
    }else if (self.gridStyle == GridStyleTypeSolid && ((GridStyle *) object).gridStyle == GridStyleTypeSolid) {
        return self.width == ((GridStyle *) object).width && [self.color isEqual:((GridStyle *) object).color] ;
    }else {
        return NO;
    }
}
@end
