//
//  SDKRecordViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/23.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKRecordViewController.h"

@interface SDKRecordViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;

@end

@implementation SDKRecordViewController

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
    // 标题
    SDKTitleView *titleView = [[SDKTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)  colorLump:kBtnNormalBlue text:@"松鼠小测试"];
    titleView.backgroundColor = commonWhiteColor;
    [titleView noneBottomLine];
    [self.mainScrollview addSubview:titleView];
    
    // 录音
    SDKRecordView *recordView = [[SDKRecordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame)+adaptY(20), kScreenWidth, 0) tipText:@"提示文字样例"];
    [self.mainScrollview addSubview:recordView];
    recordView.uplodFile = ^ (NSData *audioData) {
        [self uplodRecord:audioData sucess:^(NSString *utl) {
            [recordView deleteOldVoice];
        }];
    };
    
    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(recordView.frame)+adaptY(20));
    
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
