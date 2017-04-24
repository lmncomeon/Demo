//
//  NSString+SDKDate.m
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/29.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "NSString+SDKDate.h"

@implementation NSString (SDKDate)

#pragma mark - 日期转换
+ (NSString *)stringWithAllDate:(long long)date {
    if ([NSString stringWithFormat:@"%lld", date].length == 13) {
        date = date/1000;
    }else if ([NSString stringWithFormat:@"%lld", date].length == 10) {
        date = date;
    }
    
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *dateString = [NSString string];
    if (date ==0) {
        dateString = @" ";
    }else{
        dateString = [formatter stringFromDate:dateInfo];
    }
    
    return dateString;
}

+ (NSString *)stringWithDateFrom1970:(long long)date {
    
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *dateString = [NSString string];
    if (date ==0) {
        dateString = @" ";
    }else{
       dateString = [formatter stringFromDate:dateInfo];
    }
    
    return dateString;
}

+ (NSString *)abcStringWithDateFrom1970:(long long)date {
    if ([NSString stringWithFormat:@"%lld", date].length == 13) {
        date = date/1000;
    }else if ([NSString stringWithFormat:@"%lld", date].length == 10) {
        date = date;
    }
    
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [NSString string];
    if (date ==0) {
        dateString = @" ";
    }else{
        dateString = [formatter stringFromDate:dateInfo];
    }
    return dateString;
}

+ (NSString *)abcStringWithDate:(long long)date {
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [NSString string];
    if (date ==0) {
        dateString = @" ";
    }else{
        dateString = [formatter stringFromDate:dateInfo];
    }
    return dateString;
}

+ (NSString *)stringWithDate:(long long)date {
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *dateString = [NSString string];
    if (date ==0) {
        dateString = @" ";
    }else{
        dateString = [formatter stringFromDate:dateInfo];
    }
    return dateString;
}

+ (NSString *)stringWithNoticeDate:(long long)noticedate {
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:noticedate];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateString = [NSString string];
    if (noticedate ==0) {
        dateString = @" ";
    }else{
        dateString = [formatter stringFromDate:dateInfo];
    }
    return dateString;
}

@end
