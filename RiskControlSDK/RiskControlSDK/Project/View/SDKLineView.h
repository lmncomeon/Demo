//
//  SDKLineView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/16.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKLineView : UIView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

+ (instancetype)screenWidthLineWithY:(CGFloat)y;

@end
