//
//  BXSpinKitView.h
//  BXAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BXSpinKitViewStyle) {
    BXSpinKitViewStylePlane,
    BXSpinKitViewStyleCircleFlip,
    BXSpinKitViewStyleBounce,
    BXSpinKitViewStyleWave,
    BXSpinKitViewStyleWanderingCubes,
    BXSpinKitViewStylePulse,
    BXSpinKitViewStyleChasingDots,
    BXSpinKitViewStyleThreeBounce,
    BXSpinKitViewStyleCircle,
    BXSpinKitViewStyle9CubeGrid,
    BXSpinKitViewStyleWordPress,
    BXSpinKitViewStyleFadingCircle,
    BXSpinKitViewStyleFadingCircleAlt,
    BXSpinKitViewStyleArc,
    BXSpinKitViewStyleArcAlt
};

/**
 The `BXSpinKitView` defines an activity indicator view. It's interface is very similar
 to `UIActivityIndicatorView`.
 */
@interface BXSpinKitView : UIView

/**
 The color of the activity indicator.
 */
@property (nonatomic, strong) UIColor *color;

/**
 Whether or not the receiver should be hidden when not animating.
 */
@property (nonatomic, assign) BOOL hidesWhenStopped;

/**
 The style for the activity indicator.

 @see BXSpinKitViewStyle
 */
@property (nonatomic, assign) BXSpinKitViewStyle style;

/**
 The size of the spinner. The view will be automatically resized to fit the activity indicator.
 */
@property (nonatomic, assign) CGFloat spinnerSize;

@property (nonatomic, assign, getter = isStopped) BOOL stopped;

/**
 Initializes and returns an activity indicator object.

 @param style The style of the activity indicator.
 
 @return The newly-initialized SpinKit view.
 */
-(instancetype)initWithStyle:(BXSpinKitViewStyle)style;

/**
 Initializes and returns an activity indicator object.

 @param style The style of the activity indicator.
 @param color The color of the activity indicator.

 @return The newly-initialized SpinKit view.
 */
-(instancetype)initWithStyle:(BXSpinKitViewStyle)style color:(UIColor*)color;

/**
 Initializes and returns an activity indicator object.

 Designated initializer.

 @param style The style of the activity indicator.
 @param color The color of the activity indicator.
 @param spinnerSize The size of the spinner.

 @return The newly-initialized SpinKit view.
 */
-(instancetype)initWithStyle:(BXSpinKitViewStyle)style
                       color:(UIColor*)color
                 spinnerSize:(CGFloat)spinnerSize;

/**
 Starts the animation of the activity indicator.
 */
-(void)startAnimating;

/**
 Stops the animation of the activity indicator.
 */
-(void)stopAnimating;

/**
 Returns whether the receiver is animating.

 @return `YES` if the receiver is animating, otherwise `NO`.
 */
-(BOOL)isAnimating;

@end
