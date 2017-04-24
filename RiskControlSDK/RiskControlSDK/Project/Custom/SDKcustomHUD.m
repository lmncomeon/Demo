//
//  SDKcustomHUD.m
//  handheldCredit
//
//  Created by devair on 15/8/11.
//  Copyright (c) 2015年 liguiwen. All rights reserved.
//

#import "SDKcustomHUD.h"
#import "MBProgressHUD.h"
#import "SDKProjectHeader.h"
@interface SDKcustomHUD ()
@property (strong, nonatomic) MBProgressHUD * mbProgressHUD;
@property (strong, nonatomic) UIImageView *animationImageView;

@property (nonatomic, weak) UIView *whiteView;

@end

@implementation SDKcustomHUD
- (void)showCustomHUDWithView:(UIView *)view{
    self.mbProgressHUD = [[MBProgressHUD alloc] initWithView:view];
    NSMutableArray * imageArr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString * imageName = [NSString stringWithFormat:@"RiskControlBundle.bundle/common-hud%d.png",i+1];
        UIImage * image = [UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    self.animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    self.animationImageView.image = [UIImage imageNamed:@"RiskControlBundle.bundle/common-hud1.png"];
    self.animationImageView.animationImages = imageArr;
    self.animationImageView.animationDuration = 0.7;
    [self.animationImageView startAnimating];
    self.mbProgressHUD.customView = self.animationImageView;
    self.mbProgressHUD.mode = MBProgressHUDModeCustomView;
    self.mbProgressHUD.labelText = @"加载中";
    self.mbProgressHUD.labelFont = kFont(11);
    self.mbProgressHUD.labelColor = [UIColor whiteColor];
    [self.mbProgressHUD show:YES];
    [view addSubview:self.mbProgressHUD];
}
- (void)hideCustomHUD{
    [self.mbProgressHUD removeFromSuperview];
}

- (void)showBlankViewInView:(UIView *)view {
    UIView *whiteView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    whiteView.backgroundColor = commonWhiteColor;
    [view addSubview:whiteView];
    
    self.whiteView = whiteView;
}
- (void)hideBlankView {
    [self.whiteView removeFromSuperview];
}

@end

