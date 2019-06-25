//
//  XDSSettingsManager.h
//  Kit
//
//  Created by Hmily on 2018/7/23.
//  Copyright © 2018年 Hmily. All rights reserved.
//

#import "BXBaseManager.h"

@interface BXSettingsManager : BXBaseManager

+ (instancetype)sharedManager;

//launch
- (void)setupAfterLaunch NS_REQUIRES_SUPER;

//UI style
- (void)setUIStyle NS_REQUIRES_SUPER;

//Global settings
- (void)setGlobalSettings NS_REQUIRES_SUPER;
- (void)setOnlyOnceWhenLaunchTaskQueueFinished NS_REQUIRES_SUPER;

@end
