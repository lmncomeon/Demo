//
//  SDKBaseViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKDefaultSetting.h"
#import "SDKProjectHeader.h"
#import "SDKCommonService.h"
#import "NSArray+SDKLog.h"

#import "SDKnetwork.h"
#import "SDKNetworkState.h"
#import "SDKNavigationController.h"

// tool
#import "SDKJWTextField.h"
#import "SDKLineView.h"
#import "SDKCustomLabel.h"
#import "UIView+SDKCustomView.h"
#import "UIImage+SDKColorImage.h"
#import "SDKCustomRoundedButton.h"
#import "SDKFormatJudge.h"
#import "SDKProgressView.h"
#import "SDKTitleView.h"
#import "SDKPhotoView.h"
#import "SDKRadioView.h"
#import "SDKCommonPickerView.h"
#import "SDKSelectView.h"
#import "SDKCityView.h"
#import "SDKAddressView.h"
#import "SDKJWAlertView.h"
#import "SDKAboutText.h"
#import "SDKInputView.h"
#import "SDKRecordView.h"
#import "SDKListView.h"


// 三方
#import "UIViewController+KeyboardCorver.h"
#import "SDKcustomHUD.h"
#import "YYModel.h"

// model
#import "SDKInfomationModel.h"
#import "SDKCommonModel.h"
#import "SDKPickerModel.h"
#import "SDKAnswerModel.h"
// SDK
#import "RiskControlSDK.h"

typedef NS_ENUM(NSInteger, BaseBtnTypeStyle) {
    BaseBtnRightType,
    BaseBtnLeftType
};

@interface SDKBaseViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) SDKDefaultSetting *defaultSetting;/**< 系统文件数据 */
//@property (strong, nonatomic) DWUserModel *user;
@property (nonatomic, strong) SDKcustomHUD *hud;
@property (nonatomic, strong) SDKcustomHUD *customHUD;

#pragma mark  - 失败处理
- (void)errorDispose:(NSInteger)errorCode judgeMent:(NSString *)judgement;
#pragma mark  - 无网络的统一处理
- (void)errorRemind:(NSString *)judgement;

- (void)createTitleBarButtonItemStyle:(BaseBtnTypeStyle)btnStyle title:(NSString *)title TapEvent:(void(^)(void))event;

- (void)createImageBarButtonItemStyle:(BaseBtnTypeStyle)btnStyle Image:(NSString *)image TapEvent:(void(^)(void))event;

- (void)setupNav:(NSString *)titleStr;

- (void)setupNavWithTitle:(NSString *)title;

- (UIBarButtonItem *)createBackButton:(SEL)action;


// 模型转换
- (NSArray *)optionModelToPickerModel:(NSArray <SDKOptionModel *> *)options;

// 字典转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic;


#pragma mark - 接口
// 上传照片
- (void)uplodImage:(UIImage *)img model:(SDKCommonModel *)model index:(NSInteger)index sucess:(void(^)(NSString * url))sucess;

// 上传录音
- (void)uplodRecord:(NSData *)recordData sucess:(void(^)(NSString *url))sucess;

// 上传视频
- (void)uplodVideo:(NSData *)videoData name:(NSString *)name sucess:(void(^)(NSString *url))sucess;

// 提交数据
- (void)sendDataToServerWithContent:(NSString *)content name:(NSString *)name sucess:(void(^)(NSArray <SDKAnswerModel *>*arr))sucess;

// 修改信审资料
- (void)modifyCreditInfoWithContent:(NSString *)content name:(NSString *)name success:(void(^)())success;

// 获取某项授权状态
- (void)requsetAuthStatusWithType:(NSString *)type result:(void(^)(BOOL res))result;

// 是否全部授权
- (void)judgeAuthStatusWithNames:(NSArray <NSString *> *)names result:(void(^)(BOOL res))result;

// 获取授权情况
- (void)authStatusWithData:(void (^)(NSDictionary *dic))data;

// 提交风控
- (void)submitAnwserWithQid:(NSInteger)qid answer:(NSString *)answer result:(void(^)(BOOL res))result;

@end













