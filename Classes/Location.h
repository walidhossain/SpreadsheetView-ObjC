//
//  Location.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSIndexPath+Column.h"

@interface Location : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

-(id)initWithIndexPath:(NSIndexPath *)indexPath;
-(id)initWithRow:(NSInteger)row column:(NSInteger)column;

@end
