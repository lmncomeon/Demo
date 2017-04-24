//
//  NSObject+SDKAuth.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "NSObject+SDKAuth.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation NSObject (SDKAuth)

// 相册授权
- (BOOL)isAlbumAvailable {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        return false;
    }
    return true;
}


@end
