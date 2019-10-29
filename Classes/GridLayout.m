//
//  GridLayout.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/9/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout


-(instancetype)initWithGridWidth:(CGFloat)gridWidth gridColor:(UIColor*)gridColor origin:(CGPoint)origin length:(CGFloat)length edge:(RectEdge)edge priority:(CGFloat)priority
{
    self = [super init];
    if (self) {
        self.gridWidth = gridWidth;
        self.gridColor = gridColor;
        self.origin = origin;
        self.length = length;
        self.edge = edge;
        self.priority = priority;
    }
    return self;
}

RectEdge RectEdgeMake(CGFloat startWidth, CGFloat endWidth, RectEdgePosition position)
{
    RectEdge re; re.startWidth = startWidth; re.endWidth = endWidth; re.position=position; return re;
}
@end
