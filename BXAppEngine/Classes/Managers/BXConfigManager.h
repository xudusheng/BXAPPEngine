//
//  BXConfigManager.h
//  Kit
//
//  Created by Hmily on 2018/7/22.
//  Copyright © 2018年 Hmily. All rights reserved.
//

#import "BXBaseManager.h"
#import "BXConfigItem.h"
@interface BXConfigManager : BXBaseManager

+ (BXConfigManager *)sharedManager;

@property (nonatomic, strong) BXConfigItem *configItem;

- (void)fetchAppConfigWithURL:(NSString *)urlString;

@end
