//
//  RiskControlSDK.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "RiskControlSDK.h"
#import "SDKCommonService.h"
#import "SDKDefaultSetting.h"
#import "SDKProjectHeader.h"
#import "SDKNavigationController.h"
#import "SDKcustomHUD.h"
// 空白页面
#import "SDKBlankViewController.h"

#import "SDKRecordViewController.h"
#import "SDKVideoViewController.h"
#import "SDKRecordViewController.h"

@interface RiskControlSDK () 

@property (nonatomic, strong) UIViewController *fromVC;

// ---------------------------------------------------------------------------
//---------------------------- 必须用这个方法初始化哦 ----------------------------
// ---------------------------------------------------------------------------
+ (instancetype)sharedInstance;



@end

@implementation RiskControlSDK

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fromVC = [self currentViewController];
    }
    return self;
}

// 存储数据
-  (void)saveRequiredDataWithToken:(NSString *)token productType:(NSString *)productType {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:keyName_token];
    [[NSUserDefaults standardUserDefaults] setObject:productType forKey:keyName_product];
}

// one-> 提交信息
- (void)presentSDKWithToken:(NSString *)token
                productType:(NSString *)productType {
    [self saveRequiredDataWithToken:token productType:productType];
    
    [self presentSDKWithIndex:0];
}

// two-> 查看信息
- (void)presnetSDKViewInformationWithToken:(NSString *)token
                               productType:(NSString *)productType {
    [self saveRequiredDataWithToken:token productType:productType];
    [self presentSDKWithIndex:1];
}

// three -> 授权
- (void)presentSDKAuthWithToken:(NSString *)token
                    productType:(NSString *)productType {
    [self saveRequiredDataWithToken:token productType:productType];
    [self presentSDKWithIndex:2];
}

// 进入SDK
- (void)presentSDKWithIndex:(NSInteger)index {
    
    SDKBlankViewController *blankVC = [SDKBlankViewController new];
    blankVC.index = index;

    
    [self.fromVC presentViewController:[[SDKNavigationController alloc] initWithRootViewController:blankVC] animated:true completion:nil];
}

// 关闭
- (void)closeMethod {
    [self.fromVC dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - 获取当前控制器
- (UIViewController *)currentViewController
{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }
        else if([Rootvc isKindOfClass:[UITabBarController class]]) {
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
        else if ([Rootvc isKindOfClass:[UIViewController class]]) {
            UIViewController * aVC = (UIViewController *)Rootvc;
            currVC = aVC;
            Rootvc = aVC.presentedViewController;
            continue;
        }
    } while (Rootvc!=nil);
    
    
    return currVC;
}

#pragma mark - 单例
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
