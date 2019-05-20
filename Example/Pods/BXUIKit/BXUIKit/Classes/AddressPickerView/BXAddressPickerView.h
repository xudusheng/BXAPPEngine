//
//  BXAddressPickerView.h
//  BiXuan
//
//  Created by Hmily on 2018/10/19.
//  Copyright © 2018年 碧斯诺兰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface BXAreaModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *area_id;
@end

@interface BXCityModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *city_id;
@property (nonatomic,strong) NSArray<BXAreaModel*> *cityList;
@end

@interface BXProvinceModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *province_id;
@property (nonatomic,strong) NSArray<BXCityModel*> *cityList;
@end

@interface BXAddressPickerView : UIView

+ (NSArray<BXProvinceModel*>*)getAllProvince;

/**
 * 只显示省份一级
 * provinceBlock : 回调省份
 */
+ (instancetype)provincePickerViewWithProvinceBlock:(void(^)(BXProvinceModel *province))provinceBlock;

/**
 * 显示省份和市级
 * cityBlock : 回调省份和城市
 */
+ (instancetype)cityPickerViewWithCityBlock:(void(^)(BXProvinceModel *province, BXCityModel *city))cityBlock;

/**
 * 显示省份和市级和区域
 * areaBlock : 回调省份城市和区域
 */
+ (instancetype)areaPickerViewWithAreaBlock:(void(^)(BXProvinceModel *province, BXCityModel *city, BXAreaModel *area))areaBlock;

/**
 * 只显示省份一级
 * province : 传入了省份自动滚动到省份，没有传或者找不到默认选中第一个
 * provinceBlock : 回调省份
 */
+ (instancetype)provincePickerViewWithProvince:(BXProvinceModel *)province provinceBlock:(void(^)(BXProvinceModel *province))provinceBlock;

/**
 * 显示省份和市级
 * province,city : 传入了省份和城市自动滚动到选中的，没有传或者找不到默认选中第一个
 * cityBlock : 回调省份和城市
 */
+ (instancetype)cityPickerViewWithProvince:(BXProvinceModel *)province city:(BXCityModel *)city cityBlock:(void(^)(BXProvinceModel *province, BXCityModel *city))cityBlock;

/**
 * 显示省份和市级和区域
 * province,city : 传入了省份和城市和区域自动滚动到选中的，没有传或者找不到默认选中第一个
 * areaBlock : 回调省份城市和区域
 */
+ (instancetype)areaPickerViewWithProvince:(BXProvinceModel *_Nullable)province
                                      city:(BXCityModel *_Nullable)city
                                      area:(BXAreaModel *_Nullable)area
                                 areaBlock:(void(^)(BXProvinceModel *province, BXCityModel *city, BXAreaModel *area))areaBlock;


@end

NS_ASSUME_NONNULL_END
