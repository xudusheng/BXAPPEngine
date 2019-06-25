//
//  BXSwitchLanguageViewController.h
//  BXAppEngine
//
//  Created by Chengming on 2017/9/8.
//  Copyright © 2017年 NeuLion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXLanguageItem;

typedef void(^BXChangeLanguageBlock)(BXLanguageItem * item);

@interface BXSwitchLanguageViewController : UIViewController

@property (nonatomic, strong) UITableView * mainTaleView;

+ (BXLanguageItem *)currentSelectedItem;

+ (void)setTextFont:(UIFont *)font;
+ (void)setSubTextFont:(UIFont *)font;
+ (void)setTextColor:(UIColor *)color;
+ (void)setSubTextColor:(UIColor *)color;
+ (void)setRowHeight:(CGFloat)height;
+ (void)setTickSize:(CGFloat)size;
+ (void)setTickColor:(UIColor *)color;
+ (void)setInternalRefeshMode:(BOOL)flag;
+ (void)customChangeLanguageBlock:(BXChangeLanguageBlock)block;

@end

@interface BXLanguageItem : NSObject

@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * primaryName;
@property (nonatomic, copy) NSString * secondaryName;
@property (nonatomic, copy) NSNumber * order;
@property (nonatomic, copy) NSString * url;

@end
