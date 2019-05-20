//
//  UINavigationController+BXAddition.m
//  BXToolKit_Example
//
//  Created by Hmily on 2019/3/20.
//  Copyright © 2019 xudusheng. All rights reserved.
//

#import "UINavigationController+BXAddition.h"

@implementation UINavigationController (BXAddition)

- (void)popToClass:(Class)viewControllerClass animated:(BOOL)animated {
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:viewControllerClass]) {
            [self popToViewController:vc animated:animated];
            break;
        }
    }
}

@end
