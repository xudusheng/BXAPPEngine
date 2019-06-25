//
//  BXBaseAppDelegate.m
//  BXAppEngine
//
//  Created by xudusheng on 05/16/2019.
//  Copyright (c) 2019 xudusheng. All rights reserved.
//

#import "BXBaseAppDelegate.h"
#import "BXStartupManager.h"
#import "BXDeepLinkManager.h"

@implementation BXBaseAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [self handleUrlDeepLinkWithUrl:url];
    return YES;
}

- (void)handleUrlDeepLinkWithUrl:(NSURL *)url {
    if ([BXStartupManager sharedManager].launchTaskQueueFinished) {
        [[BXDeepLinkManager sharedManager] handleURLDeepLinkWithOpenURL:url];
        [BXDeepLinkManager sharedManager].urlDeepLinkOpenURL = nil;
    }else {
        [BXDeepLinkManager sharedManager].urlDeepLinkOpenURL = url;
    }
}

- (void)handleAPNSDeepLinkWithhUserInfo:(NSDictionary *)userInfo needShowMessage:(BOOL)showMessage {
    [BXDeepLinkManager sharedManager].apnsDeepLinkNeedShowMessage = showMessage;
    if ([BXStartupManager sharedManager].launchTaskQueueFinished) {
        [[BXDeepLinkManager sharedManager] handleAPNSDeepLinkWithUserInfo:userInfo needShowMessage:showMessage];
        [BXDeepLinkManager sharedManager].apnsDeepLinkInfo = nil;
        [BXDeepLinkManager sharedManager].apnsDeepLinkNeedShowMessage = NO;
    }else {
        [BXDeepLinkManager sharedManager].apnsDeepLinkInfo = userInfo;
    }
}

@end
