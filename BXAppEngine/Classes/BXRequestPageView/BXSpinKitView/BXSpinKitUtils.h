//
//  BXSpinKitUtils.h
//  BXAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXSpinKitView.h"
#import "BXSpinKitAnimating.h"

CATransform3D BXSpinKit3DRotationWithPerspective(CGFloat perspective, CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
NSObject<BXSpinKitAnimating>* BXSpinKitAnimationFromStyle(BXSpinKitViewStyle style);
