//
//  XDSBaseManager.m
//
//  Copyright (c) 2014 xudusheng. All rights reserved.
//

#import "BXBaseManager.h"

static NSDictionary *managerMap = nil;
static NSString * managerMappingFile = nil;
@implementation BXBaseManager

+ (BXBaseManager *)sharedManager
{
    static BXBaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self instanceClass] alloc] init];
    });
    return sharedInstance;
}

+ (void)readManagerMappingFile:(NSString *)fileName
{
    managerMappingFile = fileName;
}

+ (Class)instanceClass{
    [BXBaseManager initManagerMap];

    if (self.superclass == NSObject.class) {
        return self.class;
    }
    
    NSString * key = [self configForCurrentClass];
    
    if (!key) {
        Class class = [[self superclass] instanceClass];
        if ([class superclass] == NSObject.class) {
            return self.class;
        }
    }
    
    if (!key) {
        key = NSStringFromClass(self.class);
    }
    
    return NSClassFromString(key);
}

+ (NSString *)configForCurrentClass
{
    [BXBaseManager initManagerMap];
    
    NSString * value = NSStringFromClass(self.class);
    NSString * key = nil;
    
    for (NSString * keyString in managerMap.allKeys) {
        if ([value isEqualToString:keyString]) {
            key = value;
            return key;
        }
    }
    
    
    for (id aValue in managerMap.allValues) {
        if ([aValue isKindOfClass:[NSArray class]]) {
            NSArray * array = (NSArray *)aValue;
            
            if ([array containsObject:value]) {
                key = [[managerMap allKeysForObject:aValue] lastObject];
            }
            
        }else {
            if ([value isEqualToString:aValue]) {
                key = [[managerMap allKeysForObject:aValue] lastObject];
                break;
            }
        }
    }
    
    return key;
}

+ (void)initManagerMap
{
    if (!managerMap) {
        NSString * fileName = managerMappingFile?managerMappingFile:@"managerConfig";
        NSString* feedFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        if (feedFilePath) {
            managerMap = [[NSDictionary alloc] initWithContentsOfFile:feedFilePath];
        }
    }
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

@end
