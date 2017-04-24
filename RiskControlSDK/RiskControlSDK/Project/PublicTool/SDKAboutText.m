//
//  SDKAboutText.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKAboutText.h"

@implementation SDKAboutText

+ (CGFloat)calculateTextHeight:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    return [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
}

+ (CGFloat)calcaulateTextWidth:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width;
}

//计算宽度高度
+ (CGSize)sizeWithString:(NSString *)string maxWidth:(CGFloat)maxWidth font:(UIFont *)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, 800)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
    
}


+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    if (!unicodeStr) {
        unicodeStr = @"";
    }
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
    
}

@end
