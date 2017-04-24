//
//  SDKInputTypeViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"
@class SDKAnswerModel;
@interface SDKInputTypeViewController : SDKBaseViewController

@property (nonatomic, strong) NSArray <SDKAnswerModel *> *arr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) void (^answerEnd)();
@property (nonatomic, copy) void (^backEvent)();

@end
