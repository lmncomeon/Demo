//
//  SDKCreditMainModel.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCreditMainModel.h"
#import "SDKProjectHeader.h"

@implementation SDKCreditMainModel

+ (NSArray *)getList {
    NSArray *nameArr = @[@"身份认证", @"银行卡认证", @"基本信息", @"职业信息", @"社交信息"];
    NSArray *color = @[UIColorFromRGB(0xff712e), UIColorFromRGB(0x5bc5ff), UIColorFromRGB(0xad5ffa), UIColorFromRGB(0xff5381), UIColorFromRGB(0x5bb0ff)];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < nameArr.count; i++) {
        SDKCreditMainModel *model = [SDKCreditMainModel new];
        model.itemName = nameArr[i];
        
        
        [tmp addObject:model];
    }
    
    return tmp.copy;
}

+ (UIColor *)getRandomColor {
    NSArray *color = @[UIColorFromRGB(0xff712e), UIColorFromRGB(0x5bc5ff), UIColorFromRGB(0xad5ffa), UIColorFromRGB(0xff5381), UIColorFromRGB(0x5bb0ff)];
    
    return color[arc4random_uniform(color.count)];
}

@end
