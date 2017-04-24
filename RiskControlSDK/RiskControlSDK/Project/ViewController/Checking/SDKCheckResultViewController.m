//
//  SDKCheckResultViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCheckResultViewController.h"

@interface SDKCheckResultViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;

@end

@implementation SDKCheckResultViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"审核结果"];
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];

    CGFloat iconWH = adaptX(157);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-iconWH)*0.5 , adaptY(66), iconWH, iconWH)];
    iconView.image = [UIImage imageNamed:kImageBundle @"result_checking"];
    [self.mainScrollview addSubview:iconView];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"信用资料审核中!" setLabelFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame)+adaptY(10), kScreenWidth, adaptY(20)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
    [self.mainScrollview addSubview:lab];
    
    SDKCustomLabel *bottom = [SDKCustomLabel setLabelTitle:@"客服电话:" kTelephone setLabelFrame:CGRectMake(0, kScreenHeight-64-adaptY(50), kScreenWidth, adaptY(20)) setLabelColor:commonGrayColor setLabelFont:kFont(12) setAlignment:1];
    [self.mainScrollview addSubview:bottom];
    
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
