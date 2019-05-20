//
//  BXCustomLoadingView.m
//  BXAppEngineDemo
//
//  Created by Hmily on 2019/4/8.
//  Copyright © 2019 BXAppEngine. All rights reserved.
//

#import "BXCustomLoadingView.h"
#import <BXToolKit/UIView+BXAddition.h>
@interface BXCustomLoadingView ()

@end

@implementation BXCustomLoadingView

- (BXCustomLoadingView *)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BXCustomLoadingView *HUD = [BXCustomLoadingView viewFromNibNamed:@"BXCustomLoadingView" bundle:[NSBundle mainBundle]];
        HUD.frame = frame;
        if (HUD) {
            self = nil;
            self = HUD;
        }
        self.backgroundColor = [UIColor blueColor];
        self.circleView.image = [UIImage imageNamed:@"ico_refresh_circle"];
        self.iconView.image = [UIImage imageNamed:@"ico_refresh_logo"];
//        self.titleLabel.text = @"图片正在加载中***";
        self.titleLabel.text = nil;
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}
    
    - (void)awakeFromNib {
        [super awakeFromNib];
        
        self.backgroundColor = [UIColor blueColor];
        self.circleView.image = [UIImage imageNamed:@"ico_refresh_circle"];
        self.iconView.image = [UIImage imageNamed:@"ico_refresh_logo"];
        //        self.titleLabel.text = @"图片正在加载中***";
        self.titleLabel.text = nil;
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    

- (BOOL)isAnimating {
    return YES;
}
- (void)startAnimating {
    [self addAnimation];
    self.hidden = NO;
}
- (void)stopAnimating {
    self.hidden = YES;
}

- (void)enterForgeground{
    [self.layer removeAnimationForKey:@"red"];
    [self addAnimation];
}

//----------------------------------------------------------------------------
//许杜生添加，用于解决动画进入后台后停止的问题
- (void)addAnimation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0f];
    rotationAnimation.duration = 1.2f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [self.circleView.layer addAnimation:rotationAnimation forKey:@"red"];
}


@end
