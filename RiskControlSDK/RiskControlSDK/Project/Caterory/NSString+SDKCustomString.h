//
//  NSString+SDKCustomString.h
//  songShuFinance
//
//  Created by 梁家文 on 15/9/16.
//  Copyright (c) 2015年 李贵文. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (SDKCustomString)
//获取当前时间
+(NSString *)getCurrentTime;
//获取选中的时间与当前时间相差多少天
+(NSString *)selectInvestTime:(NSString *) time;
//时间戳转换
+(NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString;
+ (NSString *)stringWithDateFrom1970:(long long)date withFormat:(NSString *)formatString;
//禁止四舍五入
+ (NSString *)roundDown:(float)number afterPoint:(int)position;
+ (NSString *)roundUp:(double)number afterPoint:(int)position;
//获取idfa
+(NSString *)getIdfa;

//活期时间
+(NSString *)CurrentTime:(NSString  *)time;

//活期星期几
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//格式化钱的格式
+(NSString*)formatMoneyString:(double)money;
//格式化整数 不带小数点
+(NSString*)formatIntegerMoneyString:(double)money;
//字符串转中文
+(NSString *)translation:(NSString *)arebic;

@end

