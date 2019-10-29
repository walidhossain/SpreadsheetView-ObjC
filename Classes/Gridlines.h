//
//  Gridlines.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridStyle.h"

@interface Gridlines : NSObject

@property (nonatomic, strong) GridStyle *top;
@property (nonatomic, strong) GridStyle *bottom;
@property (nonatomic, strong) GridStyle *left;
@property (nonatomic, strong) GridStyle *right;

+(Gridlines *)all:(GridStyle*)style;
@end
