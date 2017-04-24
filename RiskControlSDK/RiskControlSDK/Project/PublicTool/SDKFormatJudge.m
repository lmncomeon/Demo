//
//  SDKFormatJudge.m
//  supplier
//
//  Created by joke on 16/5/28.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "SDKFormatJudge.h"
#import "SDKProjectHeader.h"
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

@implementation SDKFormatJudge

+ (NSString *)stringWithdateFrom1970:(long long)date withFormat:(NSString *)formatString {
    NSDate *dateInfo = [NSDate date];
    if ([NSString stringWithFormat:@"%lld", date].length == 13) {
        dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    }else if ([NSString stringWithFormat:@"%lld", date].length == 10) {
        dateInfo = [NSDate dateWithTimeIntervalSince1970:date];
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}

#pragma mark - 验证姓名
+ (BOOL)isValidateRealName:(NSString *)realName {
    NSString *regex = @"^[A-Za-z·\\u4e00-\\u9fa5]+$";
    NSPredicate *realNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [realNamePredicate evaluateWithObject:realName];
}
#pragma mark - 验证身份证号码
+ (BOOL)isValidateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
            break;
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                NSInteger S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                NSInteger Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
            break;
        default:
            return NO;
            break;
    }
}
#pragma mark - 验证手机号码
+ (BOOL)isValidateMobile:(NSString *)mobile {
    NSString * phoneRegex = @"^1\\d{10}$";
    NSPredicate * phoneText= [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneText evaluateWithObject:mobile];
};
#pragma mark - 验证密码各式
+ (BOOL)isValidatePassword:(NSString *)password {
    //判断是否包含数字
    NSString *regex1 = @".*[0-9]+.*";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch1 = [pred1 evaluateWithObject:password];
    //判断是否包含小写字母
    NSString *regex2 = @".*[a-zA-Z]+.*";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL isMatch2 = [pred2 evaluateWithObject:password];
    if (isMatch1 == 1 && isMatch2 == 1) {
        return YES;
    }else {
        return NO;
    }
}
#pragma mark - Email格式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString * emailRegex = @"^(\\w-*\\.*)+@(\\w-?)+(\\.\\w{2,})+$";
    NSPredicate * emailText= [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailText evaluateWithObject:email];
}

#pragma mark - 数据转json
/**
 *  数据数组转换为String格式
 *
 *  @param tmpArray 要处理的数组
 *
 *  @return 格式化之后的字符串
 */
+ (NSString *)arrayBecomeJsonWithArray:(NSArray *)tmpArray {
    if (tmpArray == nil) {
        return nil;
    }
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpArray options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        DLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}
#pragma mark - 设置默认提示文字
+ (NSMutableAttributedString *)setTipTextWithString:(NSString *)string {
    NSMutableAttributedString *placeHolderString = [[NSMutableAttributedString alloc] initWithString:string];
    [placeHolderString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xccd1d6)} range:NSMakeRange(0, [string length])];
    return placeHolderString;
}

//显示图标
+ (UIImage *)stringWithBankCodeImage:(NSString *)bankCode{
    UIImage *result = nil;
    if ([bankCode isEqualToString:@"ICBC"]) {//工商
        result = [UIImage imageNamed:@"bankCode-ICBC"];
    }else if ([bankCode isEqualToString:@"CCB"]) {//建设
        result = [UIImage imageNamed:@"bankCode-CCB"];
    }else if ([bankCode isEqualToString:@"ABC"]) {//农业
        result = [UIImage imageNamed:@"bankCode-ABC"];
    }else if ([bankCode isEqualToString:@"BOC"]) {//中国
        result = [UIImage imageNamed:@"bankCode-BOC"];
    }else if ([bankCode isEqualToString:@"GZCB"]) {//广州
        result = [UIImage imageNamed:@"bankCode-GZCB"];
    }else if ([bankCode isEqualToString:@"GDB"]) {//广发
        result = [UIImage imageNamed:@"bankCode-GDB"];
    }else if ([bankCode isEqualToString:@"SPDB"]) {//浦发
        result = [UIImage imageNamed:@"bankCode-SPDB"];
    }else if ([bankCode isEqualToString:@"CMBC"]) {//民生
        result =[UIImage imageNamed:@"bankCode-CMBC"];
    }else if ([bankCode isEqualToString:@"ECITIC"]) {//中信
        result =[UIImage imageNamed:@"bankCode-ECITIC"];
    }else if ([bankCode isEqualToString:@"SZPA"]) {//平安
        result = [UIImage imageNamed:@"bankCode-SZPA"];
    }else if ([bankCode isEqualToString:@"HXB"]) {//华夏
        result = [UIImage imageNamed:@"bankCode-HXB"];
    }else if ([bankCode isEqualToString:@"CEB"]) {//光大
        result = [UIImage imageNamed:@"bankCode-CEB"];
    }else if ([bankCode isEqualToString:@"CIB"]) {//兴业
        result = [UIImage imageNamed:@"bankCode-CIB"];
    }else if ([bankCode isEqualToString:@"PSBC"]) {//邮政储蓄
        result =[UIImage imageNamed:@"bankCode-PSBC"];
    }else if ([bankCode isEqualToString:@"CMBCHINA"]) {//招商
        result = [UIImage imageNamed:@"bankCode-CMBCHINA"];
    }else if ([bankCode isEqualToString:@"BOCO"]) {//交通
        result = [UIImage imageNamed:@"bankCode-BOCO"];
    }else {
        //        result = [UIImage imageNamed:@"bankCode-BOC"];
    }
    return result;
}

@end
