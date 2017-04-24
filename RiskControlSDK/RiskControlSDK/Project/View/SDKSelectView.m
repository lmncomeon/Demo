//
//  SDKSelectView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKSelectView.h"
#import "SDKCommonPickerView.h"
#import "SDKLineView.h"
#import "SDKAboutText.h"
#import "SDKPickerModel.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKCustomLabel.h"

@interface SDKSelectView ()

@property (nonatomic, strong) SDKCustomLabel *rightLab;
@property (nonatomic, copy) NSString *rightText;

@property (nonatomic, strong) SDKPickerModel *model;

@end

@implementation SDKSelectView

- (instancetype)initWithFrame:(CGRect)frame left:(NSString *)left right:(NSString *)right list:(NSArray <SDKPickerModel *> *)list {
    self = [super initWithFrame:frame];
    if (self) {
        //UI
        [self setupUI:frame left:left right:right];
        
        // action
        [self addSingleTapEvent:^{
            [self.window endEditing:true];
            
            SDKCommonPickerView *picker = [[SDKCommonPickerView alloc] initWithList:list];
            picker.sendValue = ^ (SDKPickerModel * m) {
                DLog(@"%@", m.text);
                
                _model = m;
                
                _rightLab.text = _model.text;
                _rightLab.textColor = commonBlackColor;
                
                !_sendValue ? : _sendValue(_model);
            };
            [picker show];
        }];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame left:(NSString *)left right:(NSString *)right {
    self = [super initWithFrame:frame];
    if (self) {
        // UI
        [self setupUI:frame left:left right:right];
        
    }
    return self;
}

- (void)setDataArray:(NSMutableArray<SDKPickerModel *> *)dataArray {
    _dataArray = dataArray;

}

- (void)nextMethod {
    SDKCommonPickerView *picker = [[SDKCommonPickerView alloc] initWithList:_dataArray];
    picker.sendValue = ^ (SDKPickerModel * m) {
        DLog(@"%@", m.text);
        
        _model = m;
        
        _rightLab.text = _model.text;
        _rightLab.textColor = commonBlackColor;
        
        !_sendValue ? : _sendValue(_model);
    };
    [picker show];
}

- (void)setupUI:(CGRect)frame left:(NSString *)left right:(NSString *)right {
    self.frame = frame;
    self.backgroundColor = commonWhiteColor;
    _rightText = right;
    
    CGFloat arrowW = adaptX(6.5);
    CGFloat arrowH = adaptY(11);
    
    CGFloat leftW = [SDKAboutText calcaulateTextWidth:left height:adaptY(39) font:kFont(14)];
    SDKCustomLabel *leftLab = [SDKCustomLabel setLabelTitle:left setLabelFrame:CGRectMake(kDefaultPadding, 0, leftW, adaptY(39)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
    [self addSubview:leftLab];
    
    _rightLab = [SDKCustomLabel setLabelTitle:right setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding-arrowW-adaptY(3), adaptY(39)) setLabelColor:commonGrayColor setLabelFont:kFont(14) setAlignment:2];
    [self addSubview:_rightLab];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-kDefaultPadding-arrowW, (adaptY(39)-arrowH)*0.5, arrowW, arrowH)];
    arrow.image = [UIImage imageNamed:kImageBundle @"arrow_forward"];
    [self addSubview:arrow];
    
    self.height = adaptY(39);
    
    SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, self.height-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
    [self addSubview:bottomL];

}


// 赋值
- (void)showContentWithPickerModel:(SDKPickerModel *)model {
    _rightLab.text = model.text;
    _rightLab.textColor = commonBlackColor;
}

// clear value
- (void)clearValue {
    _rightLab.text = _rightText;
    _rightLab.textColor =commonGrayColor;
}

- (SDKPickerModel *)selectedModel {
    return _model;
}

- (void)checkDataAndHandle:(void (^)(NSMutableDictionary *, BOOL))handle {
    
}

@end
