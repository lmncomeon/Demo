//
//  SDKSelectView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKBaseView.h"

@class SDKPickerModel;

@interface SDKSelectView : SDKBaseView

/** first kind **/
- (instancetype)initWithFrame:(CGRect)frame left:(NSString *)left right:(NSString *)right list:(NSArray <SDKPickerModel *> *)list;

@property (nonatomic, copy) void (^sendValue)(SDKPickerModel *);


/** first second **/
- (instancetype)initWithFrame:(CGRect)frame left:(NSString *)left right:(NSString *)right;

@property (nonatomic, strong) NSMutableArray <SDKPickerModel *> *dataArray;

- (void)nextMethod;



// 赋值
- (void)showContentWithPickerModel:(SDKPickerModel *)model;

// clear value
- (void)clearValue;


// retuen value
- (SDKPickerModel *)selectedModel;

@end
