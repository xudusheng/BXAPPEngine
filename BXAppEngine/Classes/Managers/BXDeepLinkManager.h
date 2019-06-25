//
//  BXDeepLinkManager.h
//  BXAppEngine
//
//  Copyright (c) 2014 NeuLion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BXBaseManager.h"

@interface BXDeepLinkManager : BXBaseManager

@property (nonatomic, strong) NSURL * urlDeepLinkOpenURL;
@property (nonatomic, strong) NSDictionary * apnsDeepLinkInfo;
@property (nonatomic, assign) BOOL apnsDeepLinkNeedShowMessage;

+ (BXDeepLinkManager *)sharedManager;

- (void)handleURLDeepLinkWithOpenURL:(NSURL *)url;

- (void)handleAPNSDeepLinkWithUserInfo:(NSDictionary *)userInfo needShowMessage:(BOOL)showMessage;


@end
