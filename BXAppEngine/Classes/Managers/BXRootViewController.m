//
//  XDSRootViewController.m
//  Kit
//
//  Created by Hmily on 2018/7/23.
//  Copyright © 2018年 Hmily. All rights reserved.
//

#import "BXRootViewController.h"

@interface BXRootViewController ()

@end

@implementation BXRootViewController
static BOOL needAdjustPageLevelFlag = NO;

+ (instancetype)sharedRootViewController
{
    static BXRootViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.mainViewController) {
        return self.mainViewController.preferredStatusBarStyle;
    }else {
        UIViewController * childVC = [self.childViewControllers lastObject];
        if (childVC) {
            return childVC.preferredStatusBarStyle;
        }else {
            return UIStatusBarStyleDefault;
        }
    }
}

#pragma mark -
#pragma mark Public methods

+ (void)needAdjustPageLevel:(BOOL)flag
{
    needAdjustPageLevelFlag = flag;
}

- (void)setMainViewController:(UIViewController *)mainViewController
{
    if ([mainViewController isEqual:_mainViewController]) {
        return;
    }
    
    if(_mainViewController) {
        [_mainViewController willMoveToParentViewController:nil];
        if (_mainViewController.view.superview) {
            [_mainViewController.view removeFromSuperview];
        }
        [_mainViewController removeFromParentViewController];
    }
    
    if (mainViewController) {
        [self addChildViewController:mainViewController];
        [self.view addSubview:mainViewController.view];
        [self.view sendSubviewToBack:mainViewController.view];
        [mainViewController didMoveToParentViewController:self];
        
        if (needAdjustPageLevelFlag) {
            [self.view sendSubviewToBack:mainViewController.view];
        }
        [mainViewController.view layoutIfNeeded];
    }
    
    _mainViewController = mainViewController;
    
#if TARGET_OS_IOS
    [_mainViewController setNeedsStatusBarAppearanceUpdate];
#endif
}

#pragma mark -
#pragma mark Private methods

@end
