//
//  UIColor+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/19.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "UIColor+BXAddition.h"

@implementation UIColor (BXAddition)

+ (UIColor *)randomColor {
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 100000)
    return [UIColor colorWithDisplayP3Red:arc4random()%255/255.0
                                    green:arc4random()%255/255.0
                                     blue:arc4random()%255/255.0
                                    alpha:1.0f];
#else
    return [UIColor colorWithRed:arc4random()%255/255.0
                           green:arc4random()%255/255.0
                            blue:arc4random()%255/255.0
                           alpha:1.0f];
#endif
}

+ (UIColor *)colorWithHexString:(NSString *)hexString{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    {
        if([cleanString length] == 3) {
            cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                           [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                           [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                           [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
        }
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
