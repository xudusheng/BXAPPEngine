//
//  BXCustomLoadingView.h
//  BXAppEngineDemo
//
//  Created by Hmily on 2019/4/8.
//  Copyright © 2019 BXAppEngine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXRequestPageView.h"


@interface BXCustomLoadingView : UIView <BXPageCustomLoadingViewProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *circleView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

