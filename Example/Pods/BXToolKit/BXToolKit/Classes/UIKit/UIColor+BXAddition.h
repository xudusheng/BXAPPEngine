//
//  UIColor+BXAddition.h
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BXAddition)

// 随机颜色
+ (UIColor *)randomColor;

//hex色值转UIColor
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

