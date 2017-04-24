//
//  SDKListView.h
//  RiskControlSDK
//
//  Created by 美娜栾 on 2017/2/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseView.h"
@class SDKCommonModel;

@interface SDKListView : SDKBaseView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model;

- (void)showContent;

@end
