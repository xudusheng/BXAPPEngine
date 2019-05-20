//
//  NLESpinKitAnimating.h
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol BXSpinKitAnimating <NSObject>
-(void)setupSpinKitAnimationInLayer:(CALayer*)layer withSize:(CGSize)size color:(UIColor*)color;
@end
