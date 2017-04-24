//
//  SDKBaseView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKBaseView : UIView

- (void)checkDataAndHandle:(void(^)(NSMutableDictionary *dic, BOOL res))handle;

@end
