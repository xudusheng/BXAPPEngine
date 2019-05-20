//
//  BXHUD.h
//  BXUIKit
//
//  Created by Hmily on 2019/3/26.
//  Copyright © 2019 BXUIKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const BXProgressHUDDidReceiveTouchEventNotification;
UIKIT_EXTERN NSString * const BXProgressHUDDidTouchDownInsideNotification;
UIKIT_EXTERN NSString * const BXProgressHUDWillDisappearNotification;
UIKIT_EXTERN NSString * const BXProgressHUDDidDisappearNotification;
UIKIT_EXTERN NSString * const BXProgressHUDWillAppearNotification;
UIKIT_EXTERN NSString * const BXProgressHUDDidAppearNotification;

UIKIT_EXTERN NSString * const BXProgressHUDStatusUserInfoKey;

@interface BXHUD : NSObject
//设置根控制器，用于添加新的toast时移除可能存在的旧HUD，默认[UIApplication sharedApplication].keyWindow.rootViewController
//仅接收UITabBarController、UINavigationController或者UIViewController类型的对象
//如果keyWindow.rootViewController不是UITabBarController、UINavigationController或者UIViewController，则建议设置这个值。
+ (void)setRootViewController:(UIViewController *)rootViewController;

+ (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;     // default is 1.5 seconds

//MARK: MPProgressHUD样式定制
+ (void)setHUDBackgroundColor:(UIColor *)backgroundColor hudColor:(UIColor *)hudColor;
+ (void)setHUDFont:(UIFont *)font detailFont:(UIFont *)detailFont;
+ (void)setFrefreshCircleImage:(UIImage *)circleImage;
+ (void)setFrefreshLogoImage:(UIImage *)logoImage;

//MARK: SVProgressHUD样式定制
+ (void)setToastFont:(UIFont *)font;
+ (void)setForegroundColor:(nonnull UIColor*)color; // default is [UIColor blackColor]
+ (void)setBackgroundColor:(nonnull UIColor*)color;// default is [UIColor whiteColor]
+ (void)setSuccessImage:(nonnull UIImage*)image; // default is nil
+ (void)setErrorImage:(nonnull UIImage*)image;      // default is nil

//MARK: MPProgressHUD
+ (void)showHud:(UIView *)rootView;//显示无文本的HUD
+ (void)showHud:(UIView *)rootView text:(nullable NSString*)text;//显示HUD
+ (void)hideHud:(UIView *)rootView;

//MARK: SVProgressHUD
+ (void)showToastWithText:(NSString *)text;//显示文本，1.5秒后消隐
+ (void)showToastSuccess:(NSString *)success;//成功时，1.5秒后消隐
+ (void)showToastFailed:(NSString *)failed;//失败时，1.5秒后消隐
@end

NS_ASSUME_NONNULL_END
