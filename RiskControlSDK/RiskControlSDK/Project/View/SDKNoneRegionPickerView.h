//
//  SDKNoneRegionPickerView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/3.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

//========================= 只有省、市 =========================

@class SDKPickerModel;

@interface SDKNoneRegionPickerView : UIView

- (instancetype)initWithList:(NSArray <SDKPickerModel *> *)list;

- (void)show;

@property (nonatomic, copy) void (^sendValueEvent)(NSString *);

@end
