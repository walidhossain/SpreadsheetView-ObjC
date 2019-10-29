//
//  Borders.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BorderStyle.h"

@interface Borders : NSObject

@property (nonatomic, strong) BorderStyle *top;
@property (nonatomic, strong) BorderStyle *bottom;
@property (nonatomic, strong) BorderStyle *left;
@property (nonatomic, strong) BorderStyle *right;

+(Borders *)all:(BorderStyle *)style;

@end
