//
//  BXAStarupManager.m
//  BXAppEngine_Example
//
//  Created by Hmily on 2019/6/11.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "BXAStartupManager.h"
#import "BXRootViewController.h"

#import "BXADeepLinkManager.h"
#import "BXManagerConstance.h"

#import "BXAConfigManager.h"
#import "BXLocalizableManager.h"

@implementation BXAStartupManager

- (void)startupWithLaunchingOptions:(NSDictionary *)launchOptions{
    [super startupWithLaunchingOptions:launchOptions];
    
    //launchTaskQueue需要被强引用，否则在执行任务时可能被释放
    self.launchTaskQueue = [BXTaskQueue taskQueue];
    
    //-----------------------fetchConfigTask--------------------------
    BXTask *fetchConfigTask = [BXTask task];
    fetchConfigTask.taskId = kBXFetchConfigTaskKey;
    fetchConfigTask.taskContentBlock = ^(BXTask *task) {
        NSLog(@"加载初始化文件任务===开始");
        [[BXAConfigManager sharedManager] fetchAppConfigWithURL:@"http://129.204.47.207/files/appConfig.txt"];
//        [task taskHasFinished];
        NSLog(@"加载初始化文件任务===结束");
    };
    
    //-----------------------updateLocalizableTask--------------------------
    BXTask *updateLocalizableTask = [BXTask task];
    updateLocalizableTask.taskId = kBXUpdataLocalizableTaskKey;
    updateLocalizableTask.taskContentBlock = ^(BXTask * task) {
        BXUrlItem *item = [[BXAConfigManager sharedManager].configItem urlItemByXdid:@"xd.feed.localization"];
        NSLog(@"item = %@", item.xdid);
        [[BXLocalizableManager sharedManager] updateLocalizableFileWithServerURL:item.url finished:^(NSError *error) {
            [task taskHasFinished];
        }];
    };
    
    //-----------------------check first use new version--------------------------
    BXTask *checkFirstUseNewVersionTask = [BXTask task];
    checkFirstUseNewVersionTask.taskId = @"版本检测任务ID";
    checkFirstUseNewVersionTask.taskContentBlock = ^(BXTask * task) {
        NSLog(@"执行版本检测任务===开始");
        [task taskHasFinished];
        NSLog(@"执行版本检测任务===结束");
    };
    
    //-----------------------autoLoginTask--------------------------
    BXTask *autoLoginTask = [BXTask task];
    autoLoginTask.taskId = @"自动登录任务ID";
    autoLoginTask.taskContentBlock = ^(BXTask * task) {
        NSLog(@"自动登录任务===开始");
        [task taskHasFinished];
        NSLog(@"自动登录任务===结束");
    };
    
    //任务之间添加依赖，即执行顺序
    [updateLocalizableTask addDependency:fetchConfigTask];
    [checkFirstUseNewVersionTask addDependency:updateLocalizableTask];
    [autoLoginTask addDependency:checkFirstUseNewVersionTask];
    
    [self.launchTaskQueue addTask:fetchConfigTask];
    [self.launchTaskQueue addTask:updateLocalizableTask];
    [self.launchTaskQueue addTask:checkFirstUseNewVersionTask];
    [self.launchTaskQueue addTask:autoLoginTask];
    
    
    __weak typeof(self)weakSelf = self;
    [self.launchTaskQueue goWithFinishedBlock:^(BXTaskQueue *taskQueue) {
        NSLog(@"启动任务完成-----今日主界面");
        weakSelf.launchTaskQueueFinished = YES;
        [weakSelf enterMainViewWithLaunchingOptions:launchOptions];
    }];
}

- (void)enterMainViewWithLaunchingOptions:(NSDictionary *)launchOptions {
    [super enterMainViewWithLaunchingOptions:launchOptions];
    
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *home = [mainBoard instantiateViewControllerWithIdentifier:@"Home"];
    [BXRootViewController sharedRootViewController].mainViewController = home;

    
    //handle url deeplink
    if ([BXADeepLinkManager sharedManager].urlDeepLinkOpenURL) {
        [[BXADeepLinkManager sharedManager] handleURLDeepLinkWithOpenURL:[BXDeepLinkManager sharedManager].urlDeepLinkOpenURL];
        [BXADeepLinkManager sharedManager].urlDeepLinkOpenURL = nil;
    }
    
    //handle apns deeplink
    if ([BXADeepLinkManager sharedManager].apnsDeepLinkInfo) {
        [[BXADeepLinkManager sharedManager] handleAPNSDeepLinkWithUserInfo:[BXADeepLinkManager sharedManager].apnsDeepLinkInfo needShowMessage:[BXADeepLinkManager sharedManager].apnsDeepLinkNeedShowMessage];
        [BXADeepLinkManager sharedManager].apnsDeepLinkInfo = nil;
        [BXADeepLinkManager sharedManager].apnsDeepLinkNeedShowMessage = NO;
    }
    
}
- (void)initMainViewLaunchingOptions:(NSDictionary *)launchOptions {
    [super initMainViewLaunchingOptions:launchOptions];
    
}

@end
