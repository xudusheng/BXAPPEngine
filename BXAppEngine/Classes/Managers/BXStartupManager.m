//
//  NLEStartupManager.m
//  NLAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//

#import "BXStartupManager.h"
#import "BXBaseAppDelegate.h"
#import "BXRootViewController.h"

#import "BXSettingsManager.h"
#import "BXDeepLinkManager.h"

@interface BXStartupManager ()

//@property (nonatomic, strong) NLReachability *internetReachability;
//
//- (void)addReachabilityForInternetNotification;
//- (void)removeReachabilityForInternetNotification;

@end

@implementation BXStartupManager

+ (BXStartupManager *)sharedManager
{
    static BXStartupManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self instanceClass] alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public methods

- (void)startupWithLaunchingOptions:(NSDictionary *)launchOptions
{
    //Global settings
    [[BXSettingsManager sharedManager] setGlobalSettings];
    
    //UI style
    [[BXSettingsManager sharedManager] setUIStyle];
    
    //
    [[BXSettingsManager sharedManager] setupAfterLaunch];
    
    
    self.launchOptions = launchOptions;
    
    [self addReachabilityForInternetNotification];
    
    [self removeApplicationNotifications];
    [self addApplicationNotifications];
    
    //init root view controller
    BXRootViewController *rootViewController = [BXRootViewController sharedRootViewController];
    BXBaseAppDelegate *delegate = (BXBaseAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = rootViewController;

//    NLEPlaceholdSplashViewController * customPlaceholdSplashVC = [[NLESettingsManager sharedManager] customPlaceholdSplashViewController];
//    if (customPlaceholdSplashVC) {
//        [[NLEUIUtils sharedUtils] showPlaceholderSplashViewWithViewController:customPlaceholdSplashVC];
//    }else {
//        [[NLEUIUtils sharedUtils] showPlaceholderSplashView];
//    }
    
    
    
    [self scheduleLaunchTaskQueue];
}

- (void)enterMainViewWithLaunchingOptions:(NSDictionary *)launchOptions
{
    if (!self.launchTaskQueueFinished) {
        [[BXSettingsManager sharedManager] setOnlyOnceWhenLaunchTaskQueueFinished];
        [self initMainViewLaunchingOptions:launchOptions];
//        [[NLEUIUtils sharedUtils] removePlaceholderSplashView];
        
        self.launchTaskQueueFinished = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kBXEnterMainViewFinishedNotification object:nil];
    }

    //handle url deeplink
    if ([BXDeepLinkManager sharedManager].urlDeepLinkOpenURL) {
        [[BXDeepLinkManager sharedManager] handleURLDeepLinkWithOpenURL:[BXDeepLinkManager sharedManager].urlDeepLinkOpenURL];
        [BXDeepLinkManager sharedManager].urlDeepLinkOpenURL = nil;
    }

    //handle apns deeplink
    if ([BXDeepLinkManager sharedManager].apnsDeepLinkInfo) {
        [[BXDeepLinkManager sharedManager] handleAPNSDeepLinkWithUserInfo:[BXDeepLinkManager sharedManager].apnsDeepLinkInfo needShowMessage:[BXDeepLinkManager sharedManager].apnsDeepLinkNeedShowMessage];
        [BXDeepLinkManager sharedManager].apnsDeepLinkInfo = nil;
        [BXDeepLinkManager sharedManager].apnsDeepLinkNeedShowMessage = NO;
    }
    
//    //handle rating
//    [NLERate sharedInstance].mainWindowIsAvailable = YES;
    
}

- (void)initMainViewLaunchingOptions:(NSDictionary *)launchOptions
{
    
}

- (void)scheduleLaunchTaskQueue
{
    self.launchTaskQueue = [BXTaskQueue taskQueue];
    
}

- (void)applicationWillResignActive
{
    
}

- (void)applicationDidEnterBackground
{
    if (self.isAppGeoBlock) {
        exit(0);
    }
}

- (void)applicationWillEnterForeground
{
    if (self.launchTaskQueueFinished) {
        [self scheduleLaunchTaskQueue];
    }
}

- (void)applicationDidBecomeActive
{
    
}

- (void)applicationWillTerminate
{
    
}

- (void)internetReachableStatusUpdate:(BOOL)isReachable
{
    
}


#pragma mark - Private methods

- (void)addReachabilityForInternetNotification
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nlReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:nlReachabilityChangedNotification object:nil];
//    self.internetReachability = [NLReachability reachabilityForInternetConnection];
//    [self.internetReachability startNotifier];
}

- (void)removeReachabilityForInternetNotification
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:nlReachabilityChangedNotification object:nil];
//    [self.internetReachability stopNotifier];
//    self.internetReachability = nil;
}

- (void)reachabilityChanged:(NSNotification *)note
{
//    NLReachability *curReach = [note object];
//    if(curReach == self.internetReachability){
//
//        NLNetworkStatus remoteHostStatus = [self.internetReachability currentReachabilityStatus];
//
//        BOOL reachable = NO;
//        if (remoteHostStatus == NLNotReachable) {
//            reachable = NO;
//        }else {
//            reachable = YES;
//        }
//
//        [self internetReachableStatusUpdate:reachable];
//    }
}

- (void)addApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)removeApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

@end

NSString * const kBXEnterMainViewFinishedNotification = @"BXEnterMainViewFinishedNotification";

//NSString * const NLEFetchConfigTaskIdKey = @"NLEFetchConfigTaskIdKey";
//NSString * const NLEUpdateLocalizableTaskIdKey = @"NLEUpdateLocalizableTaskIdKey";
//NSString * const NLEFetchMenuTaskIdKey = @"NLEFetchMenuTaskIdKey";
//NSString * const NLEAutoLoginTaskIdKey = @"NLEAutoLoginTaskIdKey";
//NSString * const NLECheckGeoTaskIdKey = @"NLECheckGeoTaskIdKey";
//NSString * const NLEFetchPurchaseInfoTaskIdKey = @"NLEFetchPurchaseInfoTaskIdKey";
//NSString * const NLEFetchLocationTaskIdKey = @"NLEFetchLocationTaskIdKey";
//NSString * const NLEFetchTeamsTaskIdKey = @"NLEFetchTeamsTaskIdKey";
//NSString * const NLEFetchSportsTaskIdKey = @"NLEFetchSportsTaskIdKey";
//NSString * const NLEFetchGlobalDataTaskIdKey = @"NLEFetchGlobalDataTaskIdKey";
