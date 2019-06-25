//
//  XDSBaseManager.h
//
//  Copyright (c) 2014 xudusheng. All rights reserved.
//

//managerConfig.plist使用说明
//Manager初始化时，会到managerConfig.plist寻找对应的类进行初始化
//key是类名，value是数组，数组内的类在初始化时都初始化成key的类。这一点一定要注意


#import <Foundation/Foundation.h>
//#import "RegexKitLite.h"
@interface BXBaseManager : NSObject

+ (BXBaseManager *)sharedManager;
+ (Class)instanceClass;
+ (NSString *)configForCurrentClass;
+ (void)readManagerMappingFile:(NSString *)fileName;

@end
