//
//  BXViewController.m
//  BXAppEngine
//
//  Created by xudusheng on 05/16/2019.
//  Copyright (c) 2019 xudusheng. All rights reserved.
//

#import "BXViewController.h"
#import "BXTaskQueue.h"

#import "BXRequestPageStateHelper.h"
#import "BXCustomLoadingView.h"

#import "BXManager.h"


#import "BXSwitchLanguageViewController.h"

@interface BXViewController ()

@property (nonatomic,strong) BXRequestPageStateHelper *pageStateHelper;
@property (weak, nonatomic) IBOutlet UIButton *switchLanguageButton;

@end

@implementation BXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configRequestPageUI];
}

#pragma mark - UI相关

#pragma mark - request method 网络请求

#pragma mark - delegate method 代理方法

#pragma mark - event response 事件响应处理

#pragma mark - BXRequestPageStateHelper
- (void)configRequestPageUI {
    __weak typeof(self)weakSelf = self;
    self.pageStateHelper = [BXRequestPageStateHelper pageWithStyle:BXRequestPageStyleDefault ownerPage:self.view];
//    self.pageStateHelper = [BXRequestPageStateHelper pageWithStyle:BXRequestPageStyleCustom ownerPage:self.view customPageNibName:@"BXRequestPageView"];

    [self.pageStateHelper setRetryBlock:^(BXRequestPageState state) {
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
    self.pageStateHelper.state = BXRequestPageState_NoData;
}
- (IBAction)showHUD:(id)sender {
    self.pageStateHelper.state = BXRequestPageState_Loading;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:2];
}

- (IBAction)showSwitchLanguageVC:(id)sender {
    BXSwitchLanguageViewController *languageVC = [[BXSwitchLanguageViewController alloc] init];
    [self.navigationController pushViewController:languageVC animated:YES];
}


#pragma mark - private method 其他私有方法

#pragma mark - setter & getter

#pragma mark - memery 内存管理相关

@end
