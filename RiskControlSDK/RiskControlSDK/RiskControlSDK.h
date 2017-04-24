//
//  RiskControlSDK.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskControlSDK : NSObject

@property (nonatomic, copy) void (^callBlock)(id responseObject); // 返回所有需要数据
@property (nonatomic, copy) dispatch_block_t tokenInvalid;        // token失效


// ---------------------------- 提交信息 ----------------------------
/**
 @param token
 @param productType 贷款产品类型
 */
- (void)presentSDKWithToken:(NSString *)token
                 productType:(NSString *)productType;




// ---------------------------- 查看信息 ----------------------------
/**
 @param token
 @param productType 贷款产品类型
 */
- (void)presnetSDKViewInformationWithToken:(NSString *)token
                                productType:(NSString *)productType;



// ---------------------------- 查看所有授权状态 ----------------------------
- (void)presentSDKAuthWithToken:(NSString *)token
                    productType:(NSString *)productType;

// 关闭
- (void)closeMethod;

@end
