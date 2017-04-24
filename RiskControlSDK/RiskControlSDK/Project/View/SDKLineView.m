//
//  SDKLineView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/16.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKLineView.h"
#import "SDKProjectHeader.h"

@implementation SDKLineView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[SDKLineView alloc] initWithFrame:frame];
        self.backgroundColor = color;
    }
    return self;
}

+ (instancetype)screenWidthLineWithY:(CGFloat)y {
    SDKLineView *line = [[SDKLineView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 0.5f)];
    line.backgroundColor = cuttingLineColor;
    return line;
}

@end
