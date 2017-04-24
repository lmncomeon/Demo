
//
//  SDKFormatJudge.h
//  supplier
//
//  Created by joke on 16/5/28.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SDKFormatJudge : NSObject
/**
 *  时间转换
 */
+ (NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString;
/**
 *  验证姓名
 */
+ (BOOL)isValidateRealName:(NSString *)realName;
/**
 *  验证身份证号码
 */
+ (BOOL)isValidateIDCardNumber:(NSString *)value;
/**
 *  手机号格式判断
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;
/**
 *  密码格式判断
 */
+ (BOOL)isValidatePassword:(NSString *)password;
/**
 *  Email格式判断
 */
+ (BOOL)isValidateEmail:(NSString *)email;


#pragma mark - 数据转json
/**
 *  数据数组转换为String格式
 *
 *  @param tmpArray 要处理的数组
 *
 *  @return 格式化之后的字符串
 */
+ (NSString *)arrayBecomeJsonWithArray:(NSArray *)tmpArray;

#pragma mark - 设置默认提示文字
+ (NSMutableAttributedString *)setTipTextWithString:(NSString *)string;

+ (UIImage *)stringWithBankCodeImage:(NSString *)bankCode;

@end
