//
//  XDSConfigManager.m
//  Kit
//
//  Created by Hmily on 2018/7/22.
//  Copyright © 2018年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXManager.h"
#import "UIAlertController+BXAddition.h"

#define kBXConfigFileDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"Config"]

@interface BXConfigManager ()
@property (nonatomic, strong) NSString * storeLink;
@property (nonatomic, strong) UIAlertController * versionAlertController;
@property (nonatomic, strong) UIAlertController * offlineAlertController;

@end

@implementation BXConfigManager
+ (BXConfigManager *)sharedManager
{
    static BXConfigManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self instanceClass] alloc] init];
    });
    return sharedInstance;
}

- (void)fetchAppConfigWithURL:(NSString *)urlString {
    
    NSError *error = nil;
    NSString *configString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];

    // 获取Document目录
    NSString *filePath = [kBXConfigFileDirectory stringByAppendingString:@"/appConfig.txt"];
    
    if (configString.length < 1) {
        configString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (configString.length < 1) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"appConfig.txt" ofType:nil];
            configString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        }
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            [[configString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
        } else {

            if(![fileManager contentsOfDirectoryAtPath:kBXConfigFileDirectory error:nil]){
                [fileManager createDirectoryAtPath:kBXConfigFileDirectory withIntermediateDirectories:NO attributes:nil error:nil];
            }
            
           BOOL result = [fileManager createFileAtPath:filePath contents:[configString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            NSLog(@"result = %@", @(result));
        }
    }
    
    BXConfigItem *item = [[BXConfigItem alloc] initConfigItemBySystemLanguageWithJsonStr:configString];
    BOOL fetchFail = NO;
    if (!item) {
        fetchFail = YES;
    }else {
        self.configItem = item;
        [self configTaskFinished];
    }
    
    if (fetchFail && !self.configItem) {
        //error
        NSString *msg = BXLocalizedString(@"bx.message.offline", @"网络异常");
        if (self.offlineAlertController.visible) {
            [self.offlineAlertController dismissViewControllerAnimated:NO completion:nil];
            self.offlineAlertController = nil;
        }
        
        UIAlertController * alertController = [UIAlertController showAlertInViewController:[UIApplication sharedApplication].delegate.window.rootViewController
                                                                                 withTitle:@"标题名称"
                                                                                   message:msg
                                                                         cancelButtonTitle:BXLocalizedString(@"bx.ui.reconnect", nil)
                                                                         otherButtonTitles:nil
                                                                                  tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                                                      if (controller.cancelButtonIndex == buttonIndex) {
                                                                                          
                                                                                          [self fetchAppConfigWithURL:nil];
                                                                                          
                                                                                      }
                                                                                  }];
        
        self.offlineAlertController = alertController;
        
    }
}


-(void)configTaskFinished
{
    //check version
    if ([self versionLogic:self.configItem]) {
        return;
    }
    
    //task finished
    BXTask * fetchConfigTask = [[BXStartupManager sharedManager].launchTaskQueue taskWithTaskId:kBXFetchConfigTaskKey];
    [fetchConfigTask taskHasFinished];
    
}



- (BOOL)versionLogic:(BXConfigItem *) configItem
{
    BOOL isUpdateEnable =  NO;
    BOOL isForceUpdate =  NO;
    if (configItem) {
        BXUrlItem *greeting = [configItem urlItemByXdid:@"xd.app.greeting"];
        
        if (!greeting.enable) {
            return isUpdateEnable;
        }
        isUpdateEnable = YES;
        NSString * updateLink = nil;
        NSString * okTitle = nil;
        NSInteger alertTag = 0;

        updateLink = BXLocalizedString(@"bx.update.update", nil);
        if ([[greeting paramsValueBykey:@"forceUpgrade"] boolValue]) {
            isForceUpdate = YES;
            alertTag = 100;
        }
        
        self.storeLink = [greeting paramsValueBykey:@"upgradeUrl"];

        NSString *msgTitle = [greeting paramsValueBykey:@"title"];
        NSString *msgBody = [greeting paramsValueBykey:@"message"];
        
        if ((!msgTitle && !msgBody) || ([msgTitle isEqualToString:@""] && [msgBody isEqualToString:@""])) {
            return NO;
        }
        
        if (self.versionAlertController.visible) {
            [self.versionAlertController dismissViewControllerAnimated:NO completion:nil];
            self.versionAlertController = nil;
        }
        
        __weak typeof(self)weakself = self;
        if (isForceUpdate) {
                UIAlertController * alertController = [UIAlertController showAlertInViewController:[UIApplication sharedApplication].delegate.window.rootViewController
                                                                                     withTitle:msgTitle
                                                                                       message:msgBody
                                                                             cancelButtonTitle:BXLocalizedString(@"bx.ui.quitapp", nil)
                                                                             otherButtonTitles:updateLink?@[updateLink]:nil
                                                                                      tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                                                          if (buttonIndex == controller.cancelButtonIndex) {
                                                                                              NSLog(@"Quit App");
                                                                                              exit(0);
                                                                                          }else if (buttonIndex == controller.firstOtherButtonIndex) {
                                                                                              NSURL *url = [[NSURL alloc] initWithString:weakself.storeLink];
                                                                                              [[UIApplication sharedApplication] openURL:url];
                                                                                              weakself.storeLink = nil;
                                                                                              exit(0);
                                                                                          }
                                                                                      }];
            self.versionAlertController = alertController;
            
        }else {
            
            UIAlertController * alertController = [UIAlertController showAlertInViewController:[UIApplication sharedApplication].delegate.window.rootViewController
                                                                                     withTitle:msgTitle
                                                                                       message:msgBody
                                                                             cancelButtonTitle:BXLocalizedString(@"bx.update.cancel", nil)
                                                                             otherButtonTitles:@[updateLink]
                                                                                      tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                                                          if (buttonIndex != controller.cancelButtonIndex) {
                                                                                              NSURL *url = [[NSURL alloc] initWithString:weakself.storeLink];
                                                                                              [[UIApplication sharedApplication] openURL:url];
                                                                                              weakself.storeLink = nil;
                                                                                          }
                                                                                          //task finished
                                                                                          BXTask * fetchConfigTask = [[BXStartupManager sharedManager].launchTaskQueue taskWithTaskId:kBXFetchConfigTaskKey];
                                                                                          [fetchConfigTask taskHasFinished];
                                                                                      }];
            
            self.versionAlertController = alertController;
        }
    }
    return isUpdateEnable || isForceUpdate;
}

@end
