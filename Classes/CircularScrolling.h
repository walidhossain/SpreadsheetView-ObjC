//
//  CircularScrolling.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/3/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CircularScrollingDirection) {
    
    DirectionVertically   = 1 << 0,
    DirectionHorizontally = 1 << 1,
    DirectionBoth         = DirectionVertically | DirectionHorizontally
    
};

typedef NS_OPTIONS(NSUInteger, CircularScrollingTableStyle) {
    
    ColumnHeaderNotRepeated   = 1 << 0,
    RowHeaderNotRepeated      = 1 << 1
    
};

typedef enum  {
    
    HeaderStyleNone=0,
    ColumnHeaderStartsFirstRow,
    RowHeaderStartsFirstColumn
    
} CircularScrollingHeaderStyle;

typedef NS_OPTIONS(NSUInteger, CircularScrollingConfigurationState) {
    
    None=0,
    Horizontally,
    HorizontallyColumnHeaderNotRepeated,
    HorizontallyRowHeaderStartsFirstColumn,
    HorizontallyColumnHeaderNotRepeatedRowHeaderStartsFirstColumn,
    Vertically,
    VerticallyRowHeaderNotRepeated,
    VerticallyColumnHeaderStartsFirstRow,
    VerticallyRowHeaderNotRepeatedColumnHeaderStartsFirstRow,
    Both,
    BothRowHeaderStartsFirstColumn,
    BothColumnHeaderStartsFirstRow,
    BothRowHeaderStartsFirstColumnRowHeaderNotRepeated,
    BothColumnHeaderStartsFirstRowColumnHeaderNotRepeated,
    BothColumnHeaderNotRepeated,
    BothColumnHeaderNotRepeatedRowHeaderStartsFirstColumn,
    BothColumnHeaderNotRepeatedColumnHeaderStartsFirstRow,
    BothColumnHeaderNotRepeatedRowHeaderNotRepeated,
    BothColumnHeaderNotRepeatedRowHeaderNotRepeatedRowHeaderStartsFirstColumn,
    BothColumnHeaderNotRepeatedRowHeaderNotRepeatedColumnHeaderStartsFirstRow,
    BothRowHeaderNotRepeated,
    BothRowHeaderNotRepeatedRowHeaderStartsFirstColumn,
    BothRowHeaderNotRepeatedColumnHeaderStartsFirstRow,
    BothRowHeaderNotRepeatedColumnHeaderNotRepeated,
    BothRowHeaderNotRepeatedColumnHeaderNotRepeatedRowHeaderStartsFirstColumn,
    BothRowHeaderNotRepeatedColumnHeaderNotRepeatedColumnHeaderStartsFirstRow
    
};

struct CircularScrollingConfigurationOptions{
    
    CircularScrollingDirection direction;
    CircularScrollingHeaderStyle headerStyle;
    CircularScrollingTableStyle tableStyle;
    
};

typedef struct CircularScrollingConfigurationOptions CircularScrollingConfigurationOptions;

struct ScaleFactor {
    NSInteger horizontal;
    NSInteger vertical;
};
typedef struct ScaleFactor ScaleFactor;

ScaleFactor ScaleFactorMake(NSInteger horizontal, NSInteger vertical);

@interface CircularScrolling : NSObject

@end
