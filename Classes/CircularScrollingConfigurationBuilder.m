//
//  CircularScrollingConfigurationBuilder.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/3/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import "CircularScrollingConfigurationBuilder.h"

@interface CircularScrollingConfigurationBuilder ()

@property (nonatomic) CircularScrollingConfigurationState state;

@end

@implementation CircularScrollingConfigurationBuilder

-(id)initWithState:(CircularScrollingConfigurationState)state
{
    self = [super init];
    if (self) {
        self.state = state;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"direction: %@,tableStyle: %@,headerStyle: %@",self.descriptionOfDirection,self.descriptionOfTableStyle,self.descriptionOfHeaderStyle];
}

-(NSString *)debugDescription
{
    return self.description;
}

-(CircularScrollingConfigurationOptions)options
{
    CircularScrollingConfigurationOptions options;
    
    switch (self.state) {
        case None:
            options.headerStyle = HeaderStyleNone;
            break;
        case Horizontally:
            options.direction   = DirectionHorizontally;
            options.headerStyle = HeaderStyleNone;
            break;
        case HorizontallyRowHeaderStartsFirstColumn:
            options.direction   = DirectionHorizontally;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case HorizontallyColumnHeaderNotRepeated:
            options.direction   = DirectionHorizontally;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case HorizontallyColumnHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionHorizontally;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case Vertically:
            options.direction   = DirectionVertically;
            options.headerStyle = HeaderStyleNone;
            break;
        case VerticallyColumnHeaderStartsFirstRow:
            options.direction   = DirectionVertically;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case VerticallyRowHeaderNotRepeated:
            options.direction   = DirectionVertically;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case VerticallyRowHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionHorizontally;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case Both:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            break;
        case BothRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case BothColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case BothRowHeaderStartsFirstColumnRowHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderStartsFirstRowColumnHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        default:
            options.headerStyle = HeaderStyleNone;
            break;
    }
    
    return options;
}

-(NSString *)descriptionOfDirection
{
    NSMutableString *description = [[NSMutableString alloc] init];
    if (self.options.direction & DirectionVertically) {
        [description appendString:@".Vertically"];
    }
    if (self.options.direction & DirectionHorizontally) {
        [description appendString:@".Horizontally"];
    }
    
    return description;
}

-(NSString *)descriptionOfTableStyle
{
    NSMutableString *description = [[NSMutableString alloc] init];
    if (self.options.tableStyle & ColumnHeaderNotRepeated) {
        [description appendString:@".ColumnHeaderNotRepeated"];
    }
    if (self.options.tableStyle & RowHeaderNotRepeated) {
        [description appendString:@".RowHeaderNotRepeated"];
    }
    
    return description;
}

-(NSString *)descriptionOfHeaderStyle
{
    switch (self.options.headerStyle) {
        case HeaderStyleNone:
            return @".None";
        case ColumnHeaderStartsFirstRow:
            return @".ColumnHeaderStartsFirstRow";
        case RowHeaderStartsFirstColumn:
            return @".RowHeaderStartsFirstColumn";
        default:
            return @"[]";
            break;
    }
}

+(CircularScrollingConfigurationOptions)optionsForState:(CircularScrollingConfigurationState)state
{
    CircularScrollingConfigurationOptions options;
    
    switch (state) {
        case None:
            options.headerStyle = HeaderStyleNone;
            break;
        case Horizontally:
            options.direction   = DirectionHorizontally;
            options.headerStyle = HeaderStyleNone;
            break;
        case HorizontallyRowHeaderStartsFirstColumn:
            options.direction   = DirectionHorizontally;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case HorizontallyColumnHeaderNotRepeated:
            options.direction   = DirectionHorizontally;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case HorizontallyColumnHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionHorizontally;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case Vertically:
            options.direction   = DirectionVertically;
            options.headerStyle = HeaderStyleNone;
            break;
        case VerticallyColumnHeaderStartsFirstRow:
            options.direction   = DirectionVertically;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case VerticallyRowHeaderNotRepeated:
            options.direction   = DirectionVertically;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case VerticallyRowHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionHorizontally;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case Both:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            break;
        case BothRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case BothColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case BothRowHeaderStartsFirstColumnRowHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderStartsFirstRowColumnHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothColumnHeaderNotRepeatedRowHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderNotRepeated:
            options.direction   = DirectionBoth;
            options.headerStyle = HeaderStyleNone;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderNotRepeatedRowHeaderStartsFirstColumn:
            options.direction   = DirectionBoth;
            options.headerStyle = RowHeaderStartsFirstColumn;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        case BothRowHeaderNotRepeatedColumnHeaderNotRepeatedColumnHeaderStartsFirstRow:
            options.direction   = DirectionBoth;
            options.headerStyle = ColumnHeaderStartsFirstRow;
            options.tableStyle  = ColumnHeaderNotRepeated|RowHeaderNotRepeated;
            break;
        default:
            options.headerStyle = HeaderStyleNone;
            break;
    }
    
    return options;
}

@end
