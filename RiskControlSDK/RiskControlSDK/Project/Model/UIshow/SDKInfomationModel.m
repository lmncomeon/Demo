//
//  SDKInfomationModel.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKInfomationModel.h"
#import "SDKCommonModel.h"

@implementation SDKInfomationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [SDKCommonModel class] };
}

@end
