//
//  SDKIdentityAuthenticationViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKIdentityAuthenticationViewController.h"
#import "SDKBankCardAuthenticationViewController.h"

@interface SDKIdentityAuthenticationViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *bankCard;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;

@end

@implementation SDKIdentityAuthenticationViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, adaptY(8), kScreenWidth, adaptY(76))];
        _inputView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollview addSubview:_inputView];
        
        UIView *one = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(38))];
        [_inputView addSubview:one];
        
        SDKLineView *l0 = [SDKLineView screenWidthLineWithY:adaptY(38)];
        [one addSubview:l0];
        
        SDKCustomLabel *nameLab = [SDKCustomLabel setLabelTitle:@"姓名" setLabelFrame:CGRectMake(kDefaultPadding, 0, adaptX(100), adaptY(38)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [one addSubview:nameLab];
        
        SDKMNChineseField *nameField = [[SDKMNChineseField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame), 0, kScreenWidth-CGRectGetMaxX(nameLab.frame)-kDefaultPadding, adaptY(38))];
        nameField.font = kFont(14);
        nameField.textAlignment = 2;
        nameField.placeholder = @"请输入您身份证上的姓名";
        nameField.sendValueBlock = ^ (NSString *backStr) {
            _name = backStr;
            
            _submitBtn.enabled = (_name.length && _idCard.length && _bankCard.length && _phone.length);
        };
        [one addSubview:nameField];
     
        
        UIView *two = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(one.frame), kScreenWidth, adaptY(38))];
        [_inputView addSubview:two];
        
        SDKCustomLabel *IDLab = [SDKCustomLabel setLabelTitle:@"身份证号" setLabelFrame:CGRectMake(kDefaultPadding, 0, adaptX(100), adaptY(38)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [two addSubview:IDLab];
        
        SDKJWTextField *IDField = [[SDKJWTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame), 0, kScreenWidth-CGRectGetMaxX(IDLab.frame)-kDefaultPadding, adaptY(38))];
        IDField.font = kFont(14);
        IDField.textAlignment = 2;
        IDField.placeholder = @"请填写18位身份证号";
        IDField.importBackString = ^ (NSString *backStr) {
            _idCard = backStr;
            
            _submitBtn.enabled = (_name.length && _idCard.length && _bankCard.length && _phone.length);
        };
        [two addSubview:IDField];
        
        UIView *three = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(two.frame), kScreenWidth, adaptY(38))];
        [_inputView addSubview:three];
        
        SDKCustomLabel *bankLab = [SDKCustomLabel setLabelTitle:@"银行卡号" setLabelFrame:CGRectMake(kDefaultPadding, 0, adaptX(100), adaptY(38)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [three addSubview:bankLab];
        
        SDKJWTextField *bankField = [[SDKJWTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bankLab.frame), 0, kScreenWidth-CGRectGetMaxX(IDLab.frame)-kDefaultPadding, adaptY(38))];
        bankField.font = kFont(14);
        bankField.textAlignment = 2;
        bankField.keyboardType = UIKeyboardTypeNumberPad;
        bankField.placeholder = @"请输入储蓄卡卡号";
        bankField.importBackString = ^ (NSString *backStr) {
            _bankCard = backStr;
            
            _submitBtn.enabled = (_name.length && _idCard.length && _bankCard.length && _phone.length);
        };
        [three addSubview:bankField];
        
        
        UIView *four = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(three.frame), kScreenWidth, adaptY(38))];
        [_inputView addSubview:four];
        
        SDKCustomLabel *phoneLab = [SDKCustomLabel setLabelTitle:@"手机号" setLabelFrame:CGRectMake(kDefaultPadding, 0, adaptX(100), adaptY(38)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [four addSubview:phoneLab];
        
        SDKJWTextField *phoneField = [[SDKJWTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLab.frame), 0, kScreenWidth-CGRectGetMaxX(IDLab.frame)-kDefaultPadding, adaptY(38))];
        phoneField.font = kFont(14);
        phoneField.textAlignment = 2;
        phoneField.keyboardType = UIKeyboardTypeNumberPad;
        phoneField.placeholder = @"请输入上方银行卡预留手机号";
        phoneField.importBackString = ^ (NSString *backStr) {
            _phone = backStr;
            
            _submitBtn.enabled = (_name.length && _idCard.length && _bankCard.length && _phone.length);
        };
        [four addSubview:phoneField];
        
        _inputView.height = CGRectGetMaxY(_inputView.subviews.lastObject.frame);
    }
    return _inputView;
}

- (SDKCustomRoundedButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _submitBtn.frame = CGRectMake(kDefaultPadding, CGRectGetMaxY(self.inputView.frame) + adaptY(30), kScreenWidth-2*kDefaultPadding, adaptY(35));
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollview addSubview:_submitBtn];
        _submitBtn.enabled = false; // default
    }
    return _submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavWithTitle:@"信用初审"];
    [self addNotification];
    
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    
    [self submitBtn];
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - 提交
- (void)submitAction:(UIButton *)sender {
    [self.view endEditing:true];

    
    DLog(@"name:%@ id:%@", _name, _idCard);
    
    if (![SDKFormatJudge isValidateIDCardNumber:_idCard]) {
        showTip(@"身份证格式不正确");
    }
    else if (!(_bankCard.length >= 16 && _bankCard.length <= 19)) {
        showTip(@"银行卡号格式不正确");
    }
    else if (![SDKFormatJudge isValidateMobile:_phone]) {
        showTip(@"手机号格式不正确");
    }
    else {
        [SDKNetworkState WithSuccessBlock:^(BOOL status){
            if (status == true)
            {
                self.hud = [SDKcustomHUD new];
                [self.hud showCustomHUDWithView:self.view];
                
                [SDKCommonService identitySubmitWithRealname:_name idcardno:_idCard cardno:_bankCard mobile:_phone success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([responseObject[@"retcode"] integerValue] == 200) {
                        [self.hud hideCustomHUD];
                        
                        [self dismissViewControllerAnimated:true completion:nil];
                    }else{
                        showTip(responseObject[@"msg"]);
                        [self.hud hideCustomHUD];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self.hud hideCustomHUD];
                    [self errorDispose:[[operation response] statusCode] judgeMent:nil];
                }];
            }
            else
            {
                [self errorRemind:nil];
            }
        }];
    }
    
}

@end
