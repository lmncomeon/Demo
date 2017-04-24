//
//  SDKCommonPickerView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDKPickerModel;

@interface SDKCommonPickerView : UIView

- (instancetype)initWithList:(NSArray <SDKPickerModel *> *)list;

@property (nonatomic, strong) NSMutableArray <SDKPickerModel *> *list;

- (void)show;

@property (nonatomic, copy) void (^sendValue)(SDKPickerModel *m);

@end
