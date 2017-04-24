//
//  SDKDefaultSetting.h
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/23.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DefaultSettingFile @"defaultSetting"
@interface SDKDefaultSetting : NSObject

@property (assign, nonatomic) NSInteger uid;//保存最近登录用户uid
@property (strong, nonatomic) NSString *mobile;/**< 保存手机号 */

@property (strong, nonatomic) NSString *access_token;//应用识别码
@property (assign, nonatomic) long long access_tokenTimeStamp;//应用识别码有效期
- (void)clearData;
+ (instancetype)defaultSettingWithFile;
+ (void)saveSetting:(SDKDefaultSetting *)setting;

@end
