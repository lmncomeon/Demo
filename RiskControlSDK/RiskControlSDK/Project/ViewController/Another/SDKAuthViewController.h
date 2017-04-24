//
//  SDKAuthViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/4/11.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"

typedef enum : NSUInteger {
    Entrance_credit, // 信用资料
    Entrance_out     // 外部
} Entrance;

@interface SDKAuthViewController : SDKBaseViewController

@property (nonatomic, strong) NSArray <SDKCommonModel *> * dataList;
//@property (nonatomic, assign) BOOL edit;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) Entrance type; // 入口

@end
