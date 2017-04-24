//
//  SDKcommonService.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/16.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCommonService.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDKProjectHeader.h"

@implementation SDKCommonService

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
+ (void)requestAccesstokenWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString * timeStamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
    NSString * appVersion = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSString * system = [NSString stringWithFormat:@"iOS%@",[[UIDevice currentDevice] systemVersion]];
    NSString * width = [NSString stringWithFormat:@"%.f",kScreenWidth];
    NSString * height = [NSString stringWithFormat:@"%.f",kScreenHeight];
    NSString * appkey = @"112233445566";
    NSString * imei    = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString * secretKey = @"fc9caf5bae6a13cad474df97531e0772";
    
    NSDictionary * param = @{
                             @"timestamp": timeStamp,
                             @"appkey" : appkey,
//                             @"userid" : userid,
                             @"version": appVersion,
                             @"imei"   : imei,
                             @"system" : system,
                             @"width"  : width,
                             @"height" : height,
                             @"secretKey" : secretKey
                             };
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
    NSDictionary * parameters = @{
                                  @"signature": signature,
                                  @"timestamp": timeStamp,
                                  @"appkey" : appkey,
//                                  @"userid" : userid,
                                  @"version": appVersion,
                                  @"imei"   : imei,
                                  @"system" : system,
                                  @"width"  : width,
                                  @"height" : height,
                                  @"secretKey" : secretKey
                                  };
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manger.securityPolicy = securityPolicy;
    [manger GET:[NSString stringWithFormat:@"%@/m/accesstoken",BaseAPPUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}



#pragma mark - 检查用户当前状态
+ (void)checkUserStatusSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:kProductType forKey:@"productType"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/checkUserStatus", parameters);
    [manger GET:[NSString stringWithFormat:@"%@/m/api/checkUserStatus",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


#pragma mark - 获取短信验证码
/**
 获取短信验证码
 
 @param type 0短信 1语音
 @param mobile 手机号
 */
+ (void)requestVerifyCodeWithMobile:(NSString *)mobile
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:@(0) forKey:@"type"];
    [parameters setObject:@"onLineActive" forKey:@"business"];
    [parameters setObject:mobile forKey:@"mobile"];

    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/msg/getVerifyCode", parameters);
    [manger GET:[NSString stringWithFormat:@"%@/m/api/msg/getVerifyCode",BaseAPPUrl]
     parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(operation, responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error);
            }
        }];
}


#pragma mark - 激活第一步提交
/**
 激活第一步提交
 
 @param validatecode 验证码
 @param mobile 手机号码
 */
+ (void)activeStepOneSubmitWithValidatecode:(NSString *)validatecode
                                     mobile:(NSString *)mobile
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:validatecode forKey:@"validatecode"];
    [parameters setObject:mobile forKey:@"mobile"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/active/step1", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/active/step1",BaseAPPUrl]
     parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(operation, responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error);
            }
        }];

}


#pragma mark - 激活第二步提交
/**
 激活第二步提交
 @param realname 姓名
 @param idcardno 身份证号码
 @param 
 */
+ (void)activeStepTwoSubmitWithRealname:(NSString *)realname
                               idcardno:(NSString *)idcardno
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:realname forKey:@"realname"];
    [parameters setObject:idcardno forKey:@"idcardno"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/active/step2", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/active/step2",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


#pragma mark - 激活第三步提交
/**
 激活第三步提交
 @param bankcard Array[string]
 */
+ (void)activeStepThreeSubmitWithBankcard:(NSString *)bankcard
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:bankcard forKey:@"bankcard"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/active/step3", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/active/step3",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


#pragma mark - 获取资料提交步骤
/**
 获取资料提交步骤

 @param productType 贷款产品类型
 */
+ (void)infomationGetStepsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:kProductType forKey:@"productType"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/getSteps", parameters);
    [manger GET:[NSString stringWithFormat:@"%@/m/api/applyment/getSteps",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

#pragma mark - 文件上传
/**
 文件上传
 
 @param type image video audio
 @param file
 */
+ (void)uplodFileWithType:(NSString *)type
                     file:(void (^)(id <AFMultipartFormData> formData))file
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:type forKey:@"type"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/uploadFile", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/uploadFile",BaseAPPUrl]
      parameters:parameters
constructingBodyWithBlock:file
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}



#pragma mark - 资料提交
/**
 资料提交
 
 @param stepName 当前步骤的名称
 @param content 当前步骤全部数据，json的key:value格式
 @param productType 贷款产品类型
 */
+ (void)infomationSubmitWithStepName:(NSString *)stepName
                             content:(NSString *)content
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:kProductType forKey:@"productType"];
    [parameters setObject:stepName forKey:@"stepName"];
    [parameters setObject:content forKey:@"content"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/post", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/applyment/post",BaseAPPUrl]
     parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(operation, responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error);
            }
        }];

}



#pragma mark - 获取省市区
+ (void)requestProvinceCityZoneSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/json/cities.json", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/json/cities.json",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}



#pragma mark - 信审资料主页列表
+ (void)requestCreditListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/getCreditList", parameters);
    [manger GET:[NSString stringWithFormat:@"%@/m/api/applyment/getCreditList",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


#pragma mark - 获取某项资料详情
/**
 获取某项资料详情
 @param type [身份认证、银行卡信息、基本信息、职业信息、联系人信息]
 */
+ (void)requestCreditInfoWithType:(NSString *)type
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:type forKey:@"type"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/getCreditInfo", parameters);
    [manger GET:[NSString stringWithFormat:@"%@/m/api/applyment/getCreditInfo",BaseAPPUrl]
     parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(operation, responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(operation, error);
            }
        }];
}


#pragma mark - 提交其他资料
/**
 提交其他资料
 @param type [contact]
 @param content
 */
+ (void)submitExtraInfoWithContent:(NSString *)content
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:@"contact" forKey:@"type"];
    [parameters setObject:content forKey:@"content"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/extraInfo", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/applyment/extraInfo",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


#pragma mark - 获取公积金/社保 对应的城市列表
+ (void)requestAccumulationFundAndSocialSecurityWithType:(NSInteger)type
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"type"];

    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/authorize/getArea", parameters);
    
    [manger GET:[NSString stringWithFormat:@"%@/m/api/authorize/getArea", BaseAPPUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark  社保 认证接口
+ (void)requestSocialSecurityWithCertificationWithFiled:(NSString *)filed
                                                      areaId:(NSInteger)areaId
                                                    ownerNum:(NSString *)ownerNum
                                                      sbCode:(NSString *)sbCode
                                                       sbNum:(NSString *)sbNum
                                                        flag:(NSInteger)flag
                                                    userName:(NSString *)userName
                                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary * parameters = @{@"access_token": kgetCommonData(keyName_token),
                                  @"filed":filed,
                                  @"areaId":[NSNumber numberWithInteger:areaId],
                                  @"ownerNum":ownerNum,
                                  @"sbCode":sbCode,
                                  @"sbNum":sbNum,
                                  @"flag":[NSNumber numberWithInteger:flag],
                                  @"userName":userName,
                                  @"source":@"ios"};
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/authorize/socialsecurity", parameters);
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    [manger POST:[NSString stringWithFormat:@"%@/m/api/authorize/socialsecurity",BaseAPPUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}


#pragma mark  公积金 认证接口
+ (void)requestAccumulationFundWithCertificationWithFiled:(NSString *)filed
                                                        areaId:(NSInteger)areaId
                                                      userName:(NSString *)userName
                                                  reserveFunds:(NSString *)reserveFunds
                                                        mobile:(NSString *)mobile
                                                      joinCard:(NSString *)joinCard
                                                          flag:(NSInteger)flag
                                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

    NSDictionary * parameters = @{@"access_token": kgetCommonData(keyName_token),
                                  @"filed":filed,
                                  @"areaId":[NSNumber numberWithInteger:areaId],
                                  @"userName":userName,
                                  @"reserveFunds":reserveFunds,
                                  @"mobile":mobile,
                                  @"joinCard":joinCard,
                                  @"flag":[NSNumber numberWithInteger:flag],
                                  @"source"      : @"iOS"};
    AFHTTPRequestOperationManager * manger = [self createObject];
    [manger POST:[NSString stringWithFormat:@"%@/m/api/authorize/providentfund",BaseAPPUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

#pragma mark - 获取用户授权状态
/**
 获取用户授权状态
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)requestAuthorizeStautsSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/authorize/getAuthorizeStauts", parameters);
    
    [manger GET:[NSString stringWithFormat:@"%@/m/api/authorize/getAuthorizeStauts", BaseAPPUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
}





#pragma mark - 提交主动风控的答案
/**
 提交主动风控的答案
 
 @param qid 主动风控问题的ID
 @param answer 主动风控问题用户填写的答案
 */
+ (void)submitAnswerQuestionWithQid:(NSInteger)qid
                             answer:(NSString *)answer
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:@(qid) forKey:@"qid"];
    [parameters setObject:answer forKey:@"answer"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/answerQuestion", parameters);
    
    [manger POST:[NSString stringWithFormat:@"%@/m/api/applyment/answerQuestion", BaseAPPUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}





#pragma mark - 修改信审资料
/**
 修改信审资料
 
 @param stepName 当前步骤的名称
 @param content 当前步骤全部数据，json的key:value格式
 */
+ (void)editCreditInfoWithStepName:(NSString *)stepName
                           content:(NSString *)content
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:kProductType forKey:@"productType"];
    [parameters setObject:stepName forKey:@"stepName"];
    [parameters setObject:content forKey:@"content"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/editCreditInfo", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/applyment/editCreditInfo",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}



#pragma mark - 直接进件
/**
 直接进件
 @param productType 贷款产品类型
 */
+ (void)directApplymentWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    [parameters setObject:kProductType forKey:@"productType"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/applyment/applyment", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/applyment/applyment",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}




#pragma mark - 身份认证
/**
身份认证

@param realname 姓名
@param idcardno 身份证号码
@param cardno 银行卡号
@param mobile 手机号
*/
+ (void)identitySubmitWithRealname:(NSString *)realname
                          idcardno:(NSString *)idcardno
                            cardno:(NSString *)cardno
                            mobile:(NSString *)mobile
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:5];
    [parameters setObject:kgetCommonData(keyName_token) forKey:@"access_token"];
    [parameters setObject:@"ios" forKey:@"source"];
    
    [parameters setObject:@"realname" forKey:realname];
    [parameters setObject:@"idcardno" forKey:idcardno];
    [parameters setObject:@"cardno" forKey:cardno];
    [parameters setObject:@"mobile" forKey:mobile];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    DLog(@"接口：%@\n请求参数：%@", @"/m/api/active/verifyIdentity", parameters);
    [manger POST:[NSString stringWithFormat:@"%@/m/api/active/verifyIdentity",BaseAPPUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

@end
