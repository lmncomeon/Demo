//
//  CommonService.h
//  TestDemo
//
//  Created by 栾美娜 on 2017/4/5.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "network.h"

@interface CommonService : NSObject

#pragma mark - 获取 token
/**
 *  获取平台token
 *
 *  @param success access_token
 *  @param failure error/operation
 */
+ (void)requestAccesstokensuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


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
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




@end


@interface NSString (encrypto)

- (NSString *) md5;


@end
