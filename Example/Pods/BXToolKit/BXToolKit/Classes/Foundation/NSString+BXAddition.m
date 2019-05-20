//
//  NSString+BXAddition.m
//  Demo
//
//  Created by Hmily on 2018/10/19.
//  Copyright © 2018年 BX. All rights reserved.
//

#import "NSString+BXAddition.h"
//#include <stdio.h>
//#include <stdint.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (BXAddition)
/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)MD5String
{
    const char * cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *output = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return output.uppercaseString;
}

+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

/**
 将一个数字使用千位分隔符表示
 
 将一个数字使用千位分隔符表示
 
 @param digit 保留小数点几位
 @param flag 是否保留小数
 @return 如  12,123.23
 */
- (NSString *)numberWithThousandsSeparator:(NSInteger)digit
                                                      showDecimal:(BOOL)flag {
    NSString *numberString = self;
    if (!numberString.length) return @"";
    if (flag) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:numberString.doubleValue]];
    }
    
    NSArray *arr = [numberString componentsSeparatedByString:@"."];
    if (arr.count == 1) {
        if (!digit) return numberString;
        
        numberString = [numberString stringByAppendingString:@"."];
        for (int i = 0; i < digit; i ++) {
            numberString = [numberString stringByAppendingString:@"0"];
        }
        return numberString;
    } else {
        NSString *beforeString = arr[0];
        NSString *afterString = arr[1];
        
        if (digit == 0) {
            return [numberString componentsSeparatedByString:@"."][0];
        } else if (afterString.length >= digit) {
            return [NSString stringWithFormat:@"%@.%@",beforeString, [afterString substringToIndex:digit]];
        } else {
            NSUInteger c = digit - afterString.length;
            for (int k = 0; k < c; k ++) {
                numberString = [numberString stringByAppendingString:@"0"];
            }
            return numberString;
        }
    }
}

//格式话小数 只舍不入
+(NSString *)decimalWithFormat:(NSString *)format doubleV:(double)doubleV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.roundingMode = NSNumberFormatterRoundDown;
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:doubleV]];
}

/**
 将一个数字字符串转换为百分号显示，保留2位小数
 
 @param string 目标数字
 @return 如20.2%
 */
+(NSString *)formatStringForPercentageWithString:(NSString *)string {
    if (!string.length) return @"";
    float a = [string floatValue];
    float b = a * 100;
    NSString * bstring = [NSString stringWithFormat:@"%f",b];
    NSArray *arr = [bstring componentsSeparatedByString:@"."];
    NSString *beforeString = arr[0];
    NSString *afterString = [arr[1] substringToIndex:2];
    return [NSString stringWithFormat:@"%@.%@%%",beforeString,afterString];
}

/** *  截取URL中的参数 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters{
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
        
    } else {
        // 单个参数
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        // 设置值
        [params setValue:value forKey:key];
    }
    return params;
    
}


//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
@end



@implementation NSString (BXStringSize)

- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize {
    if (!font) return CGSizeZero;

    NSDictionary *arrts = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
}

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize {
    return [text sizeWithFont:font andMaxSize:maxSize];
}

@end
