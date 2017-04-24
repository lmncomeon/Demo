//
//  SDKRadioView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKRadioView.h"
#import "UIView+SDKCustomView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "SDKAboutText.h"
#import "SDKLineView.h"
#import "SDKInfomationModel.h"
#import "SDKCommonModel.h"

@interface SDKRadioView ()

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) SDKCommonModel *currentModel;


@end

@implementation SDKRadioView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title model:(SDKCommonModel *)model selectedIndex:(NSInteger)selectedIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        
        _currentModel = model;
        NSArray <SDKOptionModel *> *list = model.options;
        
        CGFloat maxW = self.frame.size.width- 2*kDefaultPadding;
        
        CGSize titleSize = [SDKAboutText sizeWithString:title maxWidth:maxW font:kFont(14)];
        CGFloat titleW = titleSize.width;
        CGFloat titleH = titleSize.height;
        
        if (titleH < adaptY(39)) {
            titleH = adaptY(39);
        }
        
        // title
        SDKCustomLabel *titleLab = [SDKCustomLabel setLabelTitle:title setLabelFrame:CGRectMake(kDefaultPadding, 0, titleW, titleH) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        titleLab.numberOfLines = 0;
        [self addSubview:titleLab];
        
        
        
        // 选择
        CGFloat left = adaptX(24);
        CGFloat padding = adaptX(10);
        CGFloat btnH = adaptY(39);
        CGFloat btnW, btnX, btnY;
        
        CGFloat actualTitleW = [SDKAboutText calcaulateTextWidth:title height:adaptY(39) font:kFont(14)];
        if (actualTitleW > maxW) { // title另起一行了
            btnX = kDefaultPadding;
            btnY = CGRectGetMaxY(titleLab.frame);
        } else {
            if (CGRectGetMaxX(titleLab.frame) + left+ [self handleWidthText:list[0].text] > maxW) {
                btnX = kDefaultPadding;
                btnY = CGRectGetMaxY(titleLab.frame);
            } else {
                btnX = CGRectGetMaxX(titleLab.frame) + left;
                btnY = CGRectGetMinY(titleLab.frame);
            }
        }
        
        for (int i = 0; i < list.count; i++) {
            
            btnW = [self handleWidthText:list[i].text];

            UIButton *btn = [self createBtnWithFrame:CGRectMake(btnX, btnY, btnW, btnH) text:list[i].text action:@selector(btnAction:)];
            btn.tag = 1000+i;// tag
            [self addSubview:btn];
            
            if (i == selectedIndex) {
                btn.selected = true;
                _selectedBtn = btn; // record
            } 
            
            if (i+1 != list.count)
            { // not last
                
                // next
                btnX = CGRectGetMaxX(btn.frame)+padding;
                
                if (btnX + [self handleWidthText:list[i+1].text] > maxW ) { //换行
                    btnX = kDefaultPadding;
                    btnY += btnH;
                }
            }

            
        }
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
        SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, self.height-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [self addSubview:bottomL];
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

}

- (void)checkDataAndHandle:(void (^)(NSMutableDictionary *, BOOL))handle {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[_currentModel.name]  = _currentModel.options[_selectedBtn.tag-1000].value;
    
    if (handle) {
        handle(dic, true);
    }
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
