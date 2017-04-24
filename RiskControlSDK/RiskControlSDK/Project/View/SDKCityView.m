//
//  SDKCityView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCityView.h"
#import "SDKProjectHeader.h"
#import "SDKSelectView.h"
#import "SDKCommonPickerView.h"
#import "SDKLineView.h"
#import "SDKAboutText.h"
#import "UIView+SDKCustomView.h"
#import "SDKPickerModel.h"
#import "SDKCommonModel.h"

typedef enum : NSUInteger {
    SDKSelectTypeProvince, // 省：0
    SDKSelectTypeCity,     // 市：1
    SDKSelectTypeArea      // 区：2
    
} SDKSelectType;


@interface SDKCityView ()

@property (nonatomic, strong) SDKSelectView *provinceView; // 省
@property (nonatomic, strong) SDKSelectView *cityView;     // 市
@property (nonatomic, strong) SDKSelectView *regionView;   // 区

// mdoel
@property (nonatomic, strong) SDKPickerModel *provinceModel;
@property (nonatomic, strong) SDKPickerModel *cityModel;
@property (nonatomic, strong) SDKPickerModel *areaModel;

@property (nonatomic, strong) SDKCommonModel *currentModel;

@property (nonatomic, strong) NSArray <SDKPickerModel *> *areaList;


@end

@implementation SDKCityView

- (instancetype)initWithFrame:(CGRect)frame  model:(SDKCommonModel *)model list:(NSArray <SDKPickerModel *> *)list {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        _currentModel = model;
        _areaList     = list;
        
        // 省
        _provinceView = [[SDKSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) left:model.label right:model.placeholder list:list];
        _provinceView.sendValue = ^ (SDKPickerModel * provinceM) {
            if (provinceM.text != _provinceModel.text) { // clear
                _cityModel = nil;
                _areaModel = nil;
                
                [_cityView clearValue];
                [_regionView clearValue];
            }
            
            _provinceModel = provinceM;
        };
        [self addSubview:_provinceView];
        
        
        
        // 市
        _cityView = [[SDKSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_provinceView.frame), kScreenWidth, 0) left:model.label2 right:model.placeholder2];
        [self addSubview:_cityView];
        _cityView.sendValue = ^ (SDKPickerModel * cityM) { // clear
            if (cityM.text != _cityModel.text) {
                _areaModel = nil;
                [_regionView clearValue];
            }
            
            _cityModel = cityM;
        };
        [self clickView:_cityView Handle:SDKSelectTypeCity];
        
        
        
        // 区
        _regionView = [[SDKSelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cityView.frame), kScreenWidth, 0) left:model.label3 right:model.placeholder3];
        [self addSubview:_regionView];
        _regionView.sendValue = ^ (SDKPickerModel * regionM) {
            _areaModel = regionM;
        };
        [self clickView:_regionView Handle:SDKSelectTypeArea];
        
        
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
    }
    return self;
}

- (void)clickView:(SDKSelectView *)subView Handle:(SDKSelectType)type {
    [subView addSingleTapEvent:^{
        [self.window endEditing:true];
        
        if (type == SDKSelectTypeCity)
        {
            if (!_provinceModel) { // 未选择省份
                showTipByView(@"请选择省", kKeyWindow);
            } else {
                subView.dataArray = _provinceModel.list;
                [subView nextMethod];
            }
        }
        else if (type == SDKSelectTypeArea)
        {
            if (!_provinceModel) { // 未选择省份
                showTipByView(@"请选择省", kKeyWindow);
            }
            else if (!_cityModel) { // 未选择市
                showTipByView(@"请选择市", kKeyWindow);
            }
            else {
                subView.dataArray = _cityModel.list;
                [subView nextMethod];
            }
        }
        
        
    }];
}

- (void)showContent {
    SDKPickerModel *tmpProvince;
    SDKPickerModel *tmpCity;
    SDKPickerModel *tmpZone;
    for (SDKPickerModel *pickerM in _areaList) {
        if ([pickerM.text isEqualToString:_currentModel.value1]) {
            tmpProvince = pickerM;
            break;
        }
    }
    
    if (!tmpProvince) return;
    [_provinceView showContentWithPickerModel:tmpProvince];
    _provinceModel = tmpProvince;
    
    for (SDKPickerModel *pickerM in tmpProvince.list) {
        if ([pickerM.text isEqualToString:_currentModel.value2]) {
            tmpCity = pickerM;
            break;
        }
    }
    
    if (!tmpCity) return;
    [_cityView showContentWithPickerModel:tmpCity];
    _cityModel = tmpCity;
    
    for (SDKPickerModel *pickerM in tmpCity.list) {
        if ([pickerM.text isEqualToString:_currentModel.value3]) {
            tmpZone = pickerM;
            break;
        }
    }
    
    if (!tmpZone) return;
    [_regionView showContentWithPickerModel:tmpZone];
    _areaModel = tmpZone;
}

- (void)checkDataAndHandle:(void (^)(NSMutableDictionary *, BOOL))handle {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[_currentModel.name]  = _provinceModel.text;
    dic[_currentModel.name2] = _cityModel.text;
    dic[_currentModel.name3] = _areaModel.text;
    
    if (!_currentModel.required) {
        if (handle) {
            handle(dic, true);
        }
    } else {
        if (!_provinceModel) {
            if (handle) {
                handle(nil, false);
            }
            
            self.provinceView.backgroundColor = kErrorColor;
        } else {
            self.provinceView.backgroundColor = commonWhiteColor;;
        }

        
        if (!_cityModel) {
            if (handle) {
                handle(nil, false);
            }
            
            self.cityView.backgroundColor = kErrorColor;
        } else {
            self.cityView.backgroundColor = commonWhiteColor;;
        }
        
        if (!_areaModel) {
            if (handle) {
                handle(nil, false);
            }
            
            self.regionView.backgroundColor = kErrorColor;
        } else {
            self.regionView.backgroundColor = commonWhiteColor;;
        }
        
        
        if (_provinceModel && _cityModel && _areaModel) {
            if (handle) {
                handle(dic, true);
            }
        }
    }
}


@end
