//
//  SDKSocialSecurityAuthorizationWithCityCell.h
//  handheldCredit
//
//  Created by 栾美娜 on 16/1/13.
//  Copyright © 2016年 liguiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKLevelTwoPickerView.h"

@interface SDKSocialSecurityAuthorizationWithCityCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *leftLabel;
@property (strong, nonatomic) UITextField *rightTextField;
@property (nonatomic, strong) SDKLevelTwoPickerView *chinaPickerView;
@property (nonatomic, strong) NSMutableArray *provinceArray;

@end
