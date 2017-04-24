//
//  NSString+SDKDate.h
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/29.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SDKDate)
+ (NSString *)stringWithAllDate:(long long)date;
+ (NSString *)stringWithDateFrom1970:(long long)date;
+ (NSString *)abcStringWithDateFrom1970:(long long)date;
+ (NSString *)abcStringWithDate:(long long)date;
+ (NSString *)stringWithDate:(long long)date;
+ (NSString *)stringWithNoticeDate:(long long)noticedate;

@end
