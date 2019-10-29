//
//  Gridline.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "Gridline.h"

@implementation Gridline

-(id)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}

-(id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self){
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    return self;
}

-(id<CAAction>)actionForKey:(NSString *)event
{
    return nil;
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    self.backgroundColor = color.CGColor;
}
@end
