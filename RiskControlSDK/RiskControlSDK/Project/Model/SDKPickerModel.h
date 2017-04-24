//
//  SDKPickerModel.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/18.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDKPickerModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) NSMutableArray <SDKPickerModel *> *list;

@end
