//
//  SDKSelectPhoneView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKBaseView.h"

@class SDKOptionModel;

@interface SDKSelectPhoneView : SDKBaseView

- (instancetype)initWithFrame:(CGRect)frame topic:(NSString *)topic list:(NSArray <SDKOptionModel *> *)list;

@property (nonatomic, copy) void (^sendValue)(NSString *str);

- (NSString *)selectedValue;

@end
