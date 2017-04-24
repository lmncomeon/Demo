//
//  SDKCredictPublicView.h
//  RiskControlSDK
//
//  Created by 美娜栾 on 2017/2/25.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDKInfomationModel, SDKCommonModel, SDKBaseViewController, SDKPickerModel;

@interface SDKCredictPublicView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKInfomationModel *)model pageCount:(NSInteger)pageCount currentIndex:(NSInteger)currentIndex innerVC:(SDKBaseViewController *)innerVC areaList:(NSArray <SDKPickerModel *> *)areaList;


// 上传照片
@property (nonatomic, copy) void(^uplodImageBlock)(UIImage *img, SDKCommonModel *model, NSInteger index);
- (void)photoSuccessWithImage:(UIImage *)img index:(NSInteger)index url:(NSString *)url;



// 提交
@property (nonatomic, copy) void (^submitEvent)(NSString *contentStr);
// 下一步
@property (nonatomic, copy) void (^nextEvent)(NSString *);
// 通讯录所有数据
@property (nonatomic, copy) void (^addressInfo)(NSString *);

// 进入编辑运营商授权h5
@property (nonatomic, copy) void (^intoH5)(SDKCommonModel *);

// 进入公积金
@property (nonatomic, copy) void (^intoGJJApp)(SDKCommonModel *);

// 社保
@property (nonatomic, copy) void (^intoSBApp)(SDKCommonModel *);

// 赋值授权
- (void)settingAuthWithDic:(NSDictionary *)dic;

@end
