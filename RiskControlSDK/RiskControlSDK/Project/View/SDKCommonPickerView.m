//
//  SDKCommonPickerView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCommonPickerView.h"
#import "SDKPickerModel.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKCustomLabel.h"

@interface SDKCommonPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) SDKCustomLabel *textLab;
@property (strong, nonatomic) UIButton *ensureButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray <SDKPickerModel *> *dataArray;

@property (nonatomic, strong) SDKPickerModel *selectedModel;

@end

@implementation SDKCommonPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setList:(NSMutableArray<SDKPickerModel *> *)list {
    _list = list;
    
    _dataArray = list.copy;
}

- (instancetype)initWithList:(NSArray <SDKPickerModel *> *)list {
    self = [super init];
    if (self) {
        if (list && list.count) {
            _dataArray = list;
            [self initUI];
        } else {
            showTipByView(@"无数据", kKeyWindow);
        }
    }
    
    return self;
}

- (void)initUI {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    CGFloat basicViewH = adaptY(205);
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, basicViewH)];
    _container.backgroundColor = [UIColor whiteColor];
    [self addSubview:_container];
    
    // up
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(45))];
    upView.backgroundColor = commonBlueColor;
    [_container addSubview:upView];
    
    _textLab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(0, 0, kScreenWidth, adaptY(45)) setLabelColor:UIColorFromRGB(0xcde6f7) setLabelFont:kMediumFont(16.0) setAlignment:1];
    [upView addSubview:_textLab];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(adaptX(20), 0, adaptX(40), adaptY(45));
    self.cancelButton.titleLabel.font = kMediumFont(16.0);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:self.cancelButton];
    
    self.ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ensureButton.frame = CGRectMake(kScreenWidth-adaptX(60), 0, adaptX(40), adaptY(45));
    self.ensureButton.titleLabel.font = kMediumFont(16.0);
    self.ensureButton.backgroundColor = [UIColor clearColor];
    [self.ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.ensureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [upView addSubview:self.ensureButton];
    [self.ensureButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // bottom
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upView.frame), kScreenWidth, basicViewH-adaptY(45))];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_container addSubview:_pickerView];
    
}

- (void)show {
    if (_dataArray == nil || _dataArray.count == 0) return;
    
    _selectedModel = _dataArray[0];
    _textLab.text  = _selectedModel.text; // default;
    
    [kKeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5f animations:^{
        _container.y -= _container.height;
    }];
}

- (void)clickAction:(UIButton *)sender {
    if (sender == _ensureButton) {
        !_sendValue ? : _sendValue(_selectedModel);
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _container.y = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - pickerView datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *str = self.dataArray[row].text;
    NSMutableAttributedString *mutaleStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : kFont(14), NSForegroundColorAttributeName : kNavTitleColor}];
    return mutaleStr;
}

#pragma mark - pickerView deleagte
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return adaptY(40);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.textLab.text = self.dataArray[row].text;
    
    _selectedModel = self.dataArray[row]; //record
}


#pragma mark - lazy load
- (NSArray <SDKPickerModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


@end
