//
//   SDKBankCardAuthenticationViewController.m
//  RiskControl 
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBankCardAuthenticationViewController.h"

@interface SDKBankCardAuthenticationViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) SDKCustomLabel *tip;

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *fieldArray;

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;

@end

@implementation  SDKBankCardAuthenticationViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(65))];
        _progressView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollview addSubview:_progressView];
        
        SDKLineView *grayLine = [[SDKLineView alloc] initWithFrame:CGRectMake(adaptX(44), adaptY(22), kScreenWidth-2*adaptX(44), 0.5f) color:cuttingLineColor];
        [_progressView addSubview:grayLine];
        
        SDKLineView *blueLine = [[SDKLineView alloc] initWithFrame:CGRectMake(adaptX(44), adaptY(22), (kScreenWidth-2*adaptX(44)), 0.5f) color:kBtnNormalBlue];
        [_progressView addSubview:blueLine];
        
        NSArray *iconArr = @[@"phone_blue", @"identity_blue", @"card_blue"];
        NSArray *textArr = @[@"手机认证", @"身份认证", @"银行卡认证"];
        
        CGFloat iconWH = adaptX(22);
        CGFloat margin = adaptX(43);
        CGFloat padding = (kScreenWidth-2*margin-iconArr.count*iconWH)/(iconArr.count-1);
        
        for (int i = 0; i < iconArr.count; i++) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(margin+i*(iconWH+padding), adaptY(10), iconWH, iconWH)];
            icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"RiskControlBundle.bundle/%@", iconArr[i]]];
            [_progressView addSubview:icon];
            
            SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:textArr[i] setLabelFrame:CGRectMake(i*(kScreenWidth/textArr.count), CGRectGetMaxY(icon.frame)+adaptY(5), kScreenWidth/textArr.count, adaptY(20)) setLabelColor:commonGrayColor setLabelFont:kFont(12) setAlignment:1];
            [_progressView addSubview:lab];
        }
        
    }
    return _progressView;
}

- (SDKCustomLabel *)tip {
    if (!_tip) {
        _tip = [SDKCustomLabel setLabelTitle:@"提示：储蓄卡和信用卡均可" setLabelFrame:CGRectMake(kDefaultPadding, CGRectGetMaxY(self.progressView.frame)+adaptY(15), kScreenWidth-2*kDefaultPadding, adaptY(20)) setLabelColor:kOrangeColor setLabelFont:kFont(14)];
        [self.mainScrollview addSubview:_tip];
    }
    return _tip;
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tip.frame)+adaptY(8), kScreenWidth, 0)];
        _container.backgroundColor = commonWhiteColor;
        [self.mainScrollview addSubview:_container];
        
        UIView *defaultCell = [self cellView];
        [_container addSubview:defaultCell];
        
        [self.list addObject:defaultCell];
        
        _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
        
    }
    return _container;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(kDefaultPadding, CGRectGetMaxY(self.container.frame)+adaptY(9), kScreenWidth-2*kDefaultPadding, adaptY(30));
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"RiskControlBundle.bundle/add_card_btn"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollview addSubview:_addBtn];
    }
    return _addBtn;
}

- (SDKCustomRoundedButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _submitBtn.frame = CGRectMake(kDefaultPadding, CGRectGetMaxY(self.addBtn.frame) + adaptY(30), kScreenWidth-2*kDefaultPadding, adaptY(35));
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollview addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"信用初审"];
    [self addNotification];
    
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    
    _mainScrollview.height = CGRectGetMaxY(self.submitBtn.frame) + adaptY(10);
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - 添加
- (void)addAction:(UIButton *)sender {
    SDKJWTextField *last = [self.fieldArray lastObject];
    if (!(last.text.length >= 16 && last.text.length <= 19)) {
        showTip(@"银行卡位数不正确");
        return;
    }
    if (self.list.count == 3) {
        showTip(@"银行卡号最多添加三张");
        return;
    }
    
    UIView *cell = [self cellView];
    
    [_container addSubview:cell];
    [self.list addObject:cell];
    
    for (int i = 0; i < self.list.count; i++) {
        UIView *item = self.list[i];
        item.y = i*item.height;
    }

    // reload Height
    _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
    _addBtn.y = CGRectGetMaxY(self.container.frame)+adaptY(9);
    _submitBtn.y = CGRectGetMaxY(self.addBtn.frame) + adaptY(30);
    _mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + adaptY(10));
}

#pragma mark - 提交
- (void)submitAction:(UIButton *)sender {
    [self.view endEditing:true];
    
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [SDKcustomHUD new];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService activeStepThreeSubmitWithBankcard:[self handleCardArray] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    [self dismissViewControllerAnimated:true completion:nil];
                }else{
                    showTip(responseObject[@"msg"]);
                    [self.hud hideCustomHUD];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.hud hideCustomHUD];
                [self errorDispose:[[operation response] statusCode] judgeMent:nil];
            }];
        }
        else
        {
            [self errorRemind:nil];
        }
    }];
    
}

#pragma mark - 处理填写数据
- (NSString *)handleCardArray {
    NSMutableArray *tmp = [NSMutableArray array];
    for (int i = 0; i < self.fieldArray.count; i++) {
        SDKJWTextField *sub = self.fieldArray[i];
        [tmp addObject:sub.text];
    }
    DLog(@"%@", tmp);
    
    NSString *joinString = [tmp componentsJoinedByString:@","];
    
    return joinString;
}

#pragma mark - other
- (UIView *)cellView {
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(39))];
    
    SDKLineView *l0 = [SDKLineView screenWidthLineWithY:adaptY(39)];
    [cell addSubview:l0];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"常用本人银行卡号" setLabelFrame:CGRectMake(kDefaultPadding, 0, adaptX(150), adaptY(38)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
    [cell addSubview:lab];
    
    SDKJWTextField *field = [[SDKJWTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame), 0, kScreenWidth-CGRectGetMaxX(lab.frame)-kDefaultPadding, adaptY(38))];
    field.font = kFont(14);
    field.textAlignment = 2;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.placeholder = @"请输入银行卡号";
    field.importBackString = ^ (NSString *backStr) {
        
    };
    [cell addSubview:field];
    
    [self.fieldArray addObject:field];
    return cell;
}

#pragma mark - lazy load
- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (NSMutableArray *)fieldArray {
    if (!_fieldArray) {
        _fieldArray = [NSMutableArray array];
    }
    return _fieldArray;
}

@end
