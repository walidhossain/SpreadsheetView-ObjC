//
//  SPAddress.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/27/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAddress : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger columnIndex;

-(id)initWithRow:(NSInteger)row column:(NSInteger)column rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex;

@end
