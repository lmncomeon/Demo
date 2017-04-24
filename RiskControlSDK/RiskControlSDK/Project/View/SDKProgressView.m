//
//  SDKProgressView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKProgressView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "SDKLineView.h"
#import "UIView+SDKCustomView.h"

@implementation SDKProgressView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count current:(NSInteger)current {
    self = [super initWithFrame:frame];
    if (self) {
        
        current -= 1;
        self.frame = frame;
        self.showsHorizontalScrollIndicator = false;
        self.backgroundColor = commonWhiteColor;
        
        SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [self addSubview:bottomL];
        
        CGFloat gap = adaptX(38);
        CGFloat WH  = adaptX(19);
        CGFloat margin = 0.00;
        
        
        if (count <= 5) {
            margin = (kScreenWidth -count*WH - (count-1)*gap)*0.5;
        } else {
            margin = (kScreenWidth -5*WH - 4*gap)*0.5;
            
            // 不让滚动 偏移
            if (current >= 4) { margin -= (current-4)*(WH+gap); }
        }
        
        SDKLineView *grayL = [[SDKLineView alloc] initWithFrame:CGRectMake(margin, adaptY(22), count*WH+(count-1)*gap, 0.5f) color:cuttingLineColor];
        [self addSubview:grayL];
        
        SDKLineView *blueL = [[SDKLineView alloc] initWithFrame:CGRectMake(margin, adaptY(22), (current+0.5)*gap + (current+1)*WH, 0.5f) color:kBtnNormalBlue];
        if (current == count-1) {
            blueL.width = grayL.width;
        }
        [self addSubview:blueL];
        
        for (int i = 0; i < count; i++) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(margin+ i*(WH+gap), (adaptY(44)-WH)*0.5, WH, WH)];
            [self addSubview:icon];
            if (i <= current) {
                icon.image = [UIImage imageNamed:kImageBundle @"progress_blue"];
            } else {
                icon.image = [UIImage imageNamed:kImageBundle @"progress_gray"];
            }
            
            SDKCustomLabel *textLab = [SDKCustomLabel setLabelTitle:[NSString stringWithFormat:@"%ld", i+1] setLabelFrame:icon.bounds setLabelColor:commonWhiteColor setLabelFont:kFont(12) setAlignment:1];
            [icon addSubview:textLab];
        }
        
        // 不让滚动
        self.contentSize = CGSizeMake(CGRectGetMaxX(self.subviews.lastObject.frame)+margin, 0);
        
        if (count > 5) {
            self.contentSize = CGSizeMake((count-1)*gap+count*WH+(kScreenWidth -5*WH - 4*gap)-(current-4)*(WH+gap), 0);
        }
    }
    return self;
}

@end
