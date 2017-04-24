//
//  SDKCheckModifyViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/4/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCheckModifyViewController.h"
#import "SDKCheckResultViewController.h"

@interface SDKCheckModifyViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;

@end

@implementation SDKCheckModifyViewController

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

    [self setupNavWithTitle:@"信息修改"];
    
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    
    CGFloat iconWH = adaptX(157);
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-iconWH)*0.5 , adaptY(66), iconWH, iconWH)];
    iconView.image = [UIImage imageNamed:kImageBundle @"result_modify"];
    [self.mainScrollview addSubview:iconView];
    
    SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"您的信息已修改，请重新操作!" setLabelFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame)+adaptY(10), kScreenWidth, adaptY(20)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
    [self.mainScrollview addSubview:lab];
    
    // 确定
    SDKCustomRoundedButton *ensureBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"确定" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
    ensureBtn.frame = CGRectMake((kScreenWidth - iconWH)*0.5, CGRectGetMaxY(lab.frame) + adaptY(30), iconWH, adaptY(35));
    [ensureBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollview addSubview:ensureBtn];
    
}

// 确定
- (void)ensureAction {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService directApplymentWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    SDKCheckResultViewController *pushVC = [SDKCheckResultViewController new];
                    [self.navigationController pushViewController:pushVC animated:true];
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

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
