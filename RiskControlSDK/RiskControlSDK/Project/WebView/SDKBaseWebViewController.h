//
//  SDKBaseWebViewController.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/2.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKProjectHeader.h"
#import "NSObject+SDKAuth.h"
#import "SDKJWAlertView.h"

@interface SDKBaseWebViewController : UIViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSString * loadUrlStr;

@end
