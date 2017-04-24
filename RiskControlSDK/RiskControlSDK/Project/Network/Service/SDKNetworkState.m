//
//  SDKNetworkState.m
//  songShuFinance
//
//  Created by 梁家文 on 15/11/12.
//  Copyright © 2015年 李贵文. All rights reserved.
//

#import "SDKNetworkState.h"
@implementation SDKNetworkState
+ (void)WithSuccessBlock:(successBlock)success {
    [[self sharedManager] startMonitoring];
    [[self sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0) {
            success(false);
        }else if (status == 1){
            success(true);
        }else if (status == 2){
            success(true);
        }
    }];
}
@end
