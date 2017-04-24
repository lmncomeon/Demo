//
//  network.m
//  songShuFinance
//
//  Created by 李贵文 on 15/11/5.
//  Copyright © 2015年 李贵文. All rights reserved.
//

#import "network.h"
@interface network ()
@property(strong, nonatomic)AFHTTPRequestOperationManager *_manager;
@property(strong, nonatomic)AFHTTPSessionManager *_sessionManager;
@end
@implementation network
static network * _instance = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    }) ;
    return _instance ;
}
- (instancetype)init{
    if (self = [super init]) {
        self._sessionManager = [AFHTTPSessionManager manager];
        self._manager = [AFHTTPRequestOperationManager manager];
        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        self._manager.securityPolicy = securityPolicy;
        self._sessionManager.securityPolicy = securityPolicy;
    }
    return self;
}
- (id)initWithSessionManager:(AFHTTPSessionManager *)manager{
    self._sessionManager = manager;
    return self;
}
-(id)initWithRequestManager:(AFHTTPRequestOperationManager *)manager{
    self._manager = manager;
    return self;
}
#pragma mark - session GET method
- (NSURLSessionDataTask *)getSessionMethod:(NSString *)URL
                                withParams:(NSDictionary *)params
                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (self._sessionManager == nil) {
        return nil;
    }
    return [self._sessionManager GET:URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (nil != success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (nil != failure) {
            failure(task,error);
        }
    }];
}
#pragma mark - session POST method
- (NSURLSessionDataTask *)postSessionMethod:(NSString *)URL
                                 withParams:(NSDictionary *)params
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject)) success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (self._sessionManager == nil) {
        return nil;
    }
    return [self._sessionManager POST:URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (nil != success) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (nil != failure) {
            failure(task,error);
        }
    }];
}

#pragma mark - operation GET method
- (AFHTTPRequestOperation *)getMethod:(NSString *)URL
                           withParams:(NSDictionary *)params
                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure; {
    if (self._manager == nil) {
        return nil;
    }
    return [self._manager GET:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (nil != success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (nil != operation.response && operation.response.statusCode == 401){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AUTHFAILD" object:nil];
        }
        if (nil != failure) {
            failure(operation,error);
        }
    }];
}
#pragma mark - operation POST method
- (AFHTTPRequestOperation *)postMethod:(NSString *)URL
                            withParams:(NSDictionary *)params
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    if (self._manager == nil) {
        return nil;
    }
    return [self._manager POST:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (nil != success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (nil != operation.response && operation.response.statusCode == 401){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AUTHFAILD" object:nil];
        }
        if (nil != failure) {
            failure(operation,error);
        }
    }];
}
@end
