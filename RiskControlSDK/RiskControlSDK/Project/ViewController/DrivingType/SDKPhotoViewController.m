
//
//  SDKPhotoViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKPhotoViewController.h"

@interface SDKPhotoViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;

@end

@implementation SDKPhotoViewController

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
//    
//    
    // 标题
    SDKTitleView *titleView = [[SDKTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)  colorLump:kBtnNormalBlue text:@"松鼠小测试"];
    [titleView noneBottomLine];
    titleView.backgroundColor = commonWhiteColor;
    [self.mainScrollview addSubview:titleView];
    
    
    // 拍照
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), kScreenWidth, 0)];
    
    SDKPhotoView *photoView = [[SDKPhotoView alloc] initWithFrame:CGRectMake(0, adaptY(25), kScreenWidth, 0) text:@"上传此刻自拍照" superVC:self];
    photoView.sendValue = ^ (UIImage *img, NSInteger index) {
        
    };
    [main addSubview:photoView];
    
    
    // 提交
    SDKCustomRoundedButton *btn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
    btn.frame = CGRectMake(kDefaultPadding, CGRectGetMaxY(photoView.frame)+adaptY(30), kScreenWidth-2*kDefaultPadding, adaptY(35));
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [main addSubview:btn];
    
    main.height = CGRectGetMaxY(main.subviews.lastObject.frame);
    [self.mainScrollview addSubview:main];
    

}

#pragma mark - 提交
- (void)btnAction {
    
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
