//
//  BXAppDelegate.m
//  BXAppEngine
//
//  Created by xudusheng on 05/16/2019.
//  Copyright (c) 2019 xudusheng. All rights reserved.
//

#import "BXAppDelegate.h"
#import "BXADeepLinkManager.h"
#import "BXAStartupManager.h"
@implementation BXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    [BXBaseManager readManagerMappingFile:@"managerConfig"];
    [[BXAStartupManager sharedManager] startupWithLaunchingOptions:launchOptions];
    return YES;
}


#pragma mark - 推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNoData);

    if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10, 0, 0}]) {
        [self handleAPNSDeepLinkWithhUserInfo:userInfo needShowMessage:(application.applicationState == UIApplicationStateActive)];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10, 0, 0}]) {
        [self handleAPNSDeepLinkWithhUserInfo:userInfo needShowMessage:(application.applicationState == UIApplicationStateActive)];
    }
}


@end
