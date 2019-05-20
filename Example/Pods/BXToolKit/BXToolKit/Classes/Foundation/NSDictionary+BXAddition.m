//
//  NSDictionary+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "NSDictionary+BXAddition.h"

@implementation NSDictionary (BXAddition)

- (id)safeObjectForKey:(id)aKey {
    if (aKey) {
        return [self objectForKey:aKey];
    }else {
        NSLog(@"key could not set nil");
        return nil;
    }
}

@end
