//
//  SDKTTooltipView.h
//  GTriches
//
//  Created by wisetrip on 14/10/30.
//  Copyright (c) 2014年 eric. All rights reserved.
//  自定义如警告弹框

#import <UIKit/UIKit.h>

@interface SDKTTooltipView : UIButton
@property (strong, nonatomic) UILabel *messageLab;/**< 消息 */
+ (void)createTooltipViewWithMarkedWords:(NSString *)markWord view:(UIView *)showView;

/**
 *  显示
 */
- (void)show;
+ (SDKTTooltipView *)createTooltipViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;
+ (SDKTTooltipView *)createTooltipTwoViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;
+ (SDKTTooltipView *)createTooltipThreeViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;
@end
