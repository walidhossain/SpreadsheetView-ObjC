//
//  ReusableCollection.h
//  SpreadsheetView-Obj-C
//
//  Created by Walid Hossain on 12/28/17.
//  Copyright © 2017 Walid Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAddress.h"

@interface ReusableCollection<__covariant ObjectType> : NSEnumerator

@property (nonatomic, strong) NSString *reusableClassName;
@property (nonatomic, strong) NSMutableSet<SPAddress *> *addresses;
@property (nonatomic, strong) NSMutableDictionary<SPAddress *,ObjectType> *pairs;

-(id)initWithClassName:(NSString *)reusableClassName;
-(BOOL)containsMember:(SPAddress *)address;
-(BOOL)insertMember:(SPAddress *)address;
-(void)minus:(NSSet<SPAddress *> *)otherAddresses;
- (nullable ObjectType)objectForKeyedSubscript:(id)key;
- (void)setObject:(nullable ObjectType)obj forKeyedSubscript:(id <NSCopying>)key;
-(NSInteger)count;
-(NSArray<ObjectType>*)allReusableObject;
@end
