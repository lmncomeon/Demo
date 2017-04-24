//
//  SDKAnswerModel.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKAnswerModel.h"
#import "SDKCommonModel.h"
@implementation SDKAnswerModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"options" : [SDKOptionModel class] };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end
