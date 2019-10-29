//
//  GridLayout.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/9/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    Top = 0,
    Bottom,
    Left,
    Right
} RectEdgePosition;

struct RectEdge{
    CGFloat startWidth;
    CGFloat endWidth;
    RectEdgePosition position;
};
typedef struct RectEdge RectEdge;

RectEdge RectEdgeMake(CGFloat startWidth, CGFloat endWidth, RectEdgePosition position);

@interface GridLayout : NSObject


@property (nonatomic, assign) CGFloat gridWidth;
@property (nonatomic, strong) UIColor *gridColor;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) RectEdge edge;
@property (nonatomic, assign) CGFloat priority;

-(instancetype)initWithGridWidth:(CGFloat)gridWidth gridColor:(UIColor*)gridColor origin:(CGPoint)origin length:(CGFloat)length edge:(RectEdge)edge priority:(CGFloat)priority;

@end
