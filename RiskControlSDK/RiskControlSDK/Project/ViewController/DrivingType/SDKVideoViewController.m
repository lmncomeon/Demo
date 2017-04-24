//
//  SDKVideoViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/21.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKVideoViewController.h"
#import "SDKVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface SDKVideoViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation SDKVideoViewController

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
    [titleView noneBottomLine];
    titleView.backgroundColor = commonWhiteColor;
    [self.mainScrollview addSubview:titleView];
    
    
    // 录制视频
    SDKVideoView *videoView = [[SDKVideoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame)+adaptY(40), kScreenWidth, 0) innerViewController:self text:@"请用普通话阅读哈哈哈哈哈哈哈哈哈哈哈哈"];
    videoView.useVideoEvent = ^ (NSData *mp4, NSString *name) {
        
        [self uplodVideo:mp4 name:name sucess:^(NSString *url){
            
        }];
    };
    [self.mainScrollview addSubview:videoView];
    
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
