//
//  CommonService.m
//  TestDemo
//
//  Created by 栾美娜 on 2017/4/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "CommonService.h"
#import <CommonCrypto/CommonDigest.h>

//屏幕尺寸
#define kScreenFrame    [UIScreen mainScreen].bounds
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define AppKey          @"112233445566"

#if DEBUG

#define BaseUrl @"https://app.jianguodai.com"         //最新测试地址2016/09/14

#else

#define BaseUrl @"https://app.squloan.com"        //正式环境（新小贷）

#endif

@implementation CommonService


+ (AFHTTPRequestOperationManager *)createObject {
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manger.securityPolicy = securityPolicy;
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript",@"application/json",@"text/plain",@"text/html", @"image/jpeg", @"image/jpg", nil];
    return  manger;
}

#pragma mark - 获取 token
/**
 *  获取平台token
 *
 *  @param success access_token
 *  @param failure error/operation
 */
+ (void)requestAccesstokensuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * timeStamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
    NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * system = [NSString stringWithFormat:@"iOS%@",[[UIDevice currentDevice] systemVersion]];
    NSString * width = [NSString stringWithFormat:@"%.f",kScreenWidth];
    NSString * height = [NSString stringWithFormat:@"%.f",kScreenHeight];
    
    
    NSDictionary * param = @{@"timestamp": timeStamp,@"token": @"&*0$(97$&*&dJhfK-29(@5jdfGgjdX29",@"source": @"mobile",@"version": appVersion,@"system": system,@"width": width,@"height": height};
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    if (param) {
        [paramsDic setValuesForKeysWithDictionary:param];
    }
    NSMutableString * signatureString = [NSMutableString string];
    NSArray * sortedKeys = [[paramsDic allValues] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in sortedKeys) {
        [signatureString appendFormat:@"%@",key];
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData * stringBytes = [signatureString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * signature = [NSString string];
    if (CC_SHA1([stringBytes bytes], (CC_LONG)[stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString * digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i = 0; i< CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02x",aChar];
        }
        signature = digestString;
    }
    NSDictionary * parameters = @{@"signature": signature, @"timestamp": timeStamp, @"source": @"mobile",@"version": appVersion,@"system": system,@"width": width,@"height": height, @"appkey" : AppKey};
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manger.securityPolicy = securityPolicy;
    [manger POST:[NSString stringWithFormat:@"%@/accesstoken",BaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}


/**
 *  登录
 *
 *  @param access_token <#access_token description#>
 *  @param username     <#username description#>
 *  @param password     <#password description#>
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+ (void)requestLoginOfaccess_token:(NSString *)access_token
                          username:(NSString *)username
                          password:(NSString *)password
                      lastPosition:(NSString *)lastPosition
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSDictionary * parameters = [NSDictionary dictionary];
    if (lastPosition == nil) {
        parameters = @{@"access_token": access_token, @"username": username, @"password": [password md5], @"source": @"iOS"};
    }else{
        parameters = @{@"access_token": access_token, @"username": username, @"password": [password md5], @"lastPosition":lastPosition,@"source": @"iOS"};
    }
    AFHTTPRequestOperationManager * manger = [self createObject];
    [manger POST:[NSString stringWithFormat:@"%@/user/login",BaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

@end


@implementation NSString (encrypto)

- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

@end
