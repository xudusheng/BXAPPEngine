//
//  BXRequestPageStateHelper.m
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import "BXRequestPageStateHelper.h"

#if __has_include(<BXToolKit/BXUIKitAddition.h>)
#import <BXToolKit/BXUIKitAddition.h>
#else
#import "BXUIKitAddition.h"
#endif

//#import <BXToolKit/BXUIKitAddition.h>
//#import "BXUIKitAddition.h"


static NSNumber * configOwnerPageUserInteractionEnabledWhenLoading = nil;
static NSNumber * configOwnerPageUserInteractionEnabledWhenException = nil;

@interface BXRequestPageStateHelper ()

@property (nonatomic, copy) NSString * customRequestPageNibName;
@property (nonatomic, strong) CALayer * managedLayer;

@end

@implementation BXRequestPageStateHelper

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObservers];
}

#pragma mark - Config methods

+ (void)ownerPageUserInteractionEnabledWhenLoading:(BOOL)enabled
{
    configOwnerPageUserInteractionEnabledWhenLoading = @(enabled);
}

+ (void)ownerPageUserInteractionEnabledWhenException:(BOOL)enabled
{
    configOwnerPageUserInteractionEnabledWhenException = @(enabled);
}

#pragma mark - Public methods

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _ownerPage = view;
        _pageStyle = BXRequestPageStyleDefault;
        
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage
{
    return [self initWithStyle:style ownerPage:ownerPage customPageNibName:nil];
}

- (instancetype)initWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage customPageNibName:(NSString *)nibName
{
    self = [super init];
    if (self) {
        _ownerPage = ownerPage;
        _pageStyle = style;
        _customRequestPageNibName = nibName;
        
        [self initUI];
        
    }
    return self;
}

+ (instancetype)pageWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage
{
    return [[self alloc] initWithStyle:style ownerPage:ownerPage];
}

+ (instancetype)pageWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage customPageNibName:(NSString *)nibName
{
    return [[self alloc] initWithStyle:style ownerPage:ownerPage customPageNibName:nibName];
}

- (void)setState:(BXRequestPageState)requestPageState
{
    _state = requestPageState;
    
    if (BXRequestPageState_NULL != _state) {
        if (self.aboveView) {
            [self.ownerPage insertSubview:self.requestPageView aboveSubview:self.aboveView];
        }else if (self.belowView){
            [self.ownerPage insertSubview:self.requestPageView belowSubview:self.belowView];
        }else {
            [self.ownerPage addSubview:self.requestPageView];
        }
        
        if (BXRequestPageState_Loading == _state) {
            self.requestPageView.userInteractionEnabled = !self.ownerPageUserInteractionEnabledWhenLoading;
        }else {
            self.requestPageView.userInteractionEnabled = !self.ownerPageUserInteractionEnabledWhenException;
        }
        
    }else {
        if (self.requestPageView.superview) {
            [self.requestPageView removeFromSuperview];
        }
    }
    
    [self.requestPageView updateRequestPageState:_state];
}

#pragma mark - Private methods

- (void)initUI
{
    BXRequestPageView * requestPageView = nil;
    
    if (BXRequestPageStyleCustom == self.pageStyle && self.customRequestPageNibName) {
        UIView * view = [UIView viewFromNibNamed:self.customRequestPageNibName bundle:[NSBundle mainBundle]];
        if ([view isKindOfClass:[BXRequestPageView class]]) {
            requestPageView = (BXRequestPageView *)view;
            requestPageView.frame = self.ownerPage.bounds;
        }
    }
    
    if (!requestPageView) {
        requestPageView = [[BXRequestPageView alloc] initWithFrame:self.ownerPage.bounds];
    }
    requestPageView.delegate = self;
    requestPageView.pageStyle = self.pageStyle;
    
    _requestPageView = requestPageView;
    
    [_requestPageView initUI];
    
    [self addObservers];
    
    self.ownerPageUserInteractionEnabledWhenLoading = configOwnerPageUserInteractionEnabledWhenLoading?[configOwnerPageUserInteractionEnabledWhenLoading boolValue]:YES;
    self.ownerPageUserInteractionEnabledWhenException = configOwnerPageUserInteractionEnabledWhenException?[configOwnerPageUserInteractionEnabledWhenException boolValue]:NO;
}

- (void)addObservers
{
    self.managedLayer = self.ownerPage.layer;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.managedLayer addObserver:self forKeyPath:@"bounds" options:options context:nil];
}

- (void)removeObservers
{
    @try {
        [self.managedLayer removeObserver:self forKeyPath:@"bounds"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    self.managedLayer = nil;
}

- (void)layoutRequestPageView
{
    self.requestPageView.frame = self.ownerPage.bounds;
    [self.requestPageView layoutRequestPageView];
}

#pragma mark - BXRequestPageViewDelegate methods
- (BOOL)requestPageViewNeedHandleRetryAction
{
    return self.retryBlock?YES:NO;
}

- (void)requestPageViewHandleRetryAction
{
    if (self.retryBlock) {
        BXRequestPageState state = self.state;
        self.retryBlock(state);
    }
}

#pragma mark - NSKeyValueObserving methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        [self layoutRequestPageView];
    }
}

@end



