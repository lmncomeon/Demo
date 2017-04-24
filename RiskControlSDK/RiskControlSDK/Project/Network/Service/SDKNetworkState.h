//
//  SDKNetworkState.h
//  songShuFinance
//
//  Created by 梁家文 on 15/11/12.
//  Copyright © 2015年 李贵文. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"

typedef void (^successBlock)(BOOL status);
@interface SDKNetworkState : AFNetworkReachabilityManager
+ (void)WithSuccessBlock:(successBlock)success;
@end
