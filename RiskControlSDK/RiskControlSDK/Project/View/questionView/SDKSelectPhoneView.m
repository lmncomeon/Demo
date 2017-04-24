//
//  SDKSelectPhoneView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKSelectPhoneView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "UIView+SDKCustomView.h"
#import "SDKAboutText.h"
#import "SDKCommonModel.h"
@interface SDKSelectPhoneView ()

@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) NSArray <SDKOptionModel * >*list;

@end

@implementation SDKSelectPhoneView

- (instancetype)initWithFrame:(CGRect)frame topic:(NSString *)topic list:(NSArray <SDKOptionModel *> *)list {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        _list = list;
        
        CGFloat selfW = frame.size.width;
        
        CGFloat labH = [SDKAboutText calculateTextHeight:topic maxWidth:selfW font:kFont(14)];
        
        // 问题
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:topic setLabelFrame:CGRectMake(kDefaultPadding, 0, selfW-2*kDefaultPadding, labH) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        lab.numberOfLines = 0;
        [self addSubview:lab];
        
        // other
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(kDefaultPadding, CGRectGetMaxY(lab.frame)+adaptY(5), selfW-2*kDefaultPadding, 0)];
        [self addSubview:container];
        
        for (int i = 0; i < list.count; i++) {
            UIButton *btn = [self createBtnWithFrame:CGRectMake(0, i*adaptY(35), [self handleWidthText:list[i].text], adaptY(35)) text:list[i].text action:@selector(btnAction:)];
            btn.tag = 1000+i;
            [container addSubview:btn];
            
            // default
            if (i == 0) {
                btn.selected = true;
                _selectedBtn = btn;
            }
        }

        container.height = CGRectGetMaxY(container.subviews.lastObject.frame);
        
        
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
    }
    return self;
}

// 点击事件
- (void)btnAction:(UIButton *)sender {
    if (sender == _selectedBtn) return;
    
    [self.window endEditing:true];
    
    sender.selected = true;
    _selectedBtn.selected = false;
    _selectedBtn = sender;
    
    !_sendValue ? : _sendValue(sender.titleLabel.text);
}

- (NSString *)selectedValue {
    return _list[_selectedBtn.tag-1000].value;
}

// calculate width
- (CGFloat)handleWidthText:(NSString *)text {
    CGFloat maxW = self.frame.size.width-2*kDefaultPadding;
    
    CGFloat btnW = [SDKAboutText sizeWithString:text maxWidth:maxW font:kFont(14)].width;
    
    return btnW+adaptX(35);
}

// create btn
- (UIButton *)createBtnWithFrame:(CGRect)frame text:(NSString *)text action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:kImageBundle @"nike_no"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:kImageBundle @"nike_yes"] forState:UIControlStateSelected];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:commonBlackColor forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(14);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
