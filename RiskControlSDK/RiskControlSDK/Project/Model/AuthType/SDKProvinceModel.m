//
//  SDKProvinceModel.m
//  MN_PickerView_Demo
//
//  Created by 范宏泳 on 16/1/9.
//  Copyright © 2016年 范宏泳. All rights reserved.
//

#import "SDKProvinceModel.h"

@implementation SDKProvinceModel

- (NSMutableArray *)areaList {
    if (!_areaList) {
        _areaList = [NSMutableArray array];
    }
    return _areaList;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _province = dict[@"province"];
        
        NSArray *array = dict[@"areaList"];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *tempDict in array) {
            SDKCityModel *cityM = [[SDKCityModel alloc] initWithDict:tempDict];
            [mutableArray addObject:cityM];
        }
        _areaList = mutableArray;
    }
    return self;
}
@end


@implementation SDKCityModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _area = dict[@"area"];
        _areaId   = [dict[@"areaId"] integerValue];
        _flag = [dict[@"flag"] integerValue];
    }
    return self;
}

@end
