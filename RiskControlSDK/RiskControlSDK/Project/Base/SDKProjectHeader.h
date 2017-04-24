//
//  projectHeader.h
//  GTriches
//
//  Created by devair on 14-10-9.
//  Copyright (c) 2014年 eric. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDKTTooltipView.h"

#ifndef GTriches_projectHeader_h
#define GTriches_projectHeader_h

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

#define showTip(Message) [SDKTTooltipView createTooltipViewWithMarkedWords:Message view:self.view];DLog(@"%@", Message);

#define showTips(Message) [SDKTTooltipView createTooltipViewWithMarkedWords:Message view:self.window];DLog(@"%@", Message);

#define showTipByView(Message, View) [SDKTTooltipView createTooltipViewWithMarkedWords:Message view:View];DLog(@"%@", Message);

//判断字符串为空是赋值为 @""
#define IS_NULL(x)          (!x || [x isKindOfClass:[NSNull class]])
#define IS_EMPTY_STRING(x)  (IS_NULL(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
#define DEFUSE_EMPTY_STRING(x)     (!IS_EMPTY_STRING(x) ? x : @"")

//判断机型
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//系统版本判断
#define iOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

//屏幕尺寸
#define kScreenFrame    [UIScreen mainScreen].bounds
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

// 默认边距
#define kDefaultPadding adaptX(16)

// keywindow
#define kKeyWindow [UIApplication sharedApplication].keyWindow

//颜色
#define krandomColor        [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:1.0f] // 随机色

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define commonBlueColor     UIColorFromRGB(0x42aef7)
#define commonRedColor      UIColorFromRGB(0xff4c00)
#define cuttingLineColor    UIColorFromRGB(0xe8e8e8)
#define backGroundColor     UIColorFromRGB(0xf7f7f7)
#define kCellTitleColor     UIColorFromRGB(0x666666)// cell 左侧字体颜色
#define kNavTitleColor      UIColorFromRGB(0x333333)// 导航标题色
#define kBtnNormalBlue      UIColorFromRGB(0x42aef7)
#define kBtnHighlightBlue   UIColorFromRGB(0x1e89d1)
#define kBtnDisabledColor   UIColorFromRGB(0xADADAD)
#define kDisableBtnColor    UIColorFromRGB(0xbbbbbb)
#define kOrangeColor        UIColorFromRGB(0xf78f42)
#define titleTextColor      UIColorFromRGB(0x4c5f70)
#define commonGrayColor     UIColorFromRGB(0x999999)
#define commonClearColor    [UIColor clearColor]
#define commonWhiteColor    [UIColor whiteColor]
#define commonBlackColor    UIColorFromRGB(0x333333)
#define identityCardColor   UIColorFromRGB(0xf0831e)

//错误提示色值
#define  kErrorColor        UIColorFromRGB(0xffe1e1)

// 缩放系数
#define kScaleX (kScreenWidth/320)
#define kScaleY (kScreenHeight/568)

//Font
#define kFont(float) [UIFont fontWithName:@"Helvetica" size:float*kScaleX]
#define kLightFont(float) [UIFont fontWithName:@"Helvetica" size:float*kScaleX]
#define kMediumFont(float) [UIFont boldSystemFontOfSize:float*kScaleX]
#define lightMaxFont(float) [UIFont fontWithName:@"STHeitiSC-Light" size:float*kScaleX] ? : [UIFont systemFontOfSize:float*kScaleX]
#define mediumFont(float) [UIFont fontWithName:@"STHeitiSC-Medium" size:float] ? : [UIFont systemFontOfSize:float]

//Rect
#define resetRectXYWH(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width *kScaleX, height *kScaleY)
#define resetRectXYH(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width, height *kScaleY)
#define resetRectXYW(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width *kScaleX, height)
#define resetRectXWH(x, y, width, height) CGRectMake(x *kScaleXkScaleX, y, width *kScaleX, height)
#define resetRectYWH(x, y, width, height) CGRectMake(x, y *kScaleY, width *kScaleX, height *kScaleY)
#define resetRectXYWH(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width *kScaleX, height *kScaleY)
#define resetRectXYWH2(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width *kScaleX, height *kScaleX)
#define resetRectXYH(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width, height *kScaleY)
#define resetRectXYW(x, y, width, height) CGRectMake(x *kScaleX, y *kScaleY, width *kScaleX, height)
#define resetRectWH(x, y, width, height) CGRectMake(x, y, width *kScaleX, height *kScaleY)
#define resetRectWH2(x, y, width, height) CGRectMake(x, y, width *kScaleX, height *kScaleX)

//cell高度
#define KcellHeight 40

//Size
#define adaptX(num) num *kScaleX
#define adaptY(num) num *kScaleY

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度
#define PROGRESS_LINE_WIDTH 20 //弧线的宽度

//double->string
#define handleDoubleBecomeString(double) ([NSString stringWithFormat:@"%.2f", double])

// keyName
#define keyName_token   @"tokenKey"
#define keyName_product @"productType"

// uid
#define kUIDName @"uid"
#define KToken @""
// 取出
#define kgetCommonData(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]


// userid
#define kUserid kgetCommonData(@"userid")
// productType
#define kProductType kgetCommonData(keyName_product)
// bundle
#define kImageBundle @"RiskControlBundle.bundle/"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempRecord.data"]



// baseURL
#define BaseAPPUrl @"https://grccore.songzidai.com/sdk"

#define policyAgreement BaseAPPUrl "/privacy_policy.html" // 初审协议

// 协议
#define kAgreeURL BaseAPPUrl @"/loan_terms.html"
//公积金授权提示信息(右上角问号)
#define KtipForAccumulation BaseAPPUrl @"/static/explain/accumulationFund.html"
//社保授权提示信息(右上角问号)
#define KtipForSocialSecurity BaseAPPUrl @"/static/explain/socialSecurity.html"


// 更新
#define kAPPSTORE_CHECKUODATE_URL @"http://itunes.apple.com/lookup?id=1174155994"
//JPush
#define KJPushAppKey @"e05205fa996560e8c5017172"
#define KJPushChannel @"Publish channel"

//客服电话
#define kTelephone @"400-010-5577"

//数字判断
#define KNumbers @"0123456789\n"

#define exitLongin @"exitLongin"

//通知中心
#define KcancelKeyboard @"cancelKeyboard"


//用户信息
#define KUserInfo @"userInfo"
#define KVerifyCodeType 0 //短信0， 语音1
#define kChainHomeListNotification @"chainHomeListNote"

// 是否为空
#define kIsNonEmptyArray(data) (data != nil && data.count > 0)

////隐私协议
//#define KPrivacyPolicy @"http://app.songguodai.com/static/squcorp/privacyagreement.html"
//
//// 松鼠普惠平台认证用户服务协议
//#define kIdentificationSQU @"https://app.squcorp.com/authenticationProtocol.html"
//
////用户注册服务协议
//#define KRegistrationServiceAgreement @"http://app.songguodai.com/static/squcorp/registrationagreement.html"

//jsPatch
#define JSPatchKey @"81be46b0b17d8c68"



@interface NSString (encrypto)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) formatDateSince1970:(long long)date formatString:(NSString *)format;
- (NSString *) formatLocationCurrency:(double)currency;
@end

#endif
