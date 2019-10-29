//
//  ReuseQueue.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/28/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import "ReuseQueue.h"

@interface ReuseQueue<__covariant Reusable>()
@property (nonatomic, strong) NSString *reusableClassName;
@property (nonatomic, strong) NSMutableSet<Reusable> *reusableObjects;

@end

@implementation ReuseQueue

-(id)initWithClassName:(NSString *)reusableClassName
{
    self = [super init];
    if (self) {
        self.reusableObjects = [[NSMutableSet alloc] init];
        self.reusableClassName = reusableClassName;
    }
    return self;
}

-(void)enqueue:(id)reusableObject
{
    [self.reusableObjects addObject:reusableObject];
}

-(id)dequeue
{
    id firstObject = [self.reusableObjects.allObjects firstObject];
    if (firstObject) {
        [self.reusableObjects removeObject:firstObject];
    }
    return firstObject;
}

-(id)dequeueOrCreate
{
    id firstObject = [self.reusableObjects.allObjects firstObject];
    if (firstObject) {
        [self.reusableObjects removeObject:firstObject];
    }
    return [[NSClassFromString(self.reusableClassName) alloc] init];
}
@end
