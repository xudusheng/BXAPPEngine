//
//  BXViewController.m
//  BXAppEngine
//
//  Created by xudusheng on 05/16/2019.
//  Copyright (c) 2019 xudusheng. All rights reserved.
//

#import "BXViewController.h"
#import "BXTaskQueue.h"

#import "BXUIKitAddition.h"

#import "BXRequestPageStateHelper.h"
#import "BXCustomLoadingView.h"

@interface BXViewController ()
@property (weak, nonatomic) IBOutlet UIButton *taskQueueButton;

@property (nonatomic,strong) BXTaskQueue *launchTaskQueue;

@property (nonatomic,strong) BXRequestPageStateHelper *pageStateHelper;

@end

@implementation BXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configRequestPageUI];

}

#pragma mark - UI相关

#pragma mark - request method 网络请求

#pragma mark - delegate method 代理方法

#pragma mark - event response 事件响应处理

- (IBAction)taskQueueButtonClick:(UIButton *)sender {
    
    //launchTaskQueue需要被强引用，否则在执行任务时可能被释放
    self.launchTaskQueue = [BXTaskQueue taskQueue];
    
    //-----------------------fetchConfigTask--------------------------
    BXTask *fetchConfigTask = [BXTask task];
    fetchConfigTask.taskId = @"加载初始化文件任务ID";
    fetchConfigTask.taskContentBlock = ^(BXTask *task) {
        NSLog(@"加载初始化文件任务===开始");
        [task taskHasFinished];
        NSLog(@"加载初始化文件任务===结束");
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
    [checkFirstUseNewVersionTask addDependency:fetchConfigTask];
    [autoLoginTask addDependency:checkFirstUseNewVersionTask];
    
    [_launchTaskQueue addTask:fetchConfigTask];
    [_launchTaskQueue addTask:checkFirstUseNewVersionTask];
    [_launchTaskQueue addTask:autoLoginTask];
    
    [_launchTaskQueue goWithFinishedBlock:^(BXTaskQueue *taskQueue) {
        NSLog(@"启动任务完成-----今日主界面");
    }];
}

#pragma mark - BXRequestPageStateHelper
- (void)configRequestPageUI {
    //BXRequestPageView样式定制
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
    
    //自定义loadingView
    [BXRequestPageView configCustomLoadingViewClassName:NSStringFromClass([BXCustomLoadingView class])];
    [BXRequestPageStateHelper ownerPageUserInteractionEnabledWhenLoading:NO];
    
    __weak typeof(self)weakSelf = self;
    self.pageStateHelper = [BXRequestPageStateHelper pageWithStyle:BXRequestPageStyleDefault ownerPage:self.view];
    [self.pageStateHelper setRetryBlock:^(BXRequestPageState state) {
        NSLog(@"YYYYYYYYYY");
        weakSelf.pageStateHelper.state = BXRequestPageState_Loading;
        [weakSelf performSelector:@selector(hideHUD) withObject:nil afterDelay:2];
    }];
    
    self.pageStateHelper.state = BXRequestPageState_NULL;
    
    [self.pageStateHelper.requestPageView setTitle:@"正在加载…" forState:BXRequestPageState_Loading];
    [self.pageStateHelper.requestPageView setTitle:@"暂无数据，请稍后重试…" forState:BXRequestPageState_NoData];
    [self.pageStateHelper.requestPageView setAllowRetry:YES forState:BXRequestPageState_NoData];
    [self.pageStateHelper.requestPageView setPromptImage:@"img-error" forState:BXRequestPageState_NoData];
}
- (void)hideHUD {
    self.pageStateHelper.state =BXRequestPageState_NULL;
}
- (IBAction)showHUD:(id)sender {
    self.pageStateHelper.state = BXRequestPageState_Loading;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:2];
}

#pragma mark - private method 其他私有方法

#pragma mark - setter & getter

#pragma mark - memery 内存管理相关

@end
