//
//  SDKLevelTwoPickerView.m
//  MN_PickerView_Demo
//
//  Created by 栾美娜 on 16/1/11.
//  Copyright © 2016年 范宏泳. All rights reserved.
//

#import "SDKLevelTwoPickerView.h"
#import "SDKProjectHeader.h"

@interface SDKLevelTwoPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic,strong) UIPickerView *chinaPickerView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) NSMutableArray *cityArray;

@property(nonatomic,strong) NSString *provinceStr;
@property(nonatomic,strong) NSString *cityStr;
@property (assign, nonatomic) NSInteger areaId;
@property (nonatomic, strong) SDKProvinceModel *provinceM;
@property (strong, nonatomic) CityModel *tempModel;

@end

@implementation SDKLevelTwoPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    UIView *bottomView = [[UIView alloc] initWithFrame:resetRectXYWH(0, 0, kScreenWidth, 205)];
    bottomView.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *upView = [[UIView alloc] initWithFrame:resetRectXYWH(0, 0, 320, 40)];
    upView.backgroundColor = commonBlueColor;
    [bottomView addSubview:upView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = resetRectXYWH(0, 0, 80, 40);
    cancelBtn.titleLabel.font = mediumFont(16.0);
    cancelBtn.backgroundColor = commonClearColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:commonWhiteColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:cancelBtn];
    
    UIButton *determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    determineBtn.frame = resetRectXYWH(kScreenWidth-80, 0, 80, 40);
    determineBtn.titleLabel.font = mediumFont(16.0);
    determineBtn.backgroundColor = commonClearColor;
    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [determineBtn setTitleColor:commonWhiteColor forState:UIControlStateNormal];
    [determineBtn addTarget:self action:@selector(determineAction:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:determineBtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:resetRectXYWH(80, 0, kScreenWidth-80*2, 40)];
    _titleLabel.font = lightMaxFont(14.0);
    _titleLabel.textColor = UIColorFromRGB(0xcde6f7);
    _titleLabel.text = @"请选择缴纳城市";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [upView addSubview:_titleLabel];
    
    _chinaPickerView = [[UIPickerView alloc] initWithFrame:resetRectXYWH(0, 40, 320, 205 - 10)];
    _chinaPickerView.dataSource = self;
    _chinaPickerView.delegate   = self;
    [bottomView addSubview:_chinaPickerView];
   
}

/** 取消 */
- (void)cancelAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SDKLevelTwoPickerView:cancelBtnDidclicked:)]) {
        [self.delegate SDKLevelTwoPickerView:self cancelBtnDidclicked:sender];
    }
}

/** 确定 */
- (void)determineAction:(UIButton *)sender {
    
    if (!_provinceStr && !_cityStr) {
        [self pickerView:_chinaPickerView didSelectRow:0 inComponent:0];
        [self pickerView:_chinaPickerView didSelectRow:0 inComponent:1];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(SDKLevelTwoPickerView:determineBtnDidclicked:CityModel:title:)]) {
        [self.delegate SDKLevelTwoPickerView:self determineBtnDidclicked:sender CityModel:_tempModel title:_titleLabel.text];
    }
    
}

#pragma mark - pickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? self.provinceArray.count : self.cityArray.count;
}

#pragma mark - pickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
    {
        SDKProvinceModel *provinceM = self.provinceArray[row];
        return provinceM.province;
    }
    else
    {
        SDKCityModel *cityM = self.cityArray[row];
        return cityM.area;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0)
    {
        SDKProvinceModel *provinceM = self.provinceArray[row];
        self.cityArray = provinceM.areaList;
        [_chinaPickerView selectRow:0 inComponent:1 animated:NO];
        [_chinaPickerView reloadComponent:1];
        
        // assign
        _provinceStr = provinceM.province;
        SDKCityModel *cityM = self.cityArray[0];
        _cityStr = cityM.area;
        _areaId  = cityM.areaId;
        
        _tempModel = cityM;
    }
    else
    {
        // assign
        SDKCityModel *cityM = self.cityArray[row];
        _cityStr = cityM.area;
        _areaId  = cityM.areaId;
        
        _tempModel = cityM;
    }
    
    // assign
    if (!_provinceStr) {
        SDKProvinceModel *pro = self.provinceArray[0];
        _provinceStr = pro.province;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@%@", _provinceStr, _cityStr];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:resetRectXYWH(0.0, 0.0, kScreenWidth/2, 40)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.backgroundColor = [UIColor clearColor];
    myView.numberOfLines = 0;
    myView.font = [UIFont systemFontOfSize:18.0];
    if (component == 0) {
        SDKProvinceModel *provinceM = self.provinceArray[row];
        myView.text = provinceM.province;
    }
    else
    {
        SDKCityModel *cityM = self.cityArray[row];
        myView.text = cityM.area;
    }

    return myView;
}



#pragma mark -
- (void)setupData{
    if (!_provinceM) {
        _provinceM = self.provinceArray[0];
        self.cityArray = _provinceM.areaList;
    }
}
- (void)setupDataA{
    _provinceM = self.provinceArray[0];
    self.cityArray = _provinceM.areaList;
}
@end
