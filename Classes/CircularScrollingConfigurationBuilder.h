//
//  CircularScrollingConfigurationBuilder.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/3/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircularScrolling.h"
#import "CircularScrollingConfiguration.h"

@interface CircularScrollingConfigurationBuilder : NSObject

-(id) __unavailable init;
-(id)initWithState:(CircularScrollingConfigurationState)state;
-(CircularScrollingConfigurationOptions)options;
+(CircularScrollingConfigurationOptions)optionsForState:(CircularScrollingConfigurationState)state;
@end
