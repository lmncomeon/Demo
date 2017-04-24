//
//  SDKCommonService.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/16.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKnetwork.h"

@interface SDKCommonService : NSObject

#pragma mark - 获取 token
/**
 *  获取平台token
 *
 *  @param success access_token
 *  @param failure error/operation
 */
+ (void)requestAccesstokenWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - 检查用户当前状态
/**
 检查用户当前状态
 */
+ (void)checkUserStatusSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 获取短信验证码
/**
 获取短信验证码

 @param type 0短信 1语音
 @param mobile 手机号
 */
+ (void)requestVerifyCodeWithMobile:(NSString *)mobile
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - 激活第一步提交
/**
 激活第一步提交

 @param validatecode 验证码
 @param mobile 手机号码
 */
+ (void)activeStepOneSubmitWithValidatecode:(NSString *)validatecode
                                     mobile:(NSString *)mobile
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 激活第二步提交
/**
 激活第二步提交
 @param realname 姓名
 @param idcardno 身份证号码
 */
+ (void)activeStepTwoSubmitWithRealname:(NSString *)realname
                               idcardno:(NSString *)idcardno
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - 激活第三步提交
/**
 激活第三步提交
 @param bankcard Array[string]
 */
+ (void)activeStepThreeSubmitWithBankcard:(NSString *)bankcard
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - 获取资料提交步骤
/**
 获取资料提交步骤
 @param productType 贷款产品类型
 */
+ (void)infomationGetStepsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 文件上传
/**
 文件上传

 @param type image video audio
 @param file
 */
+ (void)uplodFileWithType:(NSString *)type
                    file:(void (^)(id <AFMultipartFormData> formData))file
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



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
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 获取省市区
+ (void)requestProvinceCityZoneSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;





#pragma mark - 信审资料主页列表
/**
 信审资料主页列表
 */
+ (void)requestCreditListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;






#pragma mark - 获取某项资料详情
/**
 获取某项资料详情
 @param type [身份认证、银行卡信息、基本信息、职业信息、联系人信息]
 */
+ (void)requestCreditInfoWithType:(NSString *)type
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




#pragma mark - 提交其他资料
/**
 提交其他资料
 @param type contact
 @param content
 */
+ (void)submitExtraInfoWithContent:(NSString *)content
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 获取公积金/社保 对应的城市列表
/**
 *  获取公积金/社保 对应的城市列表
 *
 *  @param type         1 公积金城市 2 社保城市
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+ (void)requestAccumulationFundAndSocialSecurityWithType:(NSInteger)type
                                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




#pragma mark - 社保 认证接口
/**
 *  社保 认证接口
 *
 *  @param filed        密码
 *  @param areaId       城市序列id
 *  @param ownerNum     个人编号
 *  @param sbCode       社保编号
 *  @param sbNum        社保卡号
 *  @param flag         登陆策略
 *  @param userName     用户名
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+ (void)requestSocialSecurityWithCertificationWithFiled:(NSString *)filed
                                                      areaId:(NSInteger)areaId
                                                    ownerNum:(NSString *)ownerNum
                                                      sbCode:(NSString *)sbCode
                                                       sbNum:(NSString *)sbNum
                                                        flag:(NSInteger)flag
                                                    userName:(NSString *)userName
                                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 公积金 认证接口
/**
 *  公积金 认证接口
 *
 *  @param access_token <#access_token description#>
 *  @param filed        密码
 *  @param areaId       城市序列id
 *  @param userName     用户名
 *  @param reserveFunds 公积金账号
 *  @param mobile       注册公积金手机号
 *  @param joinCard     联名卡
 *  @param flag         登陆策略
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+ (void)requestAccumulationFundWithCertificationWithFiled:(NSString *)filed
                                                        areaId:(NSInteger)areaId
                                                      userName:(NSString *)userName
                                                  reserveFunds:(NSString *)reserveFunds
                                                        mobile:(NSString *)mobile
                                                      joinCard:(NSString *)joinCard
                                                          flag:(NSInteger)flag
                                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 获取用户授权状态
/**
 获取用户授权状态
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)requestAuthorizeStautsSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;





#pragma mark - 提交主动风控的答案
/**
 提交主动风控的答案

 @param qid 主动风控问题的ID
 @param answer 主动风控问题用户填写的答案
 */
+ (void)submitAnswerQuestionWithQid:(NSInteger)qid
                             answer:(NSString *)answer
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;





#pragma mark - 修改信审资料
/**
 修改信审资料

 @param stepName 当前步骤的名称
 @param content 当前步骤全部数据，json的key:value格式
 */
+ (void)editCreditInfoWithStepName:(NSString *)stepName
                           content:(NSString *)content
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;





#pragma mark - 直接进件
/**
 直接进件
 @param productType 贷款产品类型
 */
+ (void)directApplymentWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



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
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

