//
//  SDKEditCreditInfoViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/10.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

// 暂时不用
@interface SDKEditCreditInfoViewController : SDKBaseViewController

@property (nonatomic, strong) NSArray <SDKCommonModel *> *dataArray;
@property (nonatomic, strong) NSArray <SDKPickerModel *> *areaList;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *name;

@end
