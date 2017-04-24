//
//  SDKSelectOnePhoneViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKSelectOnePhoneViewController.h"
#import "SDKSelectPhoneView.h"

@interface SDKSelectOnePhoneViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;

@end

@implementation SDKSelectOnePhoneViewController

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

    [self setupNavWithTitle:@"补充信用资料"];
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    
//    // 进度
//    SDKProgressView *progress = [[SDKProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(44)) count:9 current:1];
//    [self.mainScrollview addSubview:progress];
    
    
    // 标题
    SDKTitleView *titleView = [[SDKTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)  colorLump:kBtnNormalBlue text:@"松鼠小测试"];
    [titleView noneBottomLine];
    titleView.backgroundColor = commonWhiteColor;
    [self.mainScrollview addSubview:titleView];
    
    
    // 选择手机号码
    SDKSelectPhoneView *phoneView = [[SDKSelectPhoneView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame)+adaptY(17), kScreenWidth, 0) topic:@"请选择您的电话号码" list:@[@"134****8016", @"171****9702", @"138****0028"]];
    [self.mainScrollview addSubview:phoneView];
    
    
    // 提交
    SDKCustomRoundedButton *btn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
    btn.frame = CGRectMake(kDefaultPadding, CGRectGetMaxY(phoneView.frame)+adaptY(30), kScreenWidth-2*kDefaultPadding, adaptY(35));
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollview addSubview:btn];
    

}

#pragma mark - 提交
- (void)btnAction {
    
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
