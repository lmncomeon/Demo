//
//  NSString+SDKCustomString.m
//  songShuFinance
//
//  Created by 梁家文 on 15/9/16.
//  Copyright (c) 2015年 李贵文. All rights reserved.
//

#import "NSString+SDKCustomString.h"
#import <AdSupport/ASIdentifierManager.h>
@implementation NSString (SDKCustomString)
+(NSString *)getCurrentTime
{
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:+3600*8];
    NSString * currentTime =[NSString stringWithFormat:@"%@",date];
    currentTime = [currentTime substringWithRange:NSMakeRange(0,10)];
    return currentTime;
}
+(NSString *)selectInvestTime:(NSString  *) time
{
    int t = [time intValue];
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:(t-1)*3600*24+3600*8];
    NSString * currentTime =[NSString stringWithFormat:@"%@",date];
    currentTime = [currentTime substringWithRange:NSMakeRange(0,10)];
    return currentTime;
}


+(NSString *)CurrentTime:(NSString *)time
{
    int t = [time intValue];
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:t*3600*24+3600*8];
    NSString * currentTime =[NSString stringWithFormat:@"%@",date];
    currentTime = [currentTime substringWithRange:NSMakeRange(5,5)];
    return currentTime;
}


#pragma mark - 时间戳转换
+ (NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString{
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}
#pragma mark - 时间戳转换
+ (NSString *)stringWithDateFrom1970:(long long)date withFormat:(NSString *)formatString{
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}
#pragma mark - 禁止四舍五入
+(NSString *)roundDown:(float)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
//进位
+ (NSString *)roundUp:(double)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
+(NSString *)getIdfa{
    NSString * idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}
//活期星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
+(NSString*)formatMoneyString:(double)money{
    
    NSString *formatterDouble = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:money] numberStyle:NSNumberFormatterCurrencyStyle];
    NSMutableString *deleteLetter = [NSMutableString stringWithString:formatterDouble];
    for (int i =0; i< deleteLetter.length; i++) {
        unichar c = [deleteLetter characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ((c >= 'A' && c <= 'Z')||(c >= 'a' && c <= 'z')) {
            [deleteLetter deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:deleteLetter];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\| ~＜＞$€^•'@#$%^&*()_+'\"￥ "];
    NSString *moneyString = [newstr stringByTrimmingCharactersInSet:set];
    return moneyString;
}

+(NSString*)formatIntegerMoneyString:(double)money{
    
    NSString *formatterDouble = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:money] numberStyle:NSNumberFormatterDecimalStyle];
    NSMutableString *deleteLetter = [NSMutableString stringWithString:formatterDouble];
    for (int i =0; i< deleteLetter.length; i++) {
        unichar c = [deleteLetter characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ((c >= 'A' && c <= 'Z')||(c >= 'a' && c <= 'z')) {
            [deleteLetter deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:deleteLetter];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\| ~＜＞$€^•'@#$%^&*()_+'\"￥ "];
    NSString *moneyString = [newstr stringByTrimmingCharactersInSet:set];
    return moneyString;
}

+(NSString *)translation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    if ([chinese isEqualToString:@"一"]) {
        chinese = @"首";
    }
    return chinese;
}


@end
