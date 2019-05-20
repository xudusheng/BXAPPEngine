//
//  NSArray+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "NSArray+BXAddition.h"

@implementation NSArray (BXAddition)

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}


@end
