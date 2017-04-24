//
//  SDKProgressView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKProgressView : UIScrollView

// current 1
- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count current:(NSInteger)current;

@end
