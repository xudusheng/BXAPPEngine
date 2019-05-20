//
//  BXRequestPageView.h
//  BXAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BXRequestPageStyle) {
    BXRequestPageStyleDefault,
    BXRequestPageStyleCustom
};

typedef NS_ENUM(NSInteger, BXRequestPageState) {
    BXRequestPageState_NULL = 0,    //NULL
    BXRequestPageState_Loading,     //Loading
    BXRequestPageState_NoData,      //Success but data null
    BXRequestPageState_RequestError,    //Fetch error
    BXRequestPageState_GeoBlock,   //Geo block
    BXRequestPageState_NoNetwork,  //No network
    BXRequestPageState_Custom      //Custom
};

typedef NS_ENUM(NSInteger, BXPageLoadingStyle) {
    BXPageLoadingStyleUnknow = -1,
    BXPageLoadingStyleSystem = 0,
    BXPageLoadingStylePlane,
    BXPageLoadingStyleCircleFlip,
    BXPageLoadingStyleBounce,
    BXPageLoadingStyleWave,
    BXPageLoadingStyleWanderingCubes,
    BXPageLoadingStylePulse,
    BXPageLoadingStyleChasingDots,
    BXPageLoadingStyleThreeBounce,
    BXPageLoadingStyleCircle,
    BXPageLoadingStyle9CubeGrid,
    BXPageLoadingStyleWordPress,
    BXPageLoadingStyleFadingCircle,
    BXPageLoadingStyleFadingCircleAlt,
    BXPageLoadingStyleArc,
    BXPageLoadingStyleArcAlt,
    BXPageLoadingStyleArcNone
};

@protocol BXPageCustomLoadingViewProtocol;
@protocol BXRequestPageViewDelegate;
@interface BXRequestPageView : UIView

@property (nonatomic, weak) id<BXRequestPageViewDelegate> delegate;
@property (nonatomic, assign) BXRequestPageStyle pageStyle;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UILabel * subtitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView * bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView * promptImageView;
@property (nonatomic, strong) IBOutlet UIView<BXPageCustomLoadingViewProtocol> * loadingView;
@property (nonatomic, strong) IBOutlet UIButton * retryButton;

- (void)initUI;
- (void)updateRequestPageState:(BXRequestPageState)state;
- (void)layoutRequestPageView;

- (void)setTitle:(NSString *)title forState:(BXRequestPageState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(BXRequestPageState)state;
- (void)setBgColor:(UIColor *)color forState:(BXRequestPageState)state;
- (void)setBgImage:(NSString *)bgImage forState:(BXRequestPageState)state;
- (void)setPromptImage:(NSString *)promptImage forState:(BXRequestPageState)state;
- (void)setAllowRetry:(BOOL)allowRetry forState:(BXRequestPageState)state;

+ (void)setTitle:(NSString *)title forState:(BXRequestPageState)state;
+ (void)setSubtitle:(NSString *)subtitle forState:(BXRequestPageState)state;
+ (void)setBgColor:(UIColor *)color forState:(BXRequestPageState)state;
+ (void)setBgImage:(NSString *)bgImage forState:(BXRequestPageState)state;
+ (void)setPromptImage:(NSString *)promptImage forState:(BXRequestPageState)state;
+ (void)setAllowRetry:(BOOL)allowRetry forState:(BXRequestPageState)state;

+ (void)configTitleFont:(UIFont *)font;
+ (void)configSubtitleFont:(UIFont *)font;
+ (void)configTitleTextColor:(UIColor *)color;
+ (void)configSubtitleTextColor:(UIColor *)color;
+ (void)configLoadingStyle:(BXPageLoadingStyle)style;
+ (void)configLoadingTintColor:(UIColor *)color;
+ (void)configLoadingSize:(CGFloat)size;
+ (void)configCustomLoadingViewClassName:(NSString *)className; //custom loading view need implement BXPageCustomLoadingViewProtocol

@end

@protocol BXRequestPageViewDelegate <NSObject>
@required
- (BOOL)requestPageViewNeedHandleRetryAction;
@optional
- (void)requestPageViewHandleRetryAction;
@end

@protocol BXPageCustomLoadingViewProtocol <NSObject>

@required
- (BOOL)isAnimating;
- (void)startAnimating;
- (void)stopAnimating;

@end
