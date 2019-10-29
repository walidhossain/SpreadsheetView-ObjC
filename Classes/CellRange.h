//
//  CellRange.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/1/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "NSIndexPath+Column.h"

struct CellIndex{
    NSInteger row;
    NSInteger column;
};

typedef struct CellIndex CellIndex;

CellIndex CellIndexMake(NSInteger row, NSInteger column);

@interface CellRange : NSObject {
    @public CGSize size;
}

@property (nonatomic, readonly) Location *from;
@property (nonatomic, readonly) Location *to;

@property (nonatomic, readonly) NSInteger columnCount;
@property (nonatomic, readonly) NSInteger rowCount;

-(id) __unavailable init;
-(id)initWithLocation:(Location *)from to:(Location *)to;
-(id)initWithIndexPath:(NSIndexPath *)from to:(NSIndexPath *)to;
-(id)initFrom:(CellIndex)from to:(CellIndex)to;
-(BOOL)containsIndexPath:(NSIndexPath *)indexPath;
-(BOOL)containsCellRange:(CellRange *)cellRange;
@end
