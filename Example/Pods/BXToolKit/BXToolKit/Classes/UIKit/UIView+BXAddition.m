//
//  UIView+BXAddition.m
//  Demo
//
//  Created by Hmily on 2018/10/23.
//  Copyright © 2018年 BX. All rights reserved.
//

#import "UIView+BXAddition.h"
#import <objc/runtime.h>

@implementation UIView (BXAddition)
+ (instancetype)viewFromNibNamed:(NSString *)nibName bundle:(NSBundle *_Nullable)nibBundleOrNil {
    
    NSArray *nibViews = [nibBundleOrNil?nibBundleOrNil:[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    for (id object in nibViews) {
        if ([object isKindOfClass:NSClassFromString(nibName)]) {
            return object;
        }
    }
    //if no object found, just return the first object
    if (nibViews) {
        return [nibViews objectAtIndex:0];
    }
    return nil;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

-(UIViewController *)viewController{
    
    id next = [self nextResponder];
    
    while (next) {
        next = [next nextResponder];
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
    }
    return nil;
}
@end


#pragma mark -- 字体适配

#define BX_FONT_SCALE(A) (([UIScreen mainScreen].bounds.size.width / 375.0f) * A)

#define BXEXChangeSetFontMethod \
+ (void)load{ \
Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:)); \
Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:)); \
method_exchangeImplementations(imp, myImp); \
Method imp_setFont = class_getInstanceMethod([self class], @selector(setFont:)); \
Method myImp_setFont = class_getInstanceMethod([self class], @selector(mySetFont:)); \
method_exchangeImplementations(imp_setFont, myImp_setFont); \
} \
\
- (id)myInitWithCoder:(NSCoder*)aDecode{ \
[self myInitWithCoder:aDecode]; \
if (self) { \
self.font = self.font; \
} \
return self; \
} \
\
- (void)mySetFont:(UIFont *)font { \
CGFloat fontSize = font.pointSize; \
fontSize = BX_FONT_SCALE(fontSize); \
UIFont *myFont = [UIFont fontWithName:font.fontName size:fontSize]; \
[self mySetFont:myFont]; \
} \


@implementation UIButton (MyFont)
+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        self.titleLabel.font = self.titleLabel.font;
    }
    return self;
}
@end

@implementation UILabel (myFont)
BXEXChangeSetFontMethod
@end

@implementation UITextField (myFont)
BXEXChangeSetFontMethod
@end

@implementation UITextView (myFont)
BXEXChangeSetFontMethod
@end


