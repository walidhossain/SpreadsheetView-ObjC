//
//  CircularScrollingConfiguration.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 1/5/18.
//  Copyright © 2018 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircularScrollingConfiguration : NSObject
{
    
}

+(CircularScrollingConfiguration *)none;
+(CircularScrollingConfiguration *)horizontally;
+(CircularScrollingConfiguration *)vertically;
+(CircularScrollingConfiguration *)both;

@end
