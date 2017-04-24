//
//  SDKInputView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKBaseView.h"
@class SDKCommonModel;

@interface SDKInputView : SDKBaseView

- (instancetype)initWithFrame:(CGRect)frame topic:(NSString *)topic;

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model;

- (void)showValueWithModel:(SDKCommonModel *)model;

@property (nonatomic, copy) void (^sendValue)(NSString *);

@end
