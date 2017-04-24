//
//  SDKInfoView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/1.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKInfoView.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKCommonModel.h"
#import "SDKCustomLabel.h"
#import "SDKLineView.h"
#import "SDKDisplayPhotoView.h"

@implementation SDKInfoView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        
        CGFloat selfW = frame.size.width;
        
        if ([model.type isEqualToString:@"area"]) {
            UIView *one = [self cellWithY:0 left:model.label right:model.value1];
            
            UIView *two = [self cellWithY:CGRectGetMaxY(one.frame) left:model.label2 right:model.value2];
            
            UIView *three = [self cellWithY:CGRectGetMaxY(two.frame) left:model.label3 right:model.value3];
        } else if ([model.type isEqualToString:@"readtext"]) {
            UIView *one = [self cellWithY:0 left:model.label right:model.value1];
            
            UIView *two = [self cellWithY:CGRectGetMaxY(one.frame) left:model.label2 right:model.value2];
        }
        else if ([model.type isEqualToString:@"image"]) {
            SDKDisplayPhotoView *photoView = [[SDKDisplayPhotoView alloc] initWithFrame:CGRectMake(0, 0, selfW, 0) model:model];
            [self addSubview:photoView];
        }
        else {
            UIView *one = [self cellWithY:0 left:model.label right:model.value1];
        }

        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);

    }
    return self;
}

- (UIView *)cellWithY:(CGFloat)cellY left:(NSString *)left right:(NSString *)right {
    CGFloat selfW = self.frame.size.width;
    CGFloat cellH = adaptY(45);
    
    UIView *sub = [[UIView alloc] initWithFrame:CGRectMake(0, cellY, selfW, cellH)];
    [self addSubview:sub];
    
    SDKCustomLabel *leftLab = [SDKCustomLabel setLabelTitle:left setLabelFrame:CGRectMake(kDefaultPadding, 0, selfW-2*kDefaultPadding, cellH) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
    [sub addSubview:leftLab];
    
    SDKCustomLabel *rightLab = [SDKCustomLabel setLabelTitle:right setLabelFrame:CGRectMake(kDefaultPadding, 0, selfW-2*kDefaultPadding, cellH) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:2];
    [sub addSubview:rightLab];
    
    SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftLab.frame), selfW, 0.5f) color:cuttingLineColor];
    [sub addSubview:bottomL];

    sub.height = CGRectGetMaxY(sub.subviews.lastObject.frame);
    
    return sub;
}

@end
