//
//  SDKAddressView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/20.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKBaseView.h"

@class SDKBaseViewController, SDKCommonModel;

@interface SDKAddressView : SDKBaseView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model innerVC:(SDKBaseViewController *)innerVC;

- (void)showContent;

- (NSMutableArray *)addressAllInfomation;

@property (nonatomic, copy) void (^sendAllInfo)(NSString *content);

@end
