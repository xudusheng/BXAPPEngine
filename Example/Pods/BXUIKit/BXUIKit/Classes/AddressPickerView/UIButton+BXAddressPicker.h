//
//  UIButton+BXAddressPicker.h
//  BXUIKit
//
//  Created by Hmily on 2019/3/25.
//  Copyright © 2019 Document. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIButton (BXAddressPicker)
/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * backgroundColor : 背景颜色
 * cornerRadius : 圆角半径
 * borderWidth : 边框宽度
 * borderColor : 边款颜色
 * title : 标题
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor title:(NSString *)title;

/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * backgroundColor : 背景颜色
 * title : 标题
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor title:(NSString *)title;
/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * title : 标题
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont title:(NSString *)title ;
/**
 * 快速创建按钮
 * frame : frame
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * backgroundColor : 背景颜色
 * title : 标题
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor title:(NSString *)title;
/**
 * 快速创建按钮
 * frame : frame
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * title : 标题
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont title:(NSString *)title;
/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * cornerRadius : 圆角半径
 * borderWidth : 边框宽度
 * borderColor : 边款颜色
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 */
+ (UIButton *)bx_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName;
@end

