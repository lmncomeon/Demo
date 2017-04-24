//
//  SDKSocialSecurityAuthorizationCell.h
//  handheldCredit
//
//  Created by 栾美娜 on 16/1/13.
//  Copyright © 2016年 liguiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDKSocialAuthorizationModel;
@interface SDKSocialSecurityAuthorizationCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;
@property (strong, nonatomic) UITextField *rightTextField;
@property (strong, nonatomic) UIButton *eyesButton;

@property (strong, nonatomic) SDKSocialAuthorizationModel *model;

@end
