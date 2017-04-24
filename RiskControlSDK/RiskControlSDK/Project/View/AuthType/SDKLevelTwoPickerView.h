//
//  SDKLevelTwoPickerView.h
//  MN_PickerView_Demo
//
//  Created by 栾美娜 on 16/1/11.
//  Copyright © 2016年 范宏泳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKProvinceModel.h"

@class SDKLevelTwoPickerView, CityModel;
@protocol SDKLevelTwoPickerViewDelegate <NSObject>
@required

- (void)SDKLevelTwoPickerView:(SDKLevelTwoPickerView *)LevelTwoPickerView cancelBtnDidclicked:(UIButton *)cancelBtn;
//- (void)LevelTwoPickerView:(LevelTwoPickerView *)LevelTwoPickerView determineBtnDidclicked:(UIButton *)determine areaId:(NSInteger)areaId;
//- (void)LevelTwoPickerView:(LevelTwoPickerView *)LevelTwoPickerView determineBtnDidclicked:(UIButton *)determine CityModel:(CityModel *)CityModel;

- (void)SDKLevelTwoPickerView:(SDKLevelTwoPickerView *)LevelTwoPickerView determineBtnDidclicked:(UIButton *)determine CityModel:(SDKCityModel *)CityModel title:(NSString *)title;
@end

@interface SDKLevelTwoPickerView : UIView

@property(nonatomic,strong) NSMutableArray *provinceArray;
@property (strong, nonatomic) SDKProvinceModel *chooseModel;

@property (nonatomic,strong) UILabel *titleLabel;

@property (assign, nonatomic) id<SDKLevelTwoPickerViewDelegate> delegate;

- (void)setupData;
- (void)setupDataA;
@end
