//
//  NLESpinKitUtils.m
//  BXAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import "BXSpinKitUtils.h"

// Animations
#import "BXSpinKit9CubeGridAnimation.h"
#import "BXSpinKitBounceAnimation.h"
#import "BXSpinKitChasingDotsAnimation.h"
#import "BXSpinKitCircleAnimation.h"
#import "BXSpinKitCircleFlipAnimation.h"
#import "BXSpinKitFadingCircleAltAnimation.h"
#import "BXSpinKitFadingCircleAnimation.h"
#import "BXSpinKitPlaneAnimation.h"
#import "BXSpinKitPulseAnimation.h"
#import "BXSpinKitThreeBounceAnimation.h"
#import "BXSpinKitWanderingCubesAnimation.h"
#import "BXSpinKitWaveAnimation.h"
#import "BXSpinKitWordPressAnimation.h"
#import "BXSpinKitArcAnimation.h"
#import "BXSpinKitArcAltAnimation.h"

CATransform3D BXSpinKit3DRotationWithPerspective(CGFloat perspective,
                                                        CGFloat angle,
                                                        CGFloat x,
                                                        CGFloat y,
                                                        CGFloat z)
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    return CATransform3DRotate(transform, angle, x, y, z);
}

NSObject<BXSpinKitAnimating>* BXSpinKitAnimationFromStyle(BXSpinKitViewStyle style)
{
    switch (style) {
        case BXSpinKitViewStylePlane:
            return [[BXSpinKitPlaneAnimation alloc] init];

        case BXSpinKitViewStyleCircleFlip:
            return [[BXSpinKitCircleFlipAnimation alloc] init];

        case BXSpinKitViewStyleBounce:
            return [[BXSpinKitBounceAnimation alloc] init];

        case BXSpinKitViewStyleWave:
            return [[BXSpinKitWaveAnimation alloc] init];

        case BXSpinKitViewStyleWanderingCubes:
            return [[BXSpinKitWanderingCubesAnimation alloc] init];

        case BXSpinKitViewStylePulse:
            return [[BXSpinKitPulseAnimation alloc] init];

        case BXSpinKitViewStyleChasingDots:
            return [[BXSpinKitChasingDotsAnimation alloc] init];

        case BXSpinKitViewStyleThreeBounce:
            return [[BXSpinKitThreeBounceAnimation alloc] init];

        case BXSpinKitViewStyleCircle:
            return [[BXSpinKitCircleAnimation alloc] init];

        case BXSpinKitViewStyle9CubeGrid:
            return [[BXSpinKit9CubeGridAnimation alloc] init];

        case BXSpinKitViewStyleWordPress:
            return [[BXSpinKitWordPressAnimation alloc] init];

        case BXSpinKitViewStyleFadingCircle:
            return [[BXSpinKitFadingCircleAnimation alloc] init];

        case BXSpinKitViewStyleFadingCircleAlt:
            return [[BXSpinKitFadingCircleAltAnimation alloc] init];

        case BXSpinKitViewStyleArc:
            return [[BXSpinKitArcAnimation alloc] init];
			
		case BXSpinKitViewStyleArcAlt:
			return [[BXSpinKitArcAltAnimation alloc] init];

        default:
            NSCAssert(NO, @"Unicorns exist");
    }
}
