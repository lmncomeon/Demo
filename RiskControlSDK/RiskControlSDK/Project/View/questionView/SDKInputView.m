//
//  SDKInputView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKInputView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "UIView+SDKCustomView.h"
#import "SDKAboutText.h"
#import "SDKJWTextField.h"
#import "SDKLineView.h"
#import "SDKCommonModel.h"
#import "SDKFormatJudge.h"

@interface SDKInputView ()

@property (nonatomic, strong) SDKMNChineseField *rightField;


@property (nonatomic, strong) SDKCommonModel *currentModel;
@property (nonatomic, copy) NSString *recordStr;


@end

@implementation SDKInputView

- (instancetype)initWithFrame:(CGRect)frame topic:(NSString *)topic
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        
        CGFloat selfW = frame.size.width;
        
        // 问题
        CGFloat labH = [SDKAboutText calculateTextHeight:topic maxWidth:selfW font:kFont(14)];
        
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:topic setLabelFrame:CGRectMake(kDefaultPadding, 0, selfW-2*kDefaultPadding, labH) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        lab.numberOfLines = 0;
        [self addSubview:lab];
        
        
        // other
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(kDefaultPadding, CGRectGetMaxY(lab.frame)+adaptY(15), selfW-2*kDefaultPadding, adaptY(39))];
        container.layer.borderWidth = 0.5f;
        container.layer.borderColor = cuttingLineColor.CGColor;
        [self addSubview:container];
        
        
        SDKJWTextField *field = [[SDKJWTextField alloc] initWithFrame:CGRectMake(adaptX(4), 0, container.size.width-adaptX(4), container.height)];
        [container addSubview:field];
        field.importBackString = ^ (NSString *str) {
            !_sendValue ? : _sendValue(str);
        };
        
                
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
       
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        _currentModel = model;
        
        CGFloat selfW = frame.size.width;
        
        SDKCustomLabel *leftLab = [SDKCustomLabel setLabelTitle:model.label setLabelFrame:CGRectMake(kDefaultPadding, 0, selfW-2*kDefaultPadding, adaptY(39)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [self addSubview:leftLab];
        
        _rightField = [[SDKMNChineseField alloc] initWithFrame:CGRectMake(selfW*0.5, 0,selfW*0.5-kDefaultPadding, adaptY(39)) placeHolder:model.placeholder font:kFont(14) align:2];
        if ([model.type isEqualToString:@"phone"]) {
            _rightField.keyboardType = UIKeyboardTypeNumberPad;
        }
            else if ([model.type isEqualToString:@"mailbox"]) {
            _rightField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        _rightField.sendValueBlock = ^ (NSString *str) {
            _recordStr = str;
        };
        [self addSubview:_rightField];

        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
        
        SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, adaptY(39)-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [self addSubview:bottomL];
    }
    return self;
}

- (void)showValueWithModel:(SDKCommonModel *)model {
    _rightField.text = model.value1;
    
    _recordStr = model.value1;
}

- (void)checkDataAndHandle:(void (^)(NSMutableDictionary *, BOOL))handle{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[_currentModel.name] = _recordStr;
    
    if (!_currentModel.required) {
        if (handle) {
            handle(dic, true);
        }
        self.backgroundColor = commonWhiteColor;
    } else {
        if ([_currentModel.type isEqualToString:@"phone"])
        { // 校验
            if (_recordStr && ![_recordStr isEqualToString:@""] && [SDKFormatJudge isValidateMobile:_recordStr]) {
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
        else
        {
            if (_recordStr && ![_recordStr isEqualToString:@""]) {
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
}

@end
