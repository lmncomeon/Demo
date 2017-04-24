//
//  SDKRadioView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKBaseView.h"

@class SDKInfomationModel, SDKCommonModel, SDKOptionModel;

@interface SDKRadioView : SDKBaseView

// index 0
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title model:(SDKCommonModel *)model selectedIndex:(NSInteger)selectedIndex;

@end
