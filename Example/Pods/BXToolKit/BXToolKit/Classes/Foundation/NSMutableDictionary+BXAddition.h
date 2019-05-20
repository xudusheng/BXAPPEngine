//
//  NSMutableDictionary+BXAddition.h
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (BXAddition)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

