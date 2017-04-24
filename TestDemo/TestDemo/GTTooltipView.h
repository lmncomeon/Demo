//
//  GTTooltipView.h
//  GTriches
//
//  Created by wisetrip on 14/10/30.
//  Copyright (c) 2014年 eric. All rights reserved.
//  自定义如警告弹框

#import <UIKit/UIKit.h>

@interface GTTooltipView : UIButton
@property (strong, nonatomic) UILabel *messageLab;/**< 消息 */
+ (void)createTooltipViewWithMarkedWords:(NSString *)markWord view:(UIView *)showView;

/**
 *  显示
 */
- (void)show;
+ (GTTooltipView *)createTooltipViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;
+ (GTTooltipView *)createTooltipTwoViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;
+ (GTTooltipView *)createTooltipThreeViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view;
@end