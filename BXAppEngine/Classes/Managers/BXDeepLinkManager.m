//
//  BXDeepLinkManager.m
//  BXAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import "BXDeepLinkManager.h"

@implementation BXDeepLinkManager

+ (BXDeepLinkManager *)sharedManager
{
    static BXDeepLinkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self instanceClass] alloc] init];
    });
    return sharedInstance;
}

- (void)handleURLDeepLinkWithOpenURL:(NSURL *)url{
    NSLog(@"BXDeepLinkManager");
}

- (void)handleAPNSDeepLinkWithUserInfo:(NSDictionary *)userInfo needShowMessage:(BOOL)showMessage{
    NSLog(@"handleAPNSDeepLinkWithUserInfo");
}

@end
