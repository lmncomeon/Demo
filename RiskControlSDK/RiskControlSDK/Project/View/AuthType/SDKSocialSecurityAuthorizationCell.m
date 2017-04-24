//
//  SDKSocialSecurityAuthorizationCell.m
//  handheldCredit
//
//  Created by 栾美娜 on 16/1/13.
//  Copyright © 2016年 liguiwen. All rights reserved.
//

#import "SDKSocialSecurityAuthorizationCell.h"
#import "SDKProjectHeader.h"
#import "SDKSocialAuthorizationModel.h"

@implementation SDKSocialSecurityAuthorizationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [[UILabel alloc] initWithFrame:resetRectXYWH(18, 0, 250, KcellHeight)];
        _leftLabel.textColor = titleTextColor;
        _leftLabel.font = lightMaxFont(14.0);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_leftLabel];
        
        _rightTextField = [[UITextField alloc] initWithFrame:resetRectXYWH(130, 0, 149, KcellHeight)];
        _rightTextField.font = lightMaxFont(13.0);
        _rightTextField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_rightTextField];
        
        _eyesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat eyesBtnWH = 22;
        _eyesButton.frame = resetRectXYWH(282, (KcellHeight-eyesBtnWH)*0.5, eyesBtnWH, eyesBtnWH);
        [_eyesButton setBackgroundImage:[UIImage imageNamed:kImageBundle @"visible"] forState:UIControlStateNormal];      // 睁眼
        [_eyesButton setBackgroundImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateSelected];  // 闭眼
        [_eyesButton addTarget:self action:@selector(eyesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_eyesButton];
        _eyesButton.hidden = YES;
        
    }
    
    return self;
}

- (void)setModel:(SDKSocialAuthorizationModel *)model {
    _model = model;
    
    _leftLabel.text = model.leftTitle;
    _rightTextField.placeholder = model.rightTip;
    if ([model.leftTitle isEqualToString:@"密码:"])
    {
        _rightTextField.secureTextEntry = YES;
        _rightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _eyesButton.hidden   = NO;
        _eyesButton.selected = YES; // 选中闭眼

    }
    else
    {
        _rightTextField.secureTextEntry = NO;
        _rightTextField.clearButtonMode = UITextFieldViewModeNever;
        _eyesButton.hidden = YES;
    }
}

- (void)eyesButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 选中闭眼
        _rightTextField.secureTextEntry = YES;
    } else {
        _rightTextField.secureTextEntry = NO;
    }
}

@end


