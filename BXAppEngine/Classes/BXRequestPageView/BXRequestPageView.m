//
//  BXRequestPageView.m
//  BXAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//

#import "BXRequestPageView.h"
#import "BXSpinKitView.h"

#if __has_include(<BXToolKit/BXUIKitAddition.h>)
#import <BXToolKit/BXUIKitAddition.h>
#else
#import "BXUIKitAddition.h"
#endif

//#import <BXToolKit/BXUIKitAddition.h>
//#import "BXUIKitAddition.h"

static NSMutableDictionary * staticTitleDict = nil;
static NSMutableDictionary * staticSubtitleDict = nil;
static NSMutableDictionary * staticBgColorDict = nil;
static NSMutableDictionary * staticBgImageDict = nil;
static NSMutableDictionary * staticPromptImageDict = nil;
static NSMutableDictionary * staticAllowRetryDict = nil;
static UIFont * staticTitleFont = nil;
static UIFont * staticSubtitleFont = nil;
static UIColor * staticTitleTextColor = nil;
static UIColor * staticSubtitleTextColor = nil;
static BXPageLoadingStyle staticLoadingStyle = BXPageLoadingStyleUnknow;
static UIColor * staticLoadingTintColor = nil;
static CGFloat staticLoadingSize = 37;
static NSString * staticCustomLoadingViewClassName = nil;

@interface BXRequestPageView ()

@property (nonatomic, assign) BXRequestPageState requestPageState;

@property (nonatomic, strong) NSMutableDictionary * titleDict;
@property (nonatomic, strong) NSMutableDictionary * subtitleDict;
@property (nonatomic, strong) NSMutableDictionary * bgColorDict;
@property (nonatomic, strong) NSMutableDictionary * bgImageDict;
@property (nonatomic, strong) NSMutableDictionary * promptImageDict;
@property (nonatomic, strong) NSMutableDictionary * allowRetryDict;


@end

@implementation BXRequestPageView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (id)init
{
    if(self = [super init]){
  
    }
    return self;
}

#pragma mark - Config methods

- (void)setTitle:(NSString *)title forState:(BXRequestPageState)state
{
    if (!self.titleDict) {
        self.titleDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (title) {
        [self.titleDict setObject:title forKey:@(state)];
    }
}

- (void)setSubtitle:(NSString *)subtitle forState:(BXRequestPageState)state
{
    if (!self.subtitleDict) {
        self.subtitleDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (subtitle) {
        [self.subtitleDict setObject:subtitle forKey:@(state)];
    }
}

- (void)setBgColor:(UIColor *)color forState:(BXRequestPageState)state
{
    if (!self.bgColorDict) {
        self.bgColorDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (color) {
        [self.bgColorDict setObject:color forKey:@(state)];
    }
}

- (void)setBgImage:(NSString *)bgImage forState:(BXRequestPageState)state
{
    if (!self.bgImageDict) {
        self.bgImageDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (bgImage) {
        [self.bgImageDict setObject:bgImage forKey:@(state)];
    }
}

- (void)setPromptImage:(NSString *)promptImage forState:(BXRequestPageState)state
{
    if (!self.promptImageDict) {
        self.promptImageDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (promptImage) {
        [self.promptImageDict setObject:promptImage forKey:@(state)];
    }
}

- (void)setAllowRetry:(BOOL)allowRetry forState:(BXRequestPageState)state
{
    if (!self.allowRetryDict) {
        self.allowRetryDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    [self.allowRetryDict setObject:@(allowRetry) forKey:@(state)];
}

+ (void)setTitle:(NSString *)title forState:(BXRequestPageState)state
{
    if (!staticTitleDict) {
        staticTitleDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (title) {
        [staticTitleDict setObject:title forKey:@(state)];
    }
}

+ (void)setSubtitle:(NSString *)subtitle forState:(BXRequestPageState)state
{
    if (!staticSubtitleDict) {
        staticSubtitleDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (subtitle) {
        [staticSubtitleDict setObject:subtitle forKey:@(state)];
    }
}

+ (void)setBgColor:(UIColor *)color forState:(BXRequestPageState)state
{
    if (!staticBgColorDict) {
        staticBgColorDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (color) {
        [staticBgColorDict setObject:color forKey:@(state)];
    }
}

+ (void)setBgImage:(NSString *)bgImage forState:(BXRequestPageState)state
{
    if (!staticBgImageDict) {
        staticBgImageDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (bgImage) {
        [staticBgImageDict setObject:bgImage forKey:@(state)];
    }
}

+ (void)setPromptImage:(NSString *)promptImage forState:(BXRequestPageState)state
{
    if (!staticPromptImageDict) {
        staticPromptImageDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    if (promptImage) {
        [staticPromptImageDict setObject:promptImage forKey:@(state)];
    }
}

+ (void)setAllowRetry:(BOOL)allowRetry forState:(BXRequestPageState)state
{
    if (!staticAllowRetryDict) {
        staticAllowRetryDict = [NSMutableDictionary dictionaryWithCapacity:7];
    }
    [staticAllowRetryDict setObject:@(allowRetry) forKey:@(state)];
}

+ (void)configTitleFont:(UIFont *)font
{
    staticTitleFont = font;
}

+ (void)configSubtitleFont:(UIFont *)font
{
    staticSubtitleFont = font;
}

+ (void)configTitleTextColor:(UIColor *)color
{
    staticTitleTextColor = color;
}

+ (void)configSubtitleTextColor:(UIColor *)color
{
    staticSubtitleTextColor = color;
}

+ (void)configLoadingStyle:(BXPageLoadingStyle)style
{
    staticLoadingStyle = style;
}

+ (void)configLoadingTintColor:(UIColor *)color
{
    staticLoadingTintColor = color;
}

+ (void)configLoadingSize:(CGFloat)size
{
    staticLoadingSize = size;
}

+ (void)configCustomLoadingViewClassName:(NSString *)className
{
    staticCustomLoadingViewClassName = className;
}

- (NSString *)titleForState:(BXRequestPageState)state
{
    NSString * title = [self.titleDict objectForKey:@(state)];
    if (!title) {
        title = [staticTitleDict objectForKey:@(state)];
    }
    if (!title) {
        
        switch (state) {
            case BXRequestPageState_NoData:
                title = @"No content is available at this time. Please check back later.";
                break;
            case BXRequestPageState_RequestError:
                title = @"Connect failed. Please try again later.";
                break;
            case BXRequestPageState_GeoBlock:
                title = @"This application is currently unavailable in your area.";
                break;
            case BXRequestPageState_NoNetwork:
                title = @"You're Off-Line Right Now.\nIt requires a connection to the Internet. Please turn off Airplane Mode or connect via WiFi or 3G/EDGE network";
                break;
            default:
                break;
        }
        
    }
    
    return title;
}

- (NSString * )subtitleForState:(BXRequestPageState)state
{
    NSString * subtitle = [self.subtitleDict objectForKey:@(state)];
    if (!subtitle) {
        subtitle = [staticSubtitleDict objectForKey:@(state)];
    }
    
    return subtitle;
}

- (UIColor *)bgColorForState:(BXRequestPageState)state
{
    UIColor * bgColor = [self.bgColorDict objectForKey:@(state)];
    if (!bgColor) {
        bgColor = [staticBgColorDict objectForKey:@(state)];
    }
    return bgColor;
}

- (NSString *)bgImageForState:(BXRequestPageState)state
{
    NSString * bgImage = [self.bgImageDict objectForKey:@(state)];
    if (!bgImage) {
        bgImage = [staticBgImageDict objectForKey:@(state)];
    }
    
    return bgImage;
}

- (NSString *)promptImageForState:(BXRequestPageState)state
{
    NSString * promptImage = [self.promptImageDict objectForKey:@(state)];
    if (!promptImage) {
        promptImage = [staticPromptImageDict objectForKey:@(state)];
    }
    
    return promptImage;
}

- (BOOL)allowRetryForState:(BXRequestPageState)state
{
    NSNumber * allowValue = [self.allowRetryDict objectForKey:@(state)];
    
    if (allowValue) {
        return [allowValue boolValue];
    }
    
    NSNumber * staticAllowValue = [staticAllowRetryDict objectForKey:@(state)];
    
    if (staticAllowValue) {
        return [staticAllowValue boolValue];
    }
    
    if (BXRequestPageState_NoData == state ||
        BXRequestPageState_RequestError == state ||
        BXRequestPageState_GeoBlock == state ||
        BXRequestPageState_NoNetwork == state) {
        return YES;
    }else {
        return NO;
    }
}

- (UIFont *)titleLabelFont
{
    return staticTitleFont?staticTitleFont:[UIFont systemFontOfSize:17];
}

- (UIFont *)subtitleLabelFont
{
    return staticSubtitleFont?staticSubtitleFont:[UIFont systemFontOfSize:13];
}

- (UIColor *)titleLabelTextColor
{
    return staticTitleTextColor?staticTitleTextColor:[UIColor grayColor];
}

- (UIColor *)subtitleLabelTextColor
{
    return staticSubtitleTextColor?staticSubtitleTextColor:[UIColor grayColor];
}

- (BXPageLoadingStyle)pageLoadingStyle
{
    if (BXPageLoadingStyleUnknow != staticLoadingStyle) {
        return staticLoadingStyle;
    }
    return BXPageLoadingStyleArc;
}

- (UIColor *)loadingTintColor
{
    return staticLoadingTintColor?staticLoadingTintColor:[UIColor whiteColor];
}

- (CGFloat)loadingSize
{
    return staticLoadingSize > 0 ? staticLoadingSize : 37;
}

#pragma mark - Public methods

- (void)updateRequestPageState:(BXRequestPageState)state
{
    if (BXRequestPageState_NULL == state) {
        [self hideContentView:state];
        [self hideLoadingView:state];
    }else if (BXRequestPageState_Loading == state) {
        [self showLoadingView:state];
        [self hideContentView:state];
    }else {
        [self hideLoadingView:state];
        [self showContentView:state];
        
        [self loadRequestPageContentWithState:state];
    }
    
    UIColor * bgColor = [self bgColorForState:state];
    if (bgColor) {
        self.backgroundColor = bgColor;
    }else {
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.requestPageState = state;
    
    [self layoutRequestPageView];
}

#pragma mark - Private methods

- (void)initUI
{
    if (BXRequestPageStyleCustom == self.pageStyle) {
        return;
    }
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [self titleLabelFont];
    titleLabel.textColor = [self titleLabelTextColor];

    UILabel * subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = [self subtitleLabelFont];
    subtitleLabel.textColor = [self subtitleLabelTextColor];
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    UIImageView * promptImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    promptImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton * retryButton = [[UIButton alloc] initWithFrame:CGRectZero];
#if TARGET_OS_IOS
    [retryButton addTarget:self action:@selector(clickedRetryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    retryButton.showsTouchWhenHighlighted = YES;
#elif TARGET_OS_TV
    [retryButton addTarget:self action:@selector(clickedRetryButtonAction:) forControlEvents:UIControlEventPrimaryActionTriggered];
#endif
    
    self.titleLabel = titleLabel;
    self.subtitleLabel = subtitleLabel;
    self.bgImageView = bgImageView;
    self.promptImageView = promptImageView;
    self.retryButton = retryButton;
    
    [self addSubview:bgImageView];
    [self addSubview:promptImageView];
    [self addSubview:titleLabel];
    [self addSubview:subtitleLabel];
    [self addSubview:retryButton];
    
    if (!self.loadingView) {
        
        if (staticCustomLoadingViewClassName) {
            UIView * loadingView = [(UIView *)[NSClassFromString(staticCustomLoadingViewClassName) alloc] initWithFrame:CGRectMake(0, 0, [self loadingSize], [self loadingSize])];
            
            [self addSubview:loadingView];
            self.loadingView = (UIView<BXPageCustomLoadingViewProtocol> *)loadingView;
            
        }else if (BXPageLoadingStyleSystem != [self pageLoadingStyle] && BXPageLoadingStyleArcNone != [self pageLoadingStyle]) {
            
            BXSpinKitView * loadingView = [[BXSpinKitView alloc] initWithStyle:[BXRequestPageView getSpinKitViewStyle:@([self pageLoadingStyle])] color:[self loadingTintColor] spinnerSize:[self loadingSize]];
            //loadingView.alpha = 0.6;
            loadingView.hidesWhenStopped = YES;
            [self addSubview:loadingView];
            self.loadingView = (UIView<BXPageCustomLoadingViewProtocol> *)loadingView;
            
        }else if (BXPageLoadingStyleArcNone != [self pageLoadingStyle]){
            
            UIActivityIndicatorView * plainLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            plainLoadingView.hidesWhenStopped = YES;
            plainLoadingView.color = [self loadingTintColor];
            [self addSubview:plainLoadingView];
            
            self.loadingView = (UIView<BXPageCustomLoadingViewProtocol> *)plainLoadingView;
            
        }
    }
    
}

- (void)showLoadingView:(BXRequestPageState)state
{
    if (staticCustomLoadingViewClassName) {
        [self.loadingView startAnimating];
    }else if ([self.loadingView isKindOfClass:[BXSpinKitView class]]) {
        BXSpinKitView * loadingView = (BXSpinKitView *)self.loadingView;
        [loadingView startAnimating];
    }else if ([self.loadingView isKindOfClass:[UIActivityIndicatorView class]]){
        UIActivityIndicatorView * loadingView = (UIActivityIndicatorView *)self.loadingView;
        [loadingView startAnimating];
    }else {
        self.loadingView.hidden = NO;
    }
}

- (void)hideLoadingView:(BXRequestPageState)state
{
    if (staticCustomLoadingViewClassName) {
        if ([self.loadingView isAnimating]) {
            [self.loadingView stopAnimating];
        }
    }else if ([self.loadingView isKindOfClass:[BXSpinKitView class]]) {
        BXSpinKitView * loadingView = (BXSpinKitView *)self.loadingView;
        if ([loadingView isAnimating]) {
            [loadingView stopAnimating];
        }
    }else if ([self.loadingView isKindOfClass:[UIActivityIndicatorView class]]){
        UIActivityIndicatorView * loadingView = (UIActivityIndicatorView *)self.loadingView;
        if ([loadingView isAnimating]) {
            [loadingView stopAnimating];
        }
    }else {
        self.loadingView.hidden = YES;
    }
}

- (void)showContentView:(BXRequestPageState)state
{
    self.titleLabel.hidden = NO;
    self.subtitleLabel.hidden = NO;
    self.bgImageView.hidden = NO;
    self.promptImageView.hidden = NO;
    
    if ([self.delegate requestPageViewNeedHandleRetryAction] && [self allowRetryForState:state]) {
        self.retryButton.hidden = NO;
    }else {
        self.retryButton.hidden = YES;
    }
}

- (void)hideContentView:(BXRequestPageState)state
{
    self.titleLabel.hidden = YES;
    self.subtitleLabel.hidden = YES;
    self.bgImageView.hidden = YES;
    self.promptImageView.hidden = YES;
    self.retryButton.hidden = YES;
}

+ (BXSpinKitViewStyle)getSpinKitViewStyle:(NSNumber *)styleNumber
{
    BXPageLoadingStyle style = [styleNumber intValue];
    
    BXSpinKitViewStyle resultStyle = BXSpinKitViewStylePlane;
    switch (style) {
        case BXPageLoadingStylePlane:
            resultStyle = BXSpinKitViewStylePlane;
            break;
        case BXPageLoadingStyleCircleFlip:
            resultStyle = BXSpinKitViewStyleCircleFlip;
            break;
        case BXPageLoadingStyleBounce:
            resultStyle = BXSpinKitViewStyleBounce;
            break;
        case BXPageLoadingStyleWave:
            resultStyle = BXSpinKitViewStyleWave;
            break;
        case BXPageLoadingStyleWanderingCubes:
            resultStyle = BXSpinKitViewStyleWanderingCubes;
            break;
        case BXPageLoadingStylePulse:
            resultStyle = BXSpinKitViewStylePulse;
            break;
        case BXPageLoadingStyleChasingDots:
            resultStyle = BXSpinKitViewStyleChasingDots;
            break;
        case BXPageLoadingStyleThreeBounce:
            resultStyle = BXSpinKitViewStyleThreeBounce;
            break;
        case BXPageLoadingStyleCircle:
            resultStyle = BXSpinKitViewStyleCircle;
            break;
        case BXPageLoadingStyle9CubeGrid:
            resultStyle = BXSpinKitViewStyle9CubeGrid;
            break;
        case BXPageLoadingStyleWordPress:
            resultStyle = BXSpinKitViewStyleWordPress;
            break;
        case BXPageLoadingStyleFadingCircle:
            resultStyle = BXSpinKitViewStyleFadingCircle;
            break;
        case BXPageLoadingStyleFadingCircleAlt:
            resultStyle = BXSpinKitViewStyleFadingCircleAlt;
            break;
        case BXPageLoadingStyleArc:
            resultStyle = BXSpinKitViewStyleArc;
            break;
        case BXPageLoadingStyleArcAlt:
            resultStyle = BXSpinKitViewStyleArcAlt;
            break;
        default:
            break;
    }
    return resultStyle;
}

- (void)layoutRequestPageView
{
    if (BXRequestPageStyleCustom == self.pageStyle) {
        return;
    }
    
    self.bgImageView.frame = self.bounds;
    
    self.loadingView.frame = CGRectMake(floorf((self.width-self.loadingView.width)/2.0), floorf((self.height-self.loadingView.height)/2.0), self.loadingView.width, self.loadingView.height);
    
    self.retryButton.frame = self.bounds;
    
    [self adjustLabel:self.titleLabel];
    
    [self adjustLabel:self.subtitleLabel];
    
    //image, title, subtitle
    if (self.promptImageView.image && self.titleLabel.text.length && self.subtitleLabel.text.length) {
        
        CGFloat bottomMinLength = self.titleLabel.height + self.subtitleLabel.height + 20 + 20;
        [self.promptImageView sizeToFit];
        if (self.promptImageView.width > self.width) {
            self.promptImageView.width = self.width;
        }
        
        if (self.promptImageView.height + bottomMinLength > self.height) {
            self.promptImageView.height = self.height - bottomMinLength;
        }
        
        self.promptImageView.x = floorf((self.width-self.promptImageView.width)/2.0);
        self.promptImageView.y = floorf((self.height - self.promptImageView.height - bottomMinLength)/2.0);
        self.titleLabel.y = self.promptImageView.y + self.promptImageView.height + 20;
        self.subtitleLabel.y = self.titleLabel.y + self.titleLabel.height + 20;
        
    //image
    }else if (self.promptImageView.image && !self.titleLabel.text.length && !self.subtitleLabel.text.length) {
    
        [self.promptImageView sizeToFit];
        if (self.promptImageView.width > self.width) {
            self.promptImageView.width = self.width;
        }
        
        if (self.promptImageView.height > self.height) {
            self.promptImageView.height = self.height;
        }
        
        self.promptImageView.x = floorf((self.width-self.promptImageView.width)/2.0);
        self.promptImageView.y = floorf((self.height - self.promptImageView.height)/2.0);
        
    //image, title
    }else if (self.promptImageView.image && self.titleLabel.text.length && !self.subtitleLabel.text.length) {
    
        CGFloat bottomMinLength = self.titleLabel.height + 20;
        [self.promptImageView sizeToFit];
        if (self.promptImageView.width > self.width) {
            self.promptImageView.width = self.width;
        }
        
        if (self.promptImageView.height + bottomMinLength > self.height) {
            self.promptImageView.height = self.height - bottomMinLength;
        }
        
        self.promptImageView.x = floorf((self.width-self.promptImageView.width)/2.0);
        self.promptImageView.y = floorf((self.height - self.promptImageView.height - bottomMinLength)/2.0);
        self.titleLabel.y = self.promptImageView.y + self.promptImageView.height + 20;
        
    //title
    }else if (!self.promptImageView.image && self.titleLabel.text.length && !self.subtitleLabel.text.length) {
        
        self.titleLabel.y = floorf((self.height-self.titleLabel.height)/2.0);
        
    //title, subtitle
    }else if (!self.promptImageView.image && self.titleLabel.text.length && self.subtitleLabel.text.length) {
        
        self.titleLabel.y = floorf((self.height - self.titleLabel.height - 20 - self.subtitleLabel.height)/2.0);
        self.subtitleLabel.y = self.titleLabel.y + self.titleLabel.height + 20;
    }
}

- (void)loadRequestPageContentWithState:(BXRequestPageState)state
{
    self.titleLabel.text = [self titleForState:state];
    self.subtitleLabel.text = [self subtitleForState:state];
    
    NSString * bgImage = [self bgImageForState:state];
    if (bgImage) {
        self.bgImageView.image = [UIImage imageNamed:bgImage];
    }
    
    NSString * promptImage = [self promptImageForState:state];
    if (promptImage) {
        self.promptImageView.image = [UIImage imageNamed:promptImage];
    }
}

- (void)adjustLabel:(UILabel *)label
{
    @try {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(self.width-16, 10000.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        label.numberOfLines = ceilf(labelSize.height/label.font.lineHeight);

        label.frame = CGRectMake(8, 0, self.width-16, ceilf(labelSize.height));
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

- (void)clickedRetryButtonAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(requestPageViewHandleRetryAction)]) {
        [self.delegate requestPageViewHandleRetryAction];
    }
}

@end
