//
//  NSMutableDictionary+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "NSMutableDictionary+BXAddition.h"

@implementation NSMutableDictionary (BXAddition)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }else {
        NSLog(@"key or object could not set nil");
    }
}

@end
