//
//  SDKCustomLabel.h
//  富文本测试
//
//  Created by 梁家文 on 16/1/5.
//  Copyright © 2016年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKCustomLabel : UILabel

@property (nonatomic,strong) UIColor * labelAnotherColor;

@property (nonatomic,strong) UIFont * labelAnotherFont;

@property (nonatomic,copy) dispatch_block_t customLabTapEvent;

+(SDKCustomLabel *)setLabelTitle:(NSString *)title setLabelFrame:(CGRect)frame setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font;

+(SDKCustomLabel *)setLabelTitle:(NSString *)title setLabelSize:(CGSize)size setLabelFrameX:(CGFloat)frameOriginX setLabelFrameY:(CGFloat)frameOriginY setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font;

+(SDKCustomLabel *)setLabelTitle:(NSString *)title setLabelFrame:(CGRect)frame setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font setAlignment:(NSTextAlignment)alignment;

- (void)setNumberAnimationForValueContent:(double)value;

- (void)setSingleTapEvent:(void(^)(void))event;

+ (SDKCustomLabel *)addLineLabel:(CGRect)frame;

@end
