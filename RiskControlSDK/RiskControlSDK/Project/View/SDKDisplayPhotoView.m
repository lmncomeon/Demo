//
//  SDKDisplayPhotoView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/1.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKDisplayPhotoView.h"
#import "SDKCommonModel.h"
#import "SDKCustomLabel.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "UIImageView+WebCache.h"

@interface SDKDisplayPhotoView ()

@property (nonatomic, strong) SDKCommonModel *currentModel;

@end

static NSInteger maxNum = 2;

@implementation SDKDisplayPhotoView

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        
        _currentModel = model;
        
        NSArray *tmp = [self getListByModel];
        NSArray *nameArr = [self getNames];
        
        NSInteger count = tmp.count;
        int row, col;
        
        CGFloat padding = adaptX(15);
        CGFloat imgW    = (frame.size.width- (maxNum+1)*padding) / maxNum;
        CGFloat imgH    = adaptY(80);
        for (int i = 0; i < count; i++) {
            row = i /maxNum;
            col = i %maxNum;
            
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(padding+ col*(padding+imgW), padding+ row*(padding+imgH+adaptY(30)), imgW, imgH)];
            [imgview sd_setImageWithURL:[NSURL URLWithString:tmp[i]]];
            [self addSubview:imgview];
            
            SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:nameArr[i] setLabelFrame:CGRectMake(imgview.x, CGRectGetMaxY(imgview.frame), imgview.width, adaptY(30)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
            [self addSubview:lab];
            
        }
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame) + padding;
        
    }
    return self;
}


- (NSArray <NSString *> *)getListByModel {
    NSMutableArray *tmp = [NSMutableArray array];
    if (_currentModel.value1 && ![_currentModel.value1 isEqualToString:@""]) {
        [tmp addObject:_currentModel.value1];
    }
    if (_currentModel.value2 && ![_currentModel.value2 isEqualToString:@""]) {
        [tmp addObject:_currentModel.value2];
    }
    if (_currentModel.value3 && ![_currentModel.value3 isEqualToString:@""]) {
        [tmp addObject:_currentModel.value3];
    }
    return tmp.copy;
}

- (NSArray <NSString *> *)getNames {
    NSMutableArray *tmp = [NSMutableArray array];
    [tmp addObject:_currentModel.label];
    [tmp addObject:_currentModel.label2];
    [tmp addObject:_currentModel.label3];
    return tmp.copy;
}

@end
