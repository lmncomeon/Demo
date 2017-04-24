//
//  SDKSocialSecurityAuthorizationWithCityCell.m
//  handheldCredit
//
//  Created by 栾美娜 on 16/1/13.
//  Copyright © 2016年 liguiwen. All rights reserved.
//

#import "SDKSocialSecurityAuthorizationWithCityCell.h"
#import "SDKProjectHeader.h"

@implementation SDKSocialSecurityAuthorizationWithCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [[UILabel alloc] initWithFrame:resetRectXYWH(18, 0, 250, KcellHeight)];
        _leftLabel.textColor = titleTextColor;
        _leftLabel.font = lightMaxFont(14.0);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_leftLabel];
        
        _chinaPickerView = [[SDKLevelTwoPickerView alloc] initWithFrame:resetRectXYWH(0, 0, kScreenWidth, 205)];
//        _chinaPickerView.delegate = self;

        _rightTextField = [[UITextField alloc] initWithFrame:resetRectXYWH(130, 0, 172, KcellHeight)];
        _rightTextField.font = lightMaxFont(13.0);
        _rightTextField.textAlignment = NSTextAlignmentRight;
        _rightTextField.tintColor = commonClearColor;
        _rightTextField.placeholder = @"请选择缴纳城市";
        _rightTextField.rightView = ({
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:resetRectXYWH(0, 0, 6.5, 11)];
            imgView.image = [UIImage imageNamed:kImageBundle @"arrow_forward"];
            imgView;
        });
        _rightTextField.rightViewMode = UITextFieldViewModeAlways;
        _rightTextField.delegate = self;
        _rightTextField.inputView = _chinaPickerView;
        _rightTextField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_rightTextField];
    }
    
    return self;
}

-(void)setProvinceArray:(NSMutableArray *)provinceArray{
    _chinaPickerView.provinceArray = provinceArray;
    [_chinaPickerView setupData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
}



@end
