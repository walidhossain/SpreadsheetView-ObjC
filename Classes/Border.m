//
//  Border.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "Border.h"

@implementation Border

-(id)init
{
    self = [super init];
    if (self)
    {
        BorderStyle *style = [[BorderStyle alloc] initWithBorderStyleTypeNone];
        self.borders = [Borders all:style];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        BorderStyle *style = [[BorderStyle alloc] initWithBorderStyleTypeNone];
        self.borders = [Borders all:style];
    }
    return self;
}

-(id)initWithBorders:(Borders*)borders hasBorder:(BOOL)hasBorder
{
    self = [super init];
    if (self)
    {
        self.borders = borders;
        self.hasBorders = hasBorder;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        return;
    }
    
    CGContextSetFillColorWithColor(context, UIColor.clearColor.CGColor);
    
    if (self.borders.left.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.left.width;
        CGContextMoveToPoint(context,  width * 0.5, 0);
        CGContextAddLineToPoint(context, width * 0.5, self.bounds.size.height);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, self.borders.left.color.CGColor);
        CGContextStrokePath(context);
    }
    
    if (self.borders.right.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.right.width;
        CGContextMoveToPoint(context,  self.bounds.size.width - width * 0.5, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width - width * 0.5, self.bounds.size.height);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, self.borders.right.color.CGColor);
        CGContextStrokePath(context);
    }
    
    if (self.borders.top.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.top.width;
        CGContextMoveToPoint(context,  0, width * 0.5);
        CGContextAddLineToPoint(context, self.bounds.size.width, width * 0.5);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, self.borders.top.color.CGColor);
        CGContextStrokePath(context);
    }
    
    if (self.borders.bottom.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.bottom.width;
        CGContextMoveToPoint(context, 0,  self.bounds.size.height - width * 0.5);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - width * 0.5);
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, self.borders.bottom.color.CGColor);
        CGContextStrokePath(context);
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.borders.left.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.left.width;
        
        CGPoint origin = self.frame.origin;
        origin.x -= width * 0.5;
        
        CGSize size = self.frame.size;
        size.width += width * 0.5;
        
        self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
    }
    
    if (self.borders.right.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.right.width;
        
        CGPoint origin = self.frame.origin;
        CGSize size = self.frame.size;
        size.width += width * 0.5;
        
        self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    }
    
    if (self.borders.top.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.top.width;
        
        CGPoint origin = self.frame.origin;
        origin.y -= width * 0.5;
        
        CGSize size = self.frame.size;
        size.height += width * 0.5;
        
        self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    }
    
    if (self.borders.bottom.borderStyle != BorderStyleTypeNone)
    {
        CGFloat width = self.borders.bottom.width;
        
        CGPoint origin = self.frame.origin;
        CGSize size = self.frame.size;
        size.height += width * 0.5;
        
        self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    }
}


@end
