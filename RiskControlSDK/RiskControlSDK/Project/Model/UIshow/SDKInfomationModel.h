//
//  SDKInfomationModel.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDKCommonModel;

@interface SDKInfomationModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *depict;

@property (nonatomic, strong) NSArray <SDKCommonModel *> *items;

@end
