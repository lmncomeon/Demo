//
//  SDKProjectHeader.m
//  GTriches
//
//  Created by devair on 14-10-9.
//  Copyright (c) 2014年 eric. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "SDKProjectHeader.h"

//NSUInteger DeviceSystemMajorVersion() {
//    static NSUInteger systemMajorVersion = -1;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        systemMajorVersion = [[[[[UIDevice currentDevice] systemVersion]
//                                componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
//    });
//    
//    return systemMajorVersion;
//}

@implementation NSString (encrypto)

- (NSString*) sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSString *)formatDateSince1970:(long long)date formatString:(NSString *)format {
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:dateInfo];
    return dateString;
}

- (NSString *)formatLocationCurrency:(double)currency{
    NSString *currencyString = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:currency] numberStyle:NSNumberFormatterCurrencyStyle];
    currencyString = [currencyString substringFromIndex:1];
    return currencyString;
}

@end
