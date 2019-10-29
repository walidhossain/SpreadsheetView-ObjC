//
//  ReusableCollection.m
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/28/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import "ReusableCollection.h"

@interface ReusableCollection(){
    
    NSUInteger _currentIndex;
}

@end

@implementation ReusableCollection

-(id)initWithClassName:(NSString *)reusableClassName
{
    self = [super init];
    if (self) {
        self.reusableClassName = reusableClassName;
        self.pairs = [[NSMutableDictionary alloc] init];
        self.addresses = [[NSMutableSet alloc] init];
        _currentIndex = 0;
    }
    return self;
}

-(BOOL)containsMember:(SPAddress *)address
{
    return [self.addresses containsObject:address];
}

-(BOOL)insertMember:(SPAddress *)address
{
    if ([self containsMember:address]) {
        return NO;
    }else{
        [self.addresses addObject:address];
        return [self containsMember:address];
    }
}

-(void)minus:(NSSet<SPAddress *> *)otherAddresses
{
    [self.addresses minusSet:otherAddresses];
}

- (id)objectForKeyedSubscript:(SPAddress *)key {
    return self.pairs[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(SPAddress *)key {
    if (obj) {
        self.pairs[key] = obj;
    }
}

- (id)nextObject
{
    if (_currentIndex >= self.addresses.allObjects.count)
        return nil;
    
    return self.addresses.allObjects[_currentIndex++];
}

- (ReusableCollection*)enumerator
{
    return self;
}

-(NSInteger)count
{
    return self.addresses.count;
}

-(NSArray<id>*)allReusableObject
{
    NSMutableArray *reusableObjects = [[NSMutableArray alloc] init];
    for (SPAddress *address in self.addresses) {
        [reusableObjects addObject:self.pairs[address]];
    }
    return reusableObjects;
}

@end
