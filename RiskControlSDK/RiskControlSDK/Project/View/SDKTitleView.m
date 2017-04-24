//
//  SDKTitleView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKTitleView.h"
#import "SDKProjectHeader.h"
#import "SDKCustomLabel.h"
#import "SDKAboutText.h"
#import "SDKLineView.h"
#import "UIView+SDKCustomView.h"

@interface SDKTitleView ()

@property (nonatomic, strong) SDKLineView *bottomL;

@end

@implementation SDKTitleView

- (instancetype)initWithFrame:(CGRect)frame colorLump:(UIColor *)colorLump text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        CGFloat commonY = adaptY(17);
        UIView *square = [[UIView alloc] initWithFrame:CGRectMake(kDefaultPadding, commonY, adaptX(3), adaptY(12))];
        square.backgroundColor = colorLump;
        [self addSubview:square];
        
        CGFloat labX = CGRectGetMaxX(square.frame)+adaptX(6);
        CGFloat labW = (frame.size.width-labX-kDefaultPadding);
        CGFloat labH = [SDKAboutText calculateTextHeight:text maxWidth:labW font:kFont(14)];
        if (labH < adaptY(12)) {
            labH = adaptY(12);
        }
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:text setLabelFrame:CGRectMake(labX, commonY-adaptY(2), labW, labH) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        lab.numberOfLines = 0;
        [self addSubview:lab];
        
        self.height = CGRectGetMaxY(lab.frame)+adaptY(5);
        
        _bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, self.height-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [self addSubview:_bottomL];
    }
    
    return self;
}

- (void)noneBottomLine {
    _bottomL.hidden = true;
}




@end
