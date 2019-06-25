//
//  BXBaseAppDelegate.h
//  BXAppEngine
//
//  Created by xudusheng on 05/16/2019.
//  Copyright (c) 2019 xudusheng. All rights reserved.
//

@import UIKit;
@interface BXBaseAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//UIApplication cycle methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


//URL deeplink methods
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
- (void)handleUrlDeepLinkWithUrl:(NSURL *)url;
- (void)handleAPNSDeepLinkWithhUserInfo:(NSDictionary *)userInfo needShowMessage:(BOOL)showMessage;

@end
