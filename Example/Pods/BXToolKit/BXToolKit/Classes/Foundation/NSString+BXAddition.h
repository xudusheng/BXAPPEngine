//
//  NSString+BXAddition.h
//  Demo
//
//  Created by Hmily on 2018/10/19.
//  Copyright © 2018年 BX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (BXAddition)
/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;


/**
 * MD5加密
 *
 @return MD5加密字符串
 */
- (NSString *)MD5String;

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)stringWithUUID;


/**
 将一个数字使用千位分隔符表示

 @param digit 保留小数点几位
 @param flag 是否保留小数
 @return 如  12,123.23
 */
- (NSString *)numberWithThousandsSeparator:(NSInteger)digit
                                                      showDecimal:(BOOL)flag;


/**
 格式化数字，超过的小数被截断

 @param format 格式化字符串，如@"#,###.##"
 @param doubleV 需要转换的z数字
 @return 格式化化后的数字字符串，如@"2,233,254.95"
 */
+ (NSString *)decimalWithFormat:(NSString *)format doubleV:(double)doubleV;


/**
 将一个数字字符串转换为百分号显示，保留2位小数
 
 @param string 目标数字
 @return 如20.2%
 */
+(NSString *)formatStringForPercentageWithString:(NSString *)string;

/**
 *  截取URL中的参数 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters;


//判断是否为整形：
- (BOOL)isPureInt;
//判断是否为浮点形：
- (BOOL)isPureFloat;

@end


#pragma mark - 文本计算方法
@interface NSString (BXStringSize)
/**
 *  快速计算出文本的真实尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

/**
 *  快速计算出文本的真实尺寸
 *
 *  @param text    需要计算尺寸的文本
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

@end
NS_ASSUME_NONNULL_END
