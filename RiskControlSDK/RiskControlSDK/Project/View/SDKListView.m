//
//  SDKListView.m
//  RiskControlSDK
//
//  Created by 美娜栾 on 2017/2/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKListView.h"
#import "SDKCommonPickerView.h"
#import "SDKLineView.h"
#import "SDKAboutText.h"
#import "SDKPickerModel.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKCustomLabel.h"
#import "SDKCommonModel.h"

@interface SDKListView ()

@property (nonatomic, strong) SDKCustomLabel *rightLab;
@property (nonatomic, copy)   NSString *rightText;

@property (nonatomic, strong) SDKPickerModel *model;

@property (nonatomic, strong) SDKCommonModel *currentModel;


@end

@implementation SDKListView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        _currentModel = model;
        
        //UI
        [self setupUI:frame left:model.label right:model.placeholder];
        
        // action
        [self addSingleTapEvent:^{
            [self.window endEditing:true];
            
            SDKCommonPickerView *picker = [[SDKCommonPickerView alloc] initWithList:[self optionModelToPickerModel:model.options]];
            picker.sendValue = ^ (SDKPickerModel * m) {
                DLog(@"%@", m.text);
                
                _model = m;
                
                _rightLab.text = _model.text;
                _rightLab.textColor = commonBlackColor;
                
            };
            [picker show];
        }];
    }
    
    return self;
}

- (void)showContent {
    
    SDKPickerModel *change = [SDKPickerModel new];
    for (SDKOptionModel *mm in _currentModel.options) {
        if ([mm.text isEqualToString:_currentModel.value1]) {
            change.text = mm.text;
            change.value = mm.value;
            break;
        }
    }
    
    _model = change;
    
    _rightLab.text = _model.text;
    _rightLab.textColor = commonBlackColor;
}

- (void)checkDataAndHandle:(void (^)(NSMutableDictionary *, BOOL))handle {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[_currentModel.name] = _model.value;
    
    if (!_currentModel.required) {
        if (handle) {
            handle(dic, true);
        }
    } else {
        if (_model) {
            if (handle) {
                handle(dic, true);
            }
            
            self.backgroundColor = commonWhiteColor;
        } else {
            if (handle) {
                handle(nil, false);
            }
            
            self.backgroundColor = kErrorColor;
        }
    }
}

// 模型转换
- (NSArray *)optionModelToPickerModel:(NSArray <SDKOptionModel *> *)options {
    NSMutableArray *tmp = [NSMutableArray array];
    for (SDKOptionModel *model in options) {
        SDKPickerModel *change = [SDKPickerModel new];
        change.text = model.text;
        change.value = model.value;
        [tmp addObject:change];
    }
    
    return tmp.copy;
}


// UI
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

@end
