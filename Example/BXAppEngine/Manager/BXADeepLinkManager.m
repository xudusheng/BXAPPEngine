//
//  BXADeepLinkManager.m
//  BXAppEngine_Example
//
//  Created by Hmily on 2019/5/23.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "BXADeepLinkManager.h"
#import "BXAppDelegate.h"

@implementation BXADeepLinkManager

- (void)handleURLDeepLinkWithOpenURL:(NSURL *)url {
    NSLog(@"url = %@", url);
    UIViewController *deepLinkVC = [[UIViewController alloc] init];
    deepLinkVC.view.backgroundColor = [UIColor yellowColor];
    deepLinkVC.title = @"Deep Link";
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:deepLinkVC animated:YES completion:nil];
}

- (void)handleAPNSDeepLinkWithUserInfo:(NSDictionary *)userInfo needShowMessage:(BOOL)showMessage {
    NSLog(@"userInfo = %@", userInfo);
}

@end
