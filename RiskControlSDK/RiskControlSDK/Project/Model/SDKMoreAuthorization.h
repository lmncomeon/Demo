//
//  SDKMoreAuthorization.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/23.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKMoreAuthorization : NSObject

@property (nonatomic, copy) NSString *imgURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isPass;

+ (NSArray *)createDatas;

@end
