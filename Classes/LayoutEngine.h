//
//  LayoutEngine.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/8/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpreadsheetView.h"
#import "ScrollView.h"
#import "SPAddress.h"
#import "LayoutProperties.h"
#import "Gridlines.h"

@class SpreadsheetView;
@class ScrollView;

BOOL CGSizeIsNull(CGSize size);

@interface LayoutEngine : NSObject

-(void)setSpreadsheetView:(SpreadsheetView *)spreadsheetView scrollView:(ScrollView *)scrollView;
-(void)layout;

@end
