//
//  SDKCreditMainViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"
@class SDKCreditMainModel;

@interface SDKCreditMainViewController : SDKBaseViewController

@property (nonatomic, strong) NSArray <SDKCreditMainModel *> *list;
@property (nonatomic, strong) NSDictionary *authDic;

@end
