//
//  SDKCommonModel.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDKOptionModel;
@interface SDKCommonModel : NSObject

// image radio list text area phone checkbox mailbox readtext
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *hint;     // 控件下方提示
@property (nonatomic, copy) NSString *imageurl; // 背景图或图标地址

@property (nonatomic, copy) NSString *label;    // 输入项前端项标签
@property (nonatomic, copy) NSString *label2;   // 输入项前端项标签，当组件有第二个输入项时
@property (nonatomic, copy) NSString *label3;   // 输入项前端项标签，当组件有第三个输入项

@property (nonatomic, copy) NSString *name;     // 输入项名称
@property (nonatomic, copy) NSString *name2;    // 入项名称，当组件有第二个输入项时
@property (nonatomic, copy) NSString *name3;    // 入项名称，当组件有第三个输入项时

@property (nonatomic, copy) NSString *placeholder; // 输入项内提示语
@property (nonatomic, copy) NSString *placeholder2;
@property (nonatomic, copy) NSString *placeholder3;

// list或radio的选项
@property (nonatomic, strong) NSArray <SDKOptionModel *> *options;

@property (nonatomic, assign) BOOL required;       // 是否必须填写


// 某一项的详情
@property (nonatomic, copy) NSString *value1;
@property (nonatomic, copy) NSString *value2;
@property (nonatomic, copy) NSString *value3;

@end






// ===============================================================
@interface SDKOptionModel : NSObject

@property (nonatomic, copy) NSString *text;  // 显示文字
@property (nonatomic, copy) NSString *value; // 值

@end
