//
//  XDSSettingsManager.m
//  Kit
//
//  Created by Hmily on 2018/7/23.
//  Copyright © 2018年 Hmily. All rights reserved.
//

#import "BXSettingsManager.h"

@implementation BXSettingsManager
+ (instancetype)sharedManager
{
    static BXSettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self instanceClass] alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(self = [super init]){
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Launch
- (void)setupAfterLaunch {}

#pragma mark  --通知
-(void)addObserverNotification{}

#pragma mark - UI Style
- (void)setUIStyle{

}

#pragma mark - Global Settings
- (void)setGlobalSettings {}



- (void)setOnlyOnceWhenLaunchTaskQueueFinished {}

@end
