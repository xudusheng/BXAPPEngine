//
//  NLEStartupManager.h
//  NLAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXBaseManager.h"
#import "BXTaskQueue.h"

@interface BXStartupManager : BXBaseManager

@property (nonatomic, strong) NSDictionary * launchOptions;
@property (nonatomic, assign) BOOL launchTaskQueueFinished;
@property (nonatomic, assign) BOOL isAppGeoBlock;

@property (nonatomic, strong) BXTaskQueue * launchTaskQueue;

+ (BXStartupManager *)sharedManager;
- (void)startupWithLaunchingOptions:(NSDictionary *)launchOptions NS_REQUIRES_SUPER;
- (void)enterMainViewWithLaunchingOptions:(NSDictionary *)launchOptions NS_REQUIRES_SUPER;
- (void)initMainViewLaunchingOptions:(NSDictionary *)launchOptions NS_REQUIRES_SUPER;

- (void)scheduleLaunchTaskQueue NS_REQUIRES_SUPER;

- (void)internetReachableStatusUpdate:(BOOL)isReachable NS_REQUIRES_SUPER;

- (void)applicationWillResignActive NS_REQUIRES_SUPER;
- (void)applicationDidEnterBackground NS_REQUIRES_SUPER;
- (void)applicationWillEnterForeground NS_REQUIRES_SUPER;
- (void)applicationDidBecomeActive NS_REQUIRES_SUPER;
- (void)applicationWillTerminate NS_REQUIRES_SUPER;

@end

FOUNDATION_EXTERN NSString * const kBXEnterMainViewFinishedNotification;

////taskId key
//extern NSString * const NLEFetchConfigTaskIdKey;
//extern NSString * const NLEUpdateLocalizableTaskIdKey;
//extern NSString * const NLEFetchMenuTaskIdKey;
//extern NSString * const NLEAutoLoginTaskIdKey;
//extern NSString * const NLECheckGeoTaskIdKey;
//extern NSString * const NLEFetchPurchaseInfoTaskIdKey;
//extern NSString * const NLEFetchLocationTaskIdKey;
//extern NSString * const NLEFetchTeamsTaskIdKey;
//extern NSString * const NLEFetchSportsTaskIdKey;
//extern NSString * const NLEFetchGlobalDataTaskIdKey;

