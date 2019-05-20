//
//  BXHUD.m
//  BXUIKit
//
//  Created by Hmily on 2019/3/26.
//  Copyright © 2019 BXUIKit. All rights reserved.
//

#import "BXHUD.h"
#import "BXProgressHUD.h"
#import "SVProgressHUD.h"

static UIViewController *kBXHUDRootViewController = nil;

@interface UIViewController (BXHUD)

+ (UIViewController *)bxh_visiableViewController;

@end

@implementation UIViewController (BXHUD)
+ (UIViewController *)bxh_visiableViewController {
    //    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIViewController *rootViewController = kBXHUDRootViewController;
    return [UIViewController bxh_topViewControllerForViewController:rootViewController];
}

+ (UIViewController *)bxh_topViewControllerForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self bxh_topViewControllerForViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)viewController visibleViewController];
    } else {
        if (viewController.presentedViewController) {
            return [self bxh_topViewControllerForViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}
@end



NSString * const BXProgressHUDDidReceiveTouchEventNotification = @"BXProgressHUDDidReceiveTouchEventNotification";
NSString * const BXProgressHUDDidTouchDownInsideNotification = @"BXProgressHUDDidTouchDownInsideNotification";
NSString * const BXProgressHUDWillDisappearNotification = @"BXProgressHUDWillDisappearNotification";
NSString * const BXProgressHUDDidDisappearNotification = @"BXProgressHUDDidDisappearNotification";
NSString * const BXProgressHUDWillAppearNotification = @"BXProgressHUDWillAppearNotification";
NSString * const BXProgressHUDDidAppearNotification = @"BXProgressHUDDidAppearNotification";
NSString * const BXProgressHUDStatusUserInfoKey = @"BXProgressHUDStatusUserInfoKey";

static NSTimeInterval kBXHUDMinimumDismissTimeInterval = 1.5;
static UIColor *kBXHUDBackgroundColor = nil;
static UIColor *kBXHUDColor = nil;

static BXHUD *kNotificationHUD = nil;
@implementation BXHUD
+ (void)initialize {
    kBXHUDMinimumDismissTimeInterval = 1.5;
    kBXHUDBackgroundColor = [UIColor clearColor];
    kBXHUDColor = [UIColor colorWithWhite:0 alpha:0.7];
    kBXHUDRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    kNotificationHUD = [[BXHUD alloc] init];
    [kNotificationHUD addNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:SVProgressHUDDidReceiveTouchEventNotification]) {
        notificationName = BXProgressHUDDidReceiveTouchEventNotification;
    }else if ([notificationName isEqualToString:SVProgressHUDDidTouchDownInsideNotification]) {
        notificationName = BXProgressHUDDidTouchDownInsideNotification;
    }else if ([notificationName isEqualToString:SVProgressHUDWillDisappearNotification]) {
        notificationName = BXProgressHUDWillDisappearNotification;
    }else if ([notificationName isEqualToString:SVProgressHUDDidDisappearNotification]) {
        notificationName = BXProgressHUDDidDisappearNotification;
    }else if ([notificationName isEqualToString:SVProgressHUDWillAppearNotification]) {
        notificationName = BXProgressHUDWillAppearNotification;
    }else if ([notificationName isEqualToString:SVProgressHUDDidAppearNotification]) {
        notificationName = BXProgressHUDDidAppearNotification;
    }
    if (notificationName.length < 1) {
        return;
    }
    
    NSDictionary *userInfo = nil;
    NSString *statusUserInfo = notification.userInfo[SVProgressHUDStatusUserInfoKey];
    if (statusUserInfo != nil) {
        userInfo = @{BXProgressHUDStatusUserInfoKey:statusUserInfo};
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:notification.object userInfo:userInfo];
    
}

+ (void)setRootViewController:(UIViewController *)rootViewController {
    kBXHUDRootViewController = rootViewController;
}

+ (void)setHUDBackgroundColor:(UIColor *)backgroundColor hudColor:(UIColor *)hudColor {
    kBXHUDBackgroundColor = backgroundColor;
    kBXHUDColor = hudColor;
}
+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval {
    kBXHUDMinimumDismissTimeInterval = interval;
    [SVProgressHUD setMinimumDismissTimeInterval:interval];
}

+ (void)setHUDBackgroundColor:(UIColor *)color {
    kBXHUDBackgroundColor = color;
}
+ (void)setHUDFont:(UIFont *)font detailFont:(UIFont *)detailFont {
    [BXProgressHUD setLabelFont:font];
    [BXProgressHUD setDetailLabelFont:detailFont];
}
+ (void)setFrefreshCircleImage:(UIImage *)circleImage {
    [BXProgressHUD setFrefreshCircleImage:circleImage];
}
+ (void)setFrefreshLogoImage:(UIImage *)logoImage {
    [BXProgressHUD setFrefreshLogoImage:logoImage];
}

+ (void)setToastFont:(UIFont *)font {
     [SVProgressHUD setFont:font];
}
+ (void)setForegroundColor:(nonnull UIColor*)color {
    [SVProgressHUD setForegroundColor:color];
}
+ (void)setBackgroundColor:(nonnull UIColor*)color {
    [SVProgressHUD setBackgroundColor:color];
}
+ (void)setSuccessImage:(nonnull UIImage*)image {
    [SVProgressHUD setSuccessImage:image];
}
+ (void)setErrorImage:(nonnull UIImage*)image {
    [SVProgressHUD setErrorImage:image];
}


+ (void)showHud:(UIView*)rootView {
    [self showHud:rootView text:nil];
}
+ (void)showHud:(UIView*)rootView text:(NSString*)text {
    [self hideHud:rootView];
    [SVProgressHUD dismiss];
    BXProgressHUD *HUD = [BXProgressHUD HUDAddedTo:rootView];
    [[NSNotificationCenter defaultCenter] postNotificationName:BXProgressHUDWillAppearNotification object:HUD userInfo:nil];
    HUD.backgroundColor = kBXHUDBackgroundColor;
    HUD.detailsLabelText = text;
    HUD.color = kBXHUDColor;
    HUD.verticalMargin = 20.f;
    HUD.horizontalMargin = 20.f;
    [HUD show:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:BXProgressHUDDidAppearNotification object:HUD userInfo:nil];
}
+(void)hideHud:(UIView *)rootView{
    BXProgressHUD *hud = [BXProgressHUD HUDForView:rootView];
    if (hud) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BXProgressHUDWillDisappearNotification object:hud userInfo:nil];
        hud.removeFromSuperViewOnHide = YES;//加上这一句，否则出现严重内存泄露   许杜生 2015.07.07  20：04
        [hud hide:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:BXProgressHUDDidDisappearNotification object:hud userInfo:nil];
    }
}

//MARK: SVProgressHUD
+ (void)showToastWithText:(NSString *)text {
    [self hideHud:[UIViewController bxh_visiableViewController].view];
    [SVProgressHUD showInfoWithStatus:text];
}
//成功时，1.2秒后消隐
+ (void)showToastSuccess:(NSString *)success {
    [self hideHud:[UIViewController bxh_visiableViewController].view];
    [SVProgressHUD showSuccessWithStatus:success];
}
+ (void)showToastFailed:(NSString *)failed {
    [self hideHud:[UIViewController bxh_visiableViewController].view];
    [SVProgressHUD showErrorWithStatus:failed];
}
@end

