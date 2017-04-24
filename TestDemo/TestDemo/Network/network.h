//
//  network.h
//  songShuFinance
//
//  Created by 李贵文 on 15/11/5.
//  Copyright © 2015年 李贵文. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface network : NSObject
+ (instancetype)shareInstance;
- (id)initWithSessionManager:(AFHTTPSessionManager *)manager;
- (id)initWithRequestManager:(AFHTTPRequestOperationManager *)manager;
- (AFHTTPRequestOperation *)getMethod:(NSString *)URL
                           withParams:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)postMethod:(NSString *)URL
                            withParams:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (NSURLSessionDataTask *)getSessionMethod:(NSString *)URL
                                withParams:(NSDictionary *)params
                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)postSessionMethod:(NSString *)URL
                                 withParams:(NSDictionary *)params
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end