//
//  SDKPhotoView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKBaseView.h"
@class SDKBaseViewController, SDKCommonModel;
@interface SDKPhotoView : SDKBaseView

// 多张
- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model superVC:(SDKBaseViewController *)superVC;

// 一张
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text superVC:(SDKBaseViewController *)superVC;

- (void)showPicWithModel:(SDKCommonModel *)model;

@property (nonatomic, copy) void (^sendValue)(UIImage *img, NSInteger index);
- (void)settingImage:(UIImage *)img index:(NSInteger)index url:(NSString *)url;

@end


//===============================================================================================//
@interface SDKTakePhotoBtn : UIButton

- (instancetype)initWithFrame:(CGRect)frame superVC:(SDKBaseViewController *)superVC text:(NSString *)text backgroundImage:(UIImage *)backgroundImage;

@property (nonatomic, copy) void (^sendImage)(UIImage *img);

@end

