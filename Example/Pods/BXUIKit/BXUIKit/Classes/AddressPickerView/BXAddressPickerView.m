//
//  BXAddressPickerView.m
//  BiXuan
//
//  Created by Hmily on 2018/10/19.
//  Copyright © 2018年 碧斯诺兰. All rights reserved.
//

#import "BXAddressPickerView.h"
#import "BXAddressPickerHeader.h"
#import "UIButton+BXAddressPicker.h"
#import "UIView+BXAddressPicker.h"
#define TOOLBAR_BUTTON_WIDTH BXDP_SCALE_WIGTH(65)

typedef NS_ENUM(NSInteger, BXAddressPickerViewButtonType) {
    BXAddressPickerViewButtonTypeCancle,
    BXAddressPickerViewButtonTypeSure
};

typedef NS_ENUM(NSInteger, BXAddressPickerViewType) {
    //只显示省
    BXAddressPickerViewTypeProvince = 1,
    //显示省份和城市
    BXAddressPickerViewTypeCity,
    //显示省市区，默认
    BXAddressPickerViewTypeArea
};


@implementation BXProvinceModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cityList":@"BXCityModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"province_id":@"id"};
}
- (NSString *)name{
    return _name?_name:@"";
}
- (NSString *)province_id {
    return _province_id?_province_id:@"";
}
@end

@implementation BXCityModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cityList":@"BXAreaModel"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"city_id":@"id"};
}
- (NSString *)name{
    return _name?_name:@"";
}
- (NSString *)city_id {
    return _city_id?_city_id:@"";
}
@end

@implementation BXAreaModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"area_id":@"id"};
}
- (NSString *)name{
    return _name?_name:@"";
}
- (NSString *)area_id {
    return _area_id?_area_id:@"";
}
@end

@interface BXAddressPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
///<#注释#>
@property (nonatomic, assign) NSInteger columnCount;
///容器view
@property (nonatomic, weak) UIView *containView;
///
@property(nonatomic, strong) UIPickerView *pickerView;
///省
@property(nonatomic, strong) NSArray<BXProvinceModel*> *provinceArray;
///市
@property(nonatomic, strong) NSArray<BXCityModel*> *cityArray;
///区
@property(nonatomic, strong) NSArray<BXAreaModel *> *areaArray;
///所有数据
@property(nonatomic, strong) NSArray *dataSource;
///记录省选中的位置
@property(nonatomic, assign) NSInteger selectProvinceIndex;
//显示类型
@property (nonatomic, assign) BXAddressPickerViewType showType;
///传进来的默认选中的省
@property(nonatomic, strong) BXProvinceModel *selectProvince;
///传进来的默认选中的市
@property(nonatomic, strong) BXCityModel *selectCity;
///传进来的默认选中的区
@property(nonatomic, strong) BXAreaModel *selectArea;
///省份回调
@property (nonatomic, copy) void (^provinceBlock)(BXProvinceModel *province);
///城市回调
@property (nonatomic, copy) void (^cityBlock)(BXProvinceModel *province, BXCityModel *city);
///区域回调
@property (nonatomic, copy) void (^areaBlock)(BXProvinceModel *province, BXCityModel *city, BXAreaModel *area);
@end


@implementation BXAddressPickerView
    
    /**
     获取文件所在name，默认情况下podName和bundlename相同，传一个即可
     
     @param bundleName bundle名字，就是在resource_bundles里面的名字
     @param podName pod的名字
     @return bundle
     */
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
    NSLog(@"%@ = %@", bundleName, podName);
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}
    
+ (NSArray<BXProvinceModel*>*)getAllProvince {
    
    NSBundle *bundle = [self bundleWithBundleName:@"city" podName:@"BXUIKit"];
    
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    if (jsonData == nil) {
        return @[];
    }
    NSError *error= nil;
    NSArray *privinceDicList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil) {
        return @[];
    }
    if (![privinceDicList isKindOfClass:[NSArray class]]) {
        return @[];
    }
    
    NSMutableArray *privinceModelList = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *privinceDic in privinceDicList) {
        BXProvinceModel *provinceModel = [[BXProvinceModel alloc] init];
        provinceModel.province_id = privinceDic[@"id"];
        provinceModel.name = privinceDic[@"name"];
        
        NSArray *cityDicList = privinceDic[@"cityList"];
        NSMutableArray *cityModelList = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *cityDic in cityDicList) {
            BXCityModel *cityModel = [[BXCityModel alloc] init];
            cityModel.city_id = cityDic[@"id"];
            cityModel.name = cityDic[@"name"];
            NSArray *areaDicList = cityDic[@"cityList"];
            NSMutableArray *areaModelList = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *areaDic in areaDicList) {
                BXAreaModel *areaModel = [[BXAreaModel alloc] init];
                areaModel.area_id = areaDic[@"id"];
                areaModel.name = areaDic[@"name"];
                [areaModelList addObject:areaModel];
            }
            cityModel.cityList = areaModelList;
            [cityModelList addObject:cityModel];
        }
        provinceModel.cityList = cityModelList;
        [privinceModelList addObject:provinceModel];
    }
    
    return privinceModelList;
}
/**
 *只显示省份一级
 *provinceBlock : 回调省份
 */
+ (instancetype)provincePickerViewWithProvinceBlock:(void(^)(BXProvinceModel *province))provinceBlock {
    return [BXAddressPickerView addressPickerViewWithProvince:nil city:nil area:nil provinceBlock:provinceBlock cityBlock:nil areaBlock:nil showType:BXAddressPickerViewTypeProvince];
}

/**
 *显示省份和市级
 *cityBlock : 回调省份和城市
 */
+ (instancetype)cityPickerViewWithCityBlock:(void(^)(BXProvinceModel *province, BXCityModel *city))cityBlock {
    return [BXAddressPickerView addressPickerViewWithProvince:nil
                                                         city:nil
                                                         area:nil
                                                provinceBlock:nil
                                                    cityBlock:cityBlock
                                                    areaBlock:nil
                                                     showType:BXAddressPickerViewTypeCity];
}

/**
 *显示省份和市级和区域
 *areaBlock : 回调省份城市和区域
 */
+ (instancetype)areaPickerViewWithAreaBlock:(void(^)(BXProvinceModel *province, BXCityModel *city, BXAreaModel *area))areaBlock {
    return [BXAddressPickerView addressPickerViewWithProvince:nil city:nil area:nil provinceBlock:nil cityBlock:nil areaBlock:areaBlock showType:BXAddressPickerViewTypeArea];
}

/**
 *只显示省份一级
 *province : 传入了省份自动滚动到省份，没有传或者找不到默认选中第一个
 *provinceBlock : 回调省份
 */
+ (instancetype)provincePickerViewWithProvince:(BXProvinceModel *)province provinceBlock:(void(^)(BXProvinceModel *province))provinceBlock {
    return [BXAddressPickerView addressPickerViewWithProvince:province city:nil area:nil provinceBlock:provinceBlock cityBlock:nil areaBlock:nil showType:BXAddressPickerViewTypeProvince];
}

/**
 *显示省份和市级
 *province,city : 传入了省份和城市自动滚动到选中的，没有传或者找不到默认选中第一个
 *cityBlock : 回调省份和城市
 */
+ (instancetype)cityPickerViewWithProvince:(BXProvinceModel *)province city:(BXCityModel *)city cityBlock:(void(^)(BXProvinceModel *province, BXCityModel *city))cityBlock {
    return [BXAddressPickerView addressPickerViewWithProvince:province city:city area:nil provinceBlock:nil cityBlock:cityBlock areaBlock:nil showType:BXAddressPickerViewTypeCity];
}

/**
 *显示省份和市级和区域
 *province,city : 传入了省份和城市和区域自动滚动到选中的，没有传或者找不到默认选中第一个
 *areaBlock : 回调省份城市和区域
 */
+ (instancetype)areaPickerViewWithProvince:(BXProvinceModel *)province city:(BXCityModel *)city area:(BXAreaModel *)area areaBlock:(void(^)(BXProvinceModel *province, BXCityModel *city, BXAreaModel *area))areaBlock {
    return [BXAddressPickerView addressPickerViewWithProvince:province
                                                         city:city
                                                         area:area
                                                provinceBlock:nil
                                                    cityBlock:nil
                                                    areaBlock:areaBlock
                                                     showType:BXAddressPickerViewTypeArea];
}




+ (instancetype)addressPickerViewWithProvince:(BXProvinceModel *)province
                                         city:(BXCityModel *)city
                                         area:(BXAreaModel *)area
                                provinceBlock:(void(^)(BXProvinceModel *province))provinceBlock
                                    cityBlock:(void(^)(BXProvinceModel *province, BXCityModel *city))cityBlock
                                    areaBlock:(void(^)(BXProvinceModel *province, BXCityModel *city, BXAreaModel *area))areaBlock
                                     showType:(BXAddressPickerViewType)showType {
    
    BXAddressPickerView *_view = [[BXAddressPickerView alloc] init];
    
    _view.showType = showType;
    
    _view.selectProvince = province;
    
    _view.selectCity = city;
    
    _view.selectArea = area;
    
    _view.provinceBlock = provinceBlock;
    
    _view.cityBlock = cityBlock;
    
    _view.areaBlock = areaBlock;
    
    [_view getData];
    
    [_view showView];
    
    return _view;
}

- (instancetype)init {
    if (self = [super init]) {
        [self bx_setView];
    }
    return self;
}



- (void)bx_setView {
    
    self.frame = CGRectMake(0, 0, BXDP_SCREEN_WIDTH, BXDP_SCREEN_HEIGHT);
    UIButton *bgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgbtn.tag = BXAddressPickerViewButtonTypeCancle;
    bgbtn.frame = self.frame;
    [bgbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgbtn];
    
    UIView *containView = [[UIView alloc] init];
    containView.frame = CGRectMake(0, BXDP_SCREEN_HEIGHT, BXDP_SCREEN_WIDTH, BXDP_SCALE_HEIGHT(256));
    [self addSubview:containView];
    self.containView = containView;
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, 0, BXDP_SCREEN_WIDTH, BXDP_SCALE_HEIGHT(40));
    toolBar.backgroundColor = BXDP_COLOR(0xf6f6f6);
    [containView addSubview:toolBar];
    
    UIButton *cancleButton = [UIButton bx_buttonWithTarget:self action:@selector(buttonClick:) frame:CGRectMake(0, 0, TOOLBAR_BUTTON_WIDTH, toolBar.height) titleColor:BXDP_COLOR(0x333333) titleFont:[UIFont systemFontOfSize:14] title:@"取消"];
    cancleButton.tag = BXAddressPickerViewButtonTypeCancle;
    [toolBar addSubview:cancleButton];
    
    UIButton *sureButton = [UIButton bx_buttonWithTarget:self action:@selector(buttonClick:) frame:CGRectMake(toolBar.width - TOOLBAR_BUTTON_WIDTH, 0, TOOLBAR_BUTTON_WIDTH, toolBar.height) titleColor:BXDP_COLOR(0x333333) titleFont:[UIFont systemFontOfSize:14] title:@"确定"];
    sureButton.tag = BXAddressPickerViewButtonTypeSure;
    [toolBar addSubview:sureButton];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = BXDP_COLOR(0xffffff);
    pickerView.frame = CGRectMake(0, toolBar.bottom, BXDP_SCREEN_WIDTH, containView.height - toolBar.height);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [containView addSubview:pickerView];
    self.pickerView = pickerView;
}

//获取数据
- (void)getData {
    //省
    self.provinceArray =[BXAddressPickerView getAllProvince];
    if (self.provinceArray.count < 1) {
        return;
    }

    
    NSInteger provinceIndex = 0;
    NSInteger cityIndex = 0;
    NSInteger areaIndex = 0;
    
    BXProvinceModel *selectedProvinceModel = nil;
    BXCityModel *selectCityModel = nil;
    BXAreaModel *selectedAreaModel = nil;
    //市
    NSArray *cityArray = @[];
    //区
    NSArray *areaArray = @[];
    
    for (BXProvinceModel *provinceModel in self.provinceArray) {
        if ([self.selectProvince.name isEqualToString:provinceModel.name] || [self.selectProvince.province_id isEqualToString:provinceModel.province_id]) {
            selectedProvinceModel = provinceModel;
            cityArray = selectedProvinceModel.cityList;
            for (BXCityModel *cityModel in provinceModel.cityList) {
                if ([self.selectCity.name isEqualToString:cityModel.name] || [self.selectCity.city_id isEqualToString:cityModel.city_id]) {
                    selectCityModel = cityModel;
                    areaArray = selectCityModel.cityList;
                    for (BXAreaModel *areaModel in cityModel.cityList) {
                        if ([self.selectArea.name isEqualToString:areaModel.name] || [self.selectArea.area_id isEqualToString:areaModel.area_id]) {
                            selectedAreaModel = areaModel;
                            break;
                        }
                    }
                    break;
                }
            }
            break;
        }
    }
    self.selectProvince = selectedProvinceModel;
    self.selectCity = selectCityModel;
    self.selectArea = selectedAreaModel;
    
    //市
    self.cityArray = cityArray.count < 1 ? self.provinceArray.firstObject.cityList : cityArray;
    //区
    self.areaArray = areaArray.count < 1 ? self.cityArray.firstObject.cityList : areaArray;;
    //如果没有传入默认选中的省市区，默认选中各个数组的第一个
    if (!self.selectProvince) {
        self.selectProvince = self.provinceArray.firstObject;
    }
    if (!self.selectCity) {
        self.selectCity = self.cityArray.firstObject;
    }
    if (!self.selectArea) {
        self.selectArea = self.areaArray.firstObject;
    }
    
    self.selectProvinceIndex = [self.provinceArray indexOfObject:self.selectProvince];
    provinceIndex = self.selectProvinceIndex;
    cityIndex = [self.selectProvince.cityList indexOfObject:self.selectCity];
    areaIndex = [self.selectCity.cityList indexOfObject:self.selectArea];

    if (self.showType == BXAddressPickerViewTypeProvince) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
    } else if (self.showType == BXAddressPickerViewTypeCity) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
    } else if (self.showType == BXAddressPickerViewTypeArea) {
        [self.pickerView selectRow:provinceIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:cityIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:areaIndex inComponent:2 animated:YES];
    }
    
}


- (void)buttonClick:(UIButton *)sender {
    
    [self hideView];
    
    if (sender.tag == BXAddressPickerViewButtonTypeSure) {
        
        if (_provinceBlock) {
            _provinceBlock(self.selectProvince);
        }
        if (_cityBlock) {
            _cityBlock(self.selectProvince, self.selectCity);
        }
        if (_areaBlock) {
            if (self.selectArea == nil) {
                self.selectArea = [[BXAreaModel alloc] init];
                self.selectArea.name = @"";
                self.selectArea.area_id = @"";
            }
            _areaBlock(self.selectProvince, self.selectCity, self.selectArea);
        }
    }
}

#pragma mark -- UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.columnCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }else if (component == 1){
        return self.cityArray.count;
    }else if (component == 2){
        return self.areaArray.count;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 30)];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        label.text = self.provinceArray[row].name;
    }else if (component == 1){
        label.text = self.cityArray[row].name;
    }else if (component == 2){
        label.text = self.areaArray[row].name;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {//选择省
        self.selectProvinceIndex = row;
        BXProvinceModel *selectProvince = self.provinceArray[row];
        if (self.showType == BXAddressPickerViewTypeProvince) {
            self.selectProvince = selectProvince;
            self.selectCity = nil;
            self.selectArea = nil;
        } else if (self.showType == BXAddressPickerViewTypeCity) {
            self.cityArray = selectProvince.cityList;
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            
            self.selectProvince = self.provinceArray[row];
            self.selectCity = self.cityArray[0];
            self.selectArea = nil;
        } else if (self.showType == BXAddressPickerViewTypeArea) {
            
            self.cityArray = selectProvince.cityList;
            self.areaArray = self.cityArray.firstObject.cityList;
            
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            
            self.selectProvince = self.provinceArray[row];
            self.selectCity = self.cityArray[0];
            self.selectArea = self.areaArray[0];
        }
    }else if (component == 1){//选择市
        BXCityModel *selectedCityModel = self.cityArray[row];
        if (self.showType == BXAddressPickerViewTypeCity) {
            self.selectCity = selectedCityModel;
            self.selectArea = nil;
        } else if (self.showType == BXAddressPickerViewTypeArea) {
            
            self.areaArray = selectedCityModel.cityList;
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            self.selectCity = selectedCityModel;
            self.selectArea = self.areaArray.firstObject;
        }
    }else if (component == 2){//选择区
        
        if (self.showType == BXAddressPickerViewTypeArea && self.areaArray.count > 0) {
            self.selectArea = self.areaArray[row];
        }
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}




- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = BXDP_RGB_COLOR(0x000000, 0.3);
        self.containView.bottom = BXDP_SCREEN_HEIGHT;
    }];
}

- (void)hideView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containView.y = BXDP_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)setShowType:(BXAddressPickerViewType)showType {
    _showType = showType;
    self.columnCount = showType;
    
    [self.pickerView reloadAllComponents];
}



- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}


- (NSArray<BXProvinceModel*> *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSArray array];
    }
    return _provinceArray;
}

- (NSArray<BXCityModel*> *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSArray array];
    }
    return _cityArray;
}

- (NSArray<BXAreaModel*> *)areaArray
{
    if (!_areaArray) {
        _areaArray = [NSArray array];
    }
    return _areaArray;
}


@end
