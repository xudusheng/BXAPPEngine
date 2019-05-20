//
//  NSMutableArray+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "NSMutableArray+BXAddition.h"

@implementation NSMutableArray (BXAddition)
- (void)safeAddObject:(id)anObject {
    if (anObject != nil) {
        [self addObject:anObject];
    }else {
        NSLog(@"object could not nil");
    }
}
@end
