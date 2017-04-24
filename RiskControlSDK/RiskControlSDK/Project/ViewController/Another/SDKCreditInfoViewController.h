//
//  SDKCreditInfoViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/1.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface SDKCreditInfoViewController : SDKBaseViewController

@property (nonatomic, strong) NSArray <SDKCommonModel *> *dataArray;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL edit;

@end
