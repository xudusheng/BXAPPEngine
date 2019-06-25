//
//  BXASettingsManager.m
//  BXAppEngine_Example
//
//  Created by Hmily on 2019/6/11.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "BXASettingsManager.h"
#import "BXRequestPageStateHelper.h"
#import "BXCustomLoadingView.h"
@implementation BXASettingsManager
//launch
- (void)setupAfterLaunch {
    [super setupAfterLaunch];
}

//UI style
- (void)setUIStyle {
    [super setUIStyle];
    [self configRequestPageUI];
}

//Global settings
- (void)setGlobalSettings {
    [super setGlobalSettings];
}
- (void)setOnlyOnceWhenLaunchTaskQueueFinished {
    [super setOnlyOnceWhenLaunchTaskQueueFinished];
}

//TODO: BXRequestPageView样式定制
- (void)configRequestPageUI {
    [BXRequestPageView configLoadingStyle:BXPageLoadingStyleThreeBounce];
    [BXRequestPageView configLoadingSize:120];
    [BXRequestPageView configLoadingTintColor:[UIColor redColor]];
    [BXRequestPageView configTitleTextColor:[UIColor redColor]];
    [BXRequestPageView configTitleFont:[UIFont systemFontOfSize:12]];
    //    [BXRequestPageView setTitle:@"正在加载…" forState:BXRequestPageState_Loading];
    //    [BXRequestPageView setTitle:@"暂无数据……" forState:BXRequestPageState_NoData];
    //    [BXRequestPageView setAllowRetry:YES forState:BXRequestPageState_NoData];
    //    [BXRequestPageView setPromptImage:@"img-error" forState:BXRequestPageState_NoData];
    
    [BXRequestPageView setBgColor:[UIColor whiteColor] forState:BXRequestPageState_NoData];
    [BXRequestPageView setBgColor:[UIColor whiteColor] forState:BXRequestPageState_RequestError];
    [BXRequestPageView setBgColor:[UIColor whiteColor] forState:BXRequestPageState_GeoBlock];
    [BXRequestPageView setBgColor:[UIColor whiteColor] forState:BXRequestPageState_NoNetwork];
    [BXRequestPageView setBgColor:[UIColor whiteColor] forState:BXRequestPageState_Custom];
    
    [BXRequestPageStateHelper ownerPageUserInteractionEnabledWhenLoading:NO];
    
    //自定义loadingView
    [BXRequestPageView configCustomLoadingViewClassName:NSStringFromClass([BXCustomLoadingView class])];
}

@end
