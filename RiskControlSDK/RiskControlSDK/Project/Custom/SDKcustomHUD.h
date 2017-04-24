//
//  SDKcustomHUD.h
//  handheldCredit
//
//  Created by devair on 15/8/11.
//  Copyright (c) 2015年 liguiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKcustomHUD : UIView
- (void)showCustomHUDWithView:(UIView *)view;
- (void)hideCustomHUD;


- (void)showBlankViewInView:(UIView *)view;
- (void)hideBlankView;

@end
