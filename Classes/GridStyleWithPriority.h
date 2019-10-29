//
//  GridStyleWithPriority.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/11/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridStyleWithPriority : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong)   UIColor *color;
@property (nonatomic, assign) CGFloat priority;

@end
