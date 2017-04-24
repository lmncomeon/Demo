//
//  SDKPhoneAuthenticationViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKPhoneAuthenticationViewController.h"
#import "SDKIdentityAuthenticationViewController.h"

@interface SDKPhoneAuthenticationViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, strong) SDKCustomRoundedButton *codeBtn;
@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;

@end

@implementation SDKPhoneAuthenticationViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(65))];
        _progressView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollview addSubview:_progressView];
        
        SDKLineView *grayLine = [[SDKLineView alloc] initWithFrame:CGRectMake(adaptX(44), adaptY(22), kScreenWidth-2*adaptX(44), 0.5f) color:cuttingLineColor];
        [_progressView addSubview:grayLine];
        
        SDKLineView *blueLine = [[SDKLineView alloc] initWithFrame:CGRectMake(adaptX(44), adaptY(22), (kScreenWidth-2*adaptX(44))/4, 0.5f) color:kBtnNormalBlue];
        [_progressView addSubview:blueLine];
        
        NSArray *iconArr = @[@"phone_blue", @"identity_gray", @"card_gray"];
        NSArray *textArr = @[@"手机认证", @"身份认证", @"银行卡认证"];
        
        CGFloat iconWH = adaptX(22);
        CGFloat margin = adaptX(43);
        CGFloat padding = (kScreenWidth-2*margin-iconArr.count*iconWH)/(iconArr.count-1);
        
        for (int i = 0; i < iconArr.count; i++) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(margin+i*(iconWH+padding), adaptY(10), iconWH, iconWH)];
            icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"RiskControlBundle.bundle/%@", iconArr[i]]];
            [_progressView addSubview:icon];
            
            SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:textArr[i] setLabelFrame:CGRectMake(i*(kScreenWidth/textArr.count), CGRectGetMaxY(icon.frame)+adaptY(5), kScreenWidth/textArr.count, adaptY(20)) setLabelColor:commonGrayColor setLabelFont:kFont(12) setAlignment:1];
            [_progressView addSubview:lab];
        }

    }
    return _progressView;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.progressView.frame) + adaptY(8), kScreenWidth, adaptY(76))];
        _inputView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollview addSubview:_inputView];
        
        UIView *one = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(38))];
        [_inputView addSubview:one];
        
        SDKLineView *l0 = [SDKLineView screenWidthLineWithY:adaptY(38)];
        [one addSubview:l0];
        
        SDKJWTextField *phoneField = [[SDKJWTextField alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth, adaptY(38))];
        phoneField.font = kFont(14);
        phoneField.keyboardType = UIKeyboardTypePhonePad;
        phoneField.placeholder = @"请输入常用手机号";
        phoneField.importBackString = ^(NSString * backStr) {
            _phoneNum = backStr;
            
            _codeBtn.enabled = (_phoneNum.length && [_codeBtn.titleLabel.text isEqualToString:@"获取验证码"]);
            _submitBtn.enabled = (_phoneNum.length && _verifyCode.length);
            
        };
        [one addSubview:phoneField];
        
        
        
        UIView *two = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(one.frame), kScreenWidth, adaptY(38))];
        [_inputView addSubview:two];
        
        SDKJWTextField *codeField = [[SDKJWTextField alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth*0.5, adaptY(38))];
        codeField.font = kFont(14);
        codeField.keyboardType = UIKeyboardTypeNumberPad;
        codeField.placeholder = @"请输入验证码";
        codeField.importBackString = ^(NSString * backStr) {
            _verifyCode = backStr;
            
            _submitBtn.enabled = (_phoneNum.length && _verifyCode.length);
        };
        [two addSubview:codeField];
        
        _codeBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"获取验证码" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _codeBtn.frame = CGRectMake(kScreenWidth-kDefaultPadding-adaptX(80), adaptY(5.5), adaptX(80), adaptY(27));
        [_codeBtn addTarget:self action:@selector(codeAction:) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.enabled = false;
        [two addSubview:_codeBtn];
        
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
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    
    [self addNotification];
    
    [self submitBtn];
 
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - 获取验证码
- (void)codeAction:(UIButton *)sender {
    if (![SDKFormatJudge isValidateMobile:_phoneNum]) {
        showTip(@"手机号格式不正确");
    } else {
        
        [SDKNetworkState WithSuccessBlock:^(BOOL status){
            if (status == true)
            {
                self.hud = [SDKcustomHUD new];
                [self.hud showCustomHUDWithView:self.view];
                
                [SDKCommonService requestVerifyCodeWithMobile:_phoneNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([responseObject[@"retcode"] integerValue] == 200) {
                        showTip(@"验证码发送成功");
                        [self startTime:sender];
                        
                        [self.hud hideCustomHUD];
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

- (void)startTime:(UIButton *)sender {
    sender.enabled = false;
    
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.enabled = true;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sender setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

#pragma mark - 提交
- (void)submitAction:(UIButton *)sender {
//    [self.navigationController pushViewController:[SDKIdentityAuthenticationViewController new] animated:true];
    [self.view endEditing:true];
    
    if (![SDKFormatJudge isValidateMobile:_phoneNum]) {
        showTip(@"手机号格式不正确");
    } else {
        
        [SDKNetworkState WithSuccessBlock:^(BOOL status){
            if (status == true)
            {
                self.hud = [SDKcustomHUD new];
                [self.hud showCustomHUDWithView:self.view];
                
                [SDKCommonService activeStepOneSubmitWithValidatecode:_verifyCode mobile:_phoneNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([responseObject[@"retcode"] integerValue] == 200) {
                        [self.hud hideCustomHUD];
                        
                        [self.navigationController pushViewController:[SDKIdentityAuthenticationViewController new] animated:true];
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

#pragma mamrk - dealloc
- (void)dealloc {
    [self clearNotificationAndGesture];
}

@end
