//
//  SDKCityView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDKPickerModel, SDKCommonModel;
@interface SDKCityView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model list:(NSArray <SDKPickerModel *> *)list;

- (void)showContent;

@end
