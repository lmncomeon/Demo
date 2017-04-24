//
//  SDKProvinceModel.h
//  MN_PickerView_Demo
//
//  Created by 范宏泳 on 16/1/9.
//  Copyright © 2016年 范宏泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKProvinceModel : NSObject

@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSMutableArray  *areaList;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end


@interface SDKCityModel : NSObject

@property(nonatomic,strong) NSString *area;
@property(assign, nonatomic) NSInteger areaId;
@property(nonatomic, assign) NSInteger flag;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
