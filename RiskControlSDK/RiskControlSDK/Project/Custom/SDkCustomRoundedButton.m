//
//  SDKCustomRoundedButton.m
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/21.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "SDKCustomRoundedButton.h"
#import "UIImage+SDKColorImage.h"

@implementation SDKCustomRoundedButton

+ (instancetype)roundedBtnWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor normalBackgroundColor:(UIColor *)normalBackgroundColor highBackgroundColor:(UIColor *)highBackgroundColor {
    SDKCustomRoundedButton *btn = [SDKCustomRoundedButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:highBackgroundColor] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius  = 5;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

+ (instancetype)roundedBtnWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor {
    SDKCustomRoundedButton *btn = [SDKCustomRoundedButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.layer.cornerRadius  = 5;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

@end



@implementation SDKCustomUnderlineButton

+ (instancetype)underlinebuttonWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor addTaget:(id)target action:(SEL)action {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, title.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, title.length)];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, title.length)];
    
    SDKCustomUnderlineButton *btn = [SDKCustomUnderlineButton buttonWithType:UIButtonTypeCustom];
    [btn setAttributedTitle:attrString forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
