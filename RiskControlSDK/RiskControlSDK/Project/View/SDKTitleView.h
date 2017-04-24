//
//  SDKTitleView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame colorLump:(UIColor *)colorLump text:(NSString *)text;

- (void)noneBottomLine;

@end
