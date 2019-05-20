//
//  NLERequestPageStateHelper.h
//  NLAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BXRequestPageView.h"

typedef void(^BXRequestPageStateHelperRetryBlock)(BXRequestPageState state);

@interface BXRequestPageStateHelper : NSObject <BXRequestPageViewDelegate>

@property (nonatomic, assign, readonly) BXRequestPageStyle pageStyle;
@property (nonatomic, strong, readonly) BXRequestPageView * requestPageView;
@property (nonatomic, weak, readonly) UIView * ownerPage;

@property (nonatomic, assign) BXRequestPageState state;
@property (nonatomic, copy) BXRequestPageStateHelperRetryBlock retryBlock;

@property (nonatomic, weak) UIView * aboveView;
@property (nonatomic, weak) UIView * belowView;
@property (nonatomic, assign) BOOL ownerPageUserInteractionEnabledWhenLoading;
@property (nonatomic, assign) BOOL ownerPageUserInteractionEnabledWhenException;

- (instancetype)initWithView:(UIView *)view DEPRECATED_ATTRIBUTE;
- (instancetype)initWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage;
- (instancetype)initWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage customPageNibName:(NSString *)nibName;

+ (instancetype)pageWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage;
+ (instancetype)pageWithStyle:(BXRequestPageStyle)style ownerPage:(UIView *)ownerPage customPageNibName:(NSString *)nibName;

+ (void)ownerPageUserInteractionEnabledWhenLoading:(BOOL)enabled;
+ (void)ownerPageUserInteractionEnabledWhenException:(BOOL)enabled;

@end
