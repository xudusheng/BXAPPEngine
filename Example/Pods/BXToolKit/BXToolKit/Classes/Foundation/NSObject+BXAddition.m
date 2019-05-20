//
//  NSObject+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "NSObject+BXAddition.h"
#include <objc/runtime.h>
#include <objc/objc-auto.h>

@implementation NSObject (BXAutoEncodeDecode)

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class cls = [self class];
    while (cls != [NSObject class]) {
        unsigned int numberOfIvars = 0;
        Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
        for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++) {
            Ivar const ivar = *p;
            const char *type = ivar_getTypeEncoding(ivar);
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [self valueForKey:key];
            if (value) {
                switch (type[0]) {
                    case _C_STRUCT_B: {
                        NSUInteger ivarSize = 0;
                        NSUInteger ivarAlignment = 0;
                        NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                        const char * bytes = CFBridgingRetain(self);
                        NSData *data = [NSData dataWithBytes:bytes + ivar_getOffset(ivar)
                                                      length:ivarSize];
                        CFRelease((__bridge CFTypeRef)(self));
                        [encoder encodeObject:data forKey:key];
                    }
                        break;
                    default:
                        [encoder encodeObject:value
                                       forKey:key];
                        break;
                }
            }
        }
        cls = class_getSuperclass(cls);
        free(ivars);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    // because NSObject dose not have 'super', use 'self' instead.
    // if u have better solutions, please contact me.
    self = [self init];
    
    if (self) {
        Class cls = [self class];
        while (cls != [NSObject
                       class]) {
            unsigned int numberOfIvars = 0;
            Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
            
            for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++) {
                Ivar const ivar = *p;
                const char *type = ivar_getTypeEncoding(ivar);
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                id value = [decoder decodeObjectForKey:key];
                if (value) {
                    switch (type[0]) {
                        case _C_STRUCT_B: {
                            NSUInteger ivarSize = 0;
                            NSUInteger ivarAlignment = 0;
                            NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                            NSData *data = [decoder decodeObjectForKey:key];
                            
                            char * bytes = (char *)CFBridgingRetain(self);
                            char *sourceIvarLocation = bytes+ ivar_getOffset(ivar);
                            CFRelease((__bridge CFTypeRef)(self));
                            [data getBytes:sourceIvarLocation length:ivarSize];
                            // I get a wierd problem in 10.1, after I retrieved bytes from data,
                            // the struct size did have value here. But when the object is
                            // returned, I logged the size of the object, it's (0, 0).
                            // If I added the memcpy function, it worked well, I did got the size(50, 30).
                            // But now I removed the memcpy, it worked too.
                            // I don't konw what happens here.
                            //                            memcpy((char *)self + ivar_getOffset(ivar), sourceIvarLocation, ivarSize);
                        }
                            break;
                        default:
                            [self setValue:[decoder decodeObjectForKey:key]
                                    forKey:key];
                            break;
                    }
                }
            }
            cls = class_getSuperclass(cls);
            free(ivars);
        }
    }
    
    return self;
}


@end

@implementation NSObject (BXPropertyListing)

- (NSDictionary *)propertyDictionary {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

@end

//================================
static const int block_key;
@interface BXNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);
- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation BXNSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    self.block(object, oldVal, newVal);
}

@end

//===================================
@implementation NSObject (BXBlockKVO)

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    BXNSObjectKVOBlockTarget *target = [[BXNSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self bx_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self bx_allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    [dic removeObjectForKey:keyPath];
}

- (void)removeObserverBlocks {
    NSMutableDictionary *dic = [self bx_allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}

- (NSMutableDictionary *)bx_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
