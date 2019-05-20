//
//  UINavigationController+BXAddition.h
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/20.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (BXAddition)

/**
 pop到指定类

 @param viewControllerClass 目标类
 @param animated 是否动画
 */
- (void)popToClass:(Class)viewControllerClass animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
