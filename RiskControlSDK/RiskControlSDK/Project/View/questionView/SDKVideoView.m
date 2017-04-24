//
//  SDKVideoView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/21.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKVideoView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "UIView+SDKCustomView.h"
#import "SDKCustomRoundedButton.h"
#import "SDKImagePickerCoordinator.h"
#import "SDKBaseViewController.h"

@interface SDKVideoView ()

@property (nonatomic, strong) SDKBaseViewController *superVC;
@property (nonatomic, strong) SDKImagePickerCoordinator *imgPicker;
@property (nonatomic, copy) NSString *content;

@end

@implementation SDKVideoView

- (instancetype)initWithFrame:(CGRect)frame innerViewController:(SDKBaseViewController*)innerVC text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        _superVC = innerVC;
        _content = text;
        
        CGFloat selfW = frame.size.width;
        CGFloat iconWH = adaptX(33);
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((selfW-iconWH)*0.5, 0, iconWH, iconWH)];
        icon.image = [UIImage imageNamed:kImageBundle @"video_logo"];
        [self addSubview:icon];
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = 1;
        paraStyle.lineSpacing = 10;
        
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:@"请拍摄一段视频!\n按照屏幕提示读出文字" attributes:@{NSFontAttributeName:kFont(14), NSForegroundColorAttributeName : commonBlackColor, NSParagraphStyleAttributeName:paraStyle}];
        
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:@"请拍摄一段视频!\n按照屏幕提示读出文字" setLabelFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+adaptY(5), selfW, adaptY(60)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
        lab.numberOfLines = 0;
        lab.attributedText = mutableString;
        [self addSubview:lab];
        
        SDKCustomRoundedButton *shootBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击拍摄" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        shootBtn.frame = CGRectMake(kDefaultPadding, CGRectGetMaxY(lab.frame)+adaptY(30), selfW-2*kDefaultPadding, adaptY(35));
        [shootBtn addTarget:self action:@selector(shootAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shootBtn];
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
    }
    return self;
}

- (void)shootAction {
    _imgPicker = [SDKImagePickerCoordinator new];
    
    if ([_imgPicker isVideoRecordingAvailable] && [_imgPicker isAlbumAvailable]) {
        [_imgPicker showInnerViewcontroller:_superVC text:_content];
    }
    else if (![_imgPicker isVideoRecordingAvailable]) {
        SDKJWAlertView * alert  = [[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:@"温馨提示" message:@"当前相机不可使用,请在系统设置中打开相机权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert alertShow];
    }
//    else if (![_imgPicker isAlbumAvailable]) {
//        SDKJWAlertView * alert  = [[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:@"温馨提示" message:@"当前相册不可使用,请在系统设置中打开相册权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alert alertShow];
//    }
    
    _imgPicker.sendData = ^ (NSData *mp4, NSString *name) {
        !_useVideoEvent ? : _useVideoEvent(mp4, name);
    };
    
    _imgPicker.sendURL = ^ (NSURL *url) {
        !_useVideoURL ? : _useVideoURL(url);
    };
}

@end
