//
//  SDKCreditNumTwoViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/20.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

@interface SDKCreditNumTwoViewController : SDKBaseViewController

@property (nonatomic, strong) NSArray <SDKInfomationModel *> *data;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, strong) NSArray <SDKPickerModel *> *areaList;

@end
