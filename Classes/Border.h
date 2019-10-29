//
//  Border.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Borders.h"

@interface Border : UIView

@property (nonatomic, strong) Borders *borders;
@property (nonatomic, assign) BOOL hasBorders;

-(id)initWithBorders:(Borders*)borders hasBorder:(BOOL)hasBorder;

@end
