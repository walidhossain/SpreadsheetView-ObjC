//
//  NSIndexPath+Column.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (Column)

+ (instancetype)indexPathForRow:(NSInteger)row column:(NSInteger)column;
- (NSInteger)column;

@end
