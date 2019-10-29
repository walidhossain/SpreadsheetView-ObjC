//
//  ReuseQueue.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/28/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReuseQueue<__covariant ObjectType> : NSObject

-(id)initWithClassName:(NSString *)reusableClassName;
-(void)enqueue:(ObjectType)reusableObject;
-(ObjectType)dequeue;
-(ObjectType)dequeueOrCreate;
@end
