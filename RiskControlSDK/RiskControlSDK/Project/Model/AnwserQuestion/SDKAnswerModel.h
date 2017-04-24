//
//  SDKAnswerModel.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/8.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDKOptionModel;

@interface SDKAnswerModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray <SDKOptionModel *> *options;

@end
