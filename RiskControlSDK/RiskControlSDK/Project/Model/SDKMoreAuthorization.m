//
//  SDKMoreAuthorization.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/23.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKMoreAuthorization.h"

@implementation SDKMoreAuthorization

+ (NSArray *)createDatas {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0; i < 3; i++) {
        SDKMoreAuthorization *model = [SDKMoreAuthorization new];
        model.name = @"运行商授权";
        model.type = @"(二选一)";
        [tmp addObject:model];
    }
    return tmp.copy;
}

@end
