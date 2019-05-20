//
//  UIView+BXAddition.h
//  Demo
//
//  Created by Hmily on 2018/10/23.
//  Copyright © 2018年 BX. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIView (BXAddition)

/**
 *    @param     nibName     xibname
 *    @param     nibBundleOrNil     bundle
 *    @return    return object, such as customerd UIView
 */
+ (instancetype)viewFromNibNamed:(NSString *)nibName bundle:(NSBundle *_Nullable)nibBundleOrNil;

// 如果@property在分类里面使用只会自动声明get,set方法,不会实现,并且不会帮你生成成员属性
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

- (UIViewController *)viewController;

@end



/**
 *  button
 */
@interface UIButton (MyFont)

@end


/**
 *  Label
 */
@interface UILabel (myFont)

@end

/**
 *  TextField
 */

@interface UITextField (myFont)

@end

/**
 *  TextView
 */
@interface UITextView (myFont)

@end

NS_ASSUME_NONNULL_END
