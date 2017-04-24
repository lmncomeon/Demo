//
//  SDKAccumulationFundAuthorizationViewController.m
//  handheldCredit
//
//  Created by joke on 16/1/9.
//  Copyright © 2016年 liguiwen. All rights reserved.
//

#import "SDKAccumulationFundAuthorizationViewController.h"
#import "SDKProjectHeader.h"
#import "SDKLevelTwoPickerView.h"


#import "SDkcustomHUD.h"
#import "SDKBaseWebViewController.h"
#import "SDKCommonService.h"
#import "UIViewController+KeyboardCorver.h"


@interface SDKAccumulationFundAuthorizationViewController ()<UIGestureRecognizerDelegate,SDKLevelTwoPickerViewDelegate>
#pragma mark - AllViews
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityListTextField;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIView *sixView;
@property (weak, nonatomic) IBOutlet UIView *sevenView;
@property (weak, nonatomic) IBOutlet UIView *eightView;

@property (weak, nonatomic) IBOutlet UITextField *onePassWordTextField;

@property (weak, nonatomic) IBOutlet UITextField *twoyonghumingTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoPassWordTextField;

@property (weak, nonatomic) IBOutlet UITextField *threeGongjijinzhanghaoTextField;

@property (weak, nonatomic) IBOutlet UITextField *fourYonghumingTextField;

@property (weak, nonatomic) IBOutlet UITextField *fiveGongjijinzhanghaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *fivePasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *sixGongjijinzhanghaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *sixPhoneNumnerTextField;

@property (weak, nonatomic) IBOutlet UITextField *sevenLianmingkahaoTextField;

@property (weak, nonatomic) IBOutlet UITextField *eightLianmingkahaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *eightPasswordTextField;


#pragma mark autoLayout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonH;

@property (strong, nonatomic) UITapGestureRecognizer *scrollViewTap;
#pragma mark - data
//@property (strong, nonatomic) userInfoDataModel * userInfoDM;
//@property (strong, nonatomic) DefaultSetting * defaultSetting;
@property (nonatomic, strong) SDKLevelTwoPickerView *chinaPickerView;

@property (strong, nonatomic) NSMutableArray *provinceArray;    //城市
@property (strong, nonatomic) NSMutableArray *btnTitleArray;    //可授权类型
@property (nonatomic, assign) BOOL isComplete;

@property (copy, nonatomic) NSString *filed;
@property (assign, nonatomic) NSInteger areaId;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *reserveFunds;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *joinCard;
@property (assign, nonatomic) NSInteger flag;

@property (strong, nonatomic) NSString *secretKey; // 秘钥

@property (nonatomic) BOOL isAgreeDeal;
@property (weak, nonatomic) IBOutlet UIButton *agreeDealButton;
@property (weak, nonatomic) IBOutlet UIButton *pushAgreeDealButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseCipherButton1;
@property (weak, nonatomic) IBOutlet UIButton *chooseCipherButton2;
@property (weak, nonatomic) IBOutlet UIButton *chooseCipherButton5;
@property (weak, nonatomic) IBOutlet UIButton *chooseCipherButton8;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tipItem;

@end

@implementation SDKAccumulationFundAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公积金授权";
//    self.userInfoDM = commonAppDelegate.userInfoDM;
//    self.defaultSetting = commonAppDelegate.defaultSetting;
    self.btnTitleArray = [NSMutableArray array];
    self.isComplete = YES;
    self.isAgreeDeal = YES;
    NSString *titleStr = @"《公积金授权协议》";
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [titleString addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName :UIColorFromRGB(0x42aef7)} range:NSMakeRange(0, [titleStr length])];
    [_pushAgreeDealButton setAttributedTitle:titleString forState:UIControlStateNormal];
    
    [_tipItem setTintColor:UIColorFromRGB(0x42aef7)];
    
    [self AddAllViews];
    [self hiddenAllViewsOfLoginView];

    [self cityData];
    [self addNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self scrollViewAction];
    [_chinaPickerView removeFromSuperview];
}

- (void)AddAllViews {
    self.cellHeight.constant = [self heightWithHeight:44];
    self.scrollViewHeight.constant = [self heightWithHeight:518];
    self.nextButtonH.constant = [self heightWithHeight:40];
    if(kScreenHeight > 480){
        self.nextButtonW.constant = adaptX(260);
    }else{
         self.nextButtonW.constant = 260;
    }
    

    
//    self.nameTextField.text = self.userInfoDM.realName;
//    self.idNumberTextField.text = self.userInfoDM.identify;
    
    self.scrollViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(scrollViewAction)];
    self.scrollViewTap.delegate = self;
    [self.view addGestureRecognizer:self.scrollViewTap];
}

#pragma mark - 跳转提示
- (IBAction)pushToTip:(id)sender {
    SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
    webVC.loadUrlStr = KtipForAccumulation;
    webVC.titleStr = @"提示";
    [self.navigationController pushViewController:webVC animated:true];
}

#pragma mark - 选择城市
- (void)chooseCityAction {
    //防止数据为空
    if (self.provinceArray.count == 0) {
        [self cityData];
    }else{
        if (!_chinaPickerView) {
            _chinaPickerView = [[SDKLevelTwoPickerView alloc] initWithFrame:resetRectXYWH(0, kScreenHeight - 205, 320, 205)];
            _chinaPickerView.delegate = self;
            _chinaPickerView.provinceArray = self.provinceArray;
            [_chinaPickerView setupDataA];
            self.cityListTextField.inputView = _chinaPickerView;
        }
//        [[UIApplication sharedApplication].keyWindow addSubview:_chinaPickerView];
    }
}

#pragma mark - 密码框密文输入切换
- (IBAction)chooseCipherAction:(id)sender {
    switch (self.flag) {
        case 0:
            break;
        case 1:
            self.onePassWordTextField.secureTextEntry = !self.onePassWordTextField.secureTextEntry;
            if (self.onePassWordTextField.secureTextEntry) {
                [_chooseCipherButton1 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
            }else{
                [_chooseCipherButton1 setImage:[UIImage imageNamed:kImageBundle @"visible"] forState:UIControlStateNormal];
            }
            break;
        case 2:
            self.twoPassWordTextField.secureTextEntry = !self.twoPassWordTextField.secureTextEntry;
            if (self.twoPassWordTextField.secureTextEntry) {
                [_chooseCipherButton2 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
            }else{
                [_chooseCipherButton2 setImage:[UIImage imageNamed:kImageBundle @"visible"] forState:UIControlStateNormal];
            }
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            self.fivePasswordTextField.secureTextEntry = !self.fivePasswordTextField.secureTextEntry;
            if (self.fivePasswordTextField.secureTextEntry) {
                [_chooseCipherButton5 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
            }else{
                [_chooseCipherButton5 setImage:[UIImage imageNamed:kImageBundle @"visible"] forState:UIControlStateNormal];
            }
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            self.eightPasswordTextField.secureTextEntry = !self.eightPasswordTextField.secureTextEntry;
            if (self.eightPasswordTextField.secureTextEntry) {
                [_chooseCipherButton8 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
            }else{
                [_chooseCipherButton8 setImage:[UIImage imageNamed:kImageBundle @"visible"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
    
}

#pragma mark 同意协议按钮
- (IBAction)agreeDealAction:(id)sender {
    BOOL temp = !_isAgreeDeal;

    if (temp) {
        [_agreeDealButton setBackgroundImage:[UIImage imageNamed:kImageBundle @"agree_yes"] forState:UIControlStateNormal];
    }else{
        [_agreeDealButton setBackgroundImage:[UIImage imageNamed:kImageBundle @"agree_no"] forState:UIControlStateNormal];
    }
    _isAgreeDeal = temp;
}

#pragma mark 查看协议按钮
- (IBAction)pushDealAction:(id)sender {

    SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
    webVC.titleStr = @"公积金授权协议";
    webVC.loadUrlStr = kAgreeURL;
    [self.navigationController pushViewController:webVC animated:true];
}

#pragma mark - 下一步按钮（提交）
- (IBAction)nextButtonAction:(id)sender {
    if ([self.cityListTextField.text isEqualToString:@""] || (self.cityListTextField.text == nil)) {
        [self showGTTooltipViewWithString:@"请选择缴纳城市"];
    }else if ([self informationIsComplete] == YES) {
        if (!_isAgreeDeal) {
            [self showGTTooltipViewWithString:@"请先同意《公积金授权协议》"];
        }else{
            if ((![self.secretKey isEqualToString:@""]) || (self.secretKey != nil)) {
                [self uploadAuthorizationInformationWithfiled:self.filed
                                                       areaId:self.areaId
                                                     userName:self.userName
                                                 reserveFunds:self.reserveFunds
                                                       mobile:self.mobile
                                                     joinCard:self.joinCard
                                                         flag:self.flag];
            }else{
                
            }
        }
    }
}

#pragma mark - 信息是否填写完整
- (BOOL)informationIsComplete {
    self.isComplete = YES;
    switch (self.flag) {
        case 0:
            
            break;
        case 1:
            self.filed = self.onePassWordTextField.text;
            if ([self.filed isEqualToString:@""] || (self.filed == nil)) {
                [self showGTTooltipViewWithString:@"请输入密码"];
                self.isComplete = NO;
            }
            break;
        case 2:
            self.filed = self.twoPassWordTextField.text;
            self.userName = self.twoyonghumingTextField.text;
            if ([self.filed isEqualToString:@""] || (self.filed == nil)) {
                [self showGTTooltipViewWithString:@"请输入密码"];
                self.isComplete = NO;
            }
            else if ([self.userName isEqualToString:@""] || (self.userName == nil)) {
                [self showGTTooltipViewWithString:@"请输入用户名"];
                self.isComplete = NO;
            }
            break;
        case 3:
            self.reserveFunds = self.threeGongjijinzhanghaoTextField.text;
            if ([self.reserveFunds isEqualToString:@""] || (self.reserveFunds == nil)) {
                [self showGTTooltipViewWithString:@"请输入公积金账号"];
                self.isComplete = NO;
            }
            break;
        case 4:
            self.userName = self.fourYonghumingTextField.text;
            if ([self.userName isEqualToString:@""] || (self.userName == nil)) {
                [self showGTTooltipViewWithString:@"请输入用户名"];
                self.isComplete = NO;
            }
            break;
        case 5:
            self.filed = self.fivePasswordTextField.text;
            self.reserveFunds = self.fiveGongjijinzhanghaoTextField.text;
            if ([self.filed isEqualToString:@""] || (self.filed == nil)) {
                [self showGTTooltipViewWithString:@"请输入密码"];
                self.isComplete = NO;
            }
            else if ([self.reserveFunds isEqualToString:@""] || (self.reserveFunds == nil)) {
                [self showGTTooltipViewWithString:@"请输入公积金账号"];
                self.isComplete = NO;
            }
            break;
        case 6:
            self.reserveFunds = self.sixGongjijinzhanghaoTextField.text;
            self.mobile = self.sixPhoneNumnerTextField.text;
            if ([self.reserveFunds isEqualToString:@""] || (self.reserveFunds == nil)) {
                [self showGTTooltipViewWithString:@"请输入公积金账号"];
                self.isComplete = NO;
            }
            else if ([self.mobile isEqualToString:@""] || (self.mobile == nil)) {
                [self showGTTooltipViewWithString:@"请输入注册公积金手机号"];
                self.isComplete = NO;
            }
            break;
        case 7:
            self.joinCard = self.sevenLianmingkahaoTextField.text;
            if ([self.joinCard isEqualToString:@""] || (self.joinCard == nil)) {
                [self showGTTooltipViewWithString:@"请输入联名卡号"];
                self.isComplete = NO;
            }
            break;
        case 8:
            self.filed = self.eightPasswordTextField.text;
            self.joinCard = self.eightLianmingkahaoTextField.text;
            if ([self.filed isEqualToString:@""] || (self.filed == nil)) {
                [self showGTTooltipViewWithString:@"请输入密码"];
                self.isComplete = NO;
            }
            else if ([self.joinCard isEqualToString:@""] || (self.joinCard == nil)) {
                [self showGTTooltipViewWithString:@"请输入联名卡号"];
                self.isComplete = NO;
            }
            break;
            
        default:
            break;
    }
    return self.isComplete;
}

#pragma mark - 回收键盘
- (void)scrollViewAction {
    [self.view endEditing:YES];
}

- (void)resignTheFistResponder {
    [_nameTextField resignFirstResponder];
    [_idNumberTextField resignFirstResponder];
    [_cityListTextField resignFirstResponder];
    [_onePassWordTextField resignFirstResponder];
    [_twoyonghumingTextField resignFirstResponder];
    [_twoPassWordTextField resignFirstResponder];
    [_threeGongjijinzhanghaoTextField resignFirstResponder];
    [_fourYonghumingTextField resignFirstResponder];
    [_fiveGongjijinzhanghaoTextField resignFirstResponder];
    [_fivePasswordTextField resignFirstResponder];
    [_sixGongjijinzhanghaoTextField resignFirstResponder];
    [_sixPhoneNumnerTextField resignFirstResponder];
    [_sevenLianmingkahaoTextField resignFirstResponder];
    [_eightLianmingkahaoTextField resignFirstResponder];
    [_eightPasswordTextField resignFirstResponder];
}

#pragma mark - textfield 跟随键盘移动
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.cityListTextField]) {
        [self chooseCityAction];
        [self canPerformAction:nil withSender:nil];
//        [self scrollViewAction];
    }else{
        [UIView animateWithDuration:0.25f animations:^{
            UIScrollView *mainScrollView = (UIScrollView *)self.view;
            mainScrollView.contentOffset = CGPointMake(0, 180);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self scrollViewAction];
    [_chinaPickerView removeFromSuperview];
    [UIView animateWithDuration:0.25f animations:^{
        UIScrollView *mainScrollView = (UIScrollView *)self.view;
        mainScrollView.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - showGTTooltipView
- (void)showGTTooltipViewWithString:(NSString *)string
{
    showTip(string);
}

#pragma mark - popOnViewController
- (void)popOnViewController {
    self.view.userInteractionEnabled = NO;
    double delayInSeconds = 3.0; //3秒后执行
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - pushToViewController
- (void)pushToViewController {
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
//        SuccessOfOrderController *pushViewController = [[SuccessOfOrderController alloc] init];
//        pushViewController.btnTitleArray = self.btnTitleArray;
//        [self.navigationController pushViewController:pushViewController animated:YES];
    });
    
}

#pragma mark - 设置默认提示文字
- (NSMutableAttributedString *)setTipTextWithString:(NSString *)string {
    NSMutableAttributedString *placeHolderString = [[NSMutableAttributedString alloc] initWithString:string];
    [placeHolderString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xccd1d6)} range:NSMakeRange(0, [string length])];
    return placeHolderString;
}

#pragma mark - 高度适配
- (CGFloat)heightWithHeight:(CGFloat)sender {
    if(kScreenHeight > 480){
        return adaptY(sender);
    }else{
        return sender;
    }
}

//初始化页面及数据
- (void)hiddenAllViewsOfLoginView {
    
    self.oneView.hidden = YES;
    self.twoView.hidden = YES;
    self.threeView.hidden = YES;
    self.fourView.hidden = YES;
    self.fiveView.hidden = YES;
    self.sixView.hidden = YES;
    self.sevenView.hidden = YES;
    self.eightView.hidden = YES;
    self.loginViewHeight.constant = [self heightWithHeight:136];
    
    _onePassWordTextField.text = @"";
    _twoyonghumingTextField.text = @"";
    _twoPassWordTextField.text = @"";
    _threeGongjijinzhanghaoTextField.text = @"";
    _fourYonghumingTextField.text = @"";
    _fiveGongjijinzhanghaoTextField.text = @"";
    _fivePasswordTextField.text = @"";
    _sixGongjijinzhanghaoTextField.text = @"";
    _sixPhoneNumnerTextField.text = @"";
    _sevenLianmingkahaoTextField.text = @"";
    _eightLianmingkahaoTextField.text = @"";
    _eightPasswordTextField.text = @"";
    
    _onePassWordTextField.secureTextEntry = YES;
    _twoPassWordTextField.secureTextEntry = YES;
    _fivePasswordTextField.secureTextEntry = YES;
    _eightPasswordTextField.secureTextEntry = YES;
    
    [_chooseCipherButton1 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
    [_chooseCipherButton2 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
    [_chooseCipherButton5 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
    [_chooseCipherButton8 setImage:[UIImage imageNamed:kImageBundle @"inVisible"] forState:UIControlStateNormal];
    
    self.filed = @"";
    self.userName = @"";
    self.reserveFunds = @"";
    self.mobile = @"";
    self.joinCard = @"";

}

//根据登陆策略，显示页面，并上传数据
- (void)accordingToSomeViewsWithFlag:(NSInteger)flag {
    [self hiddenAllViewsOfLoginView];
    switch (flag) {
        case 0:
            
            break;
        case 1:
            self.oneView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:185];
            break;
        case 2:
            self.twoView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:229];
            self.scrollViewHeight.constant = [self heightWithHeight:558];
            break;
        case 3:
            self.threeView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:185];
            break;
        case 4:
            self.fourView.hidden = NO;
            
            self.loginViewHeight.constant = [self heightWithHeight:185];
            break;
        case 5:
            self.fiveView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:229];
            self.scrollViewHeight.constant = [self heightWithHeight:558];
            break;
        case 6:
            self.sixView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:229];
            self.scrollViewHeight.constant = [self heightWithHeight:558];
            break;
        case 7:
            self.sevenView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:185];
            break;
        case 8:
            self.eightView.hidden = NO;
            self.loginViewHeight.constant = [self heightWithHeight:229];
            self.scrollViewHeight.constant = [self heightWithHeight:558];
            break;
        
        default:
            break;
    }
}

#pragma mark - LevelTwoPickerViewDelegate
- (void)SDKLevelTwoPickerView:(SDKLevelTwoPickerView *)LevelTwoPickerView cancelBtnDidclicked:(UIButton *)cancelBtn {
    [self scrollViewAction];
    [_chinaPickerView removeFromSuperview];
}

- (void)SDKLevelTwoPickerView:(SDKLevelTwoPickerView *)LevelTwoPickerView determineBtnDidclicked:(UIButton *)determine CityModel:(SDKCityModel *)CityModel title:(NSString *)title {
    [self scrollViewAction];
    self.cityListTextField.text = title;
    self.areaId = CityModel.areaId;
    self.flag = CityModel.flag;
    [_chinaPickerView removeFromSuperview];
    [self accordingToSomeViewsWithFlag:self.flag];
}

#pragma mark - 上传授权信息
- (void)uploadAuthorizationInformationWithfiled:(NSString *)filed
                                         areaId:(NSInteger)areaId
                                       userName:(NSString *)userName
                                   reserveFunds:(NSString *)reserveFunds
                                         mobile:(NSString *)mobile
                                       joinCard:(NSString *)joinCard
                                           flag:(NSInteger)flag
{
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            
            self.hud = [SDKcustomHUD new];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService requestAccumulationFundWithCertificationWithFiled:filed areaId:areaId userName:userName reserveFunds:reserveFunds mobile:mobile joinCard:joinCard flag:flag success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    showTip(@"您的授权信息提交成功");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:true];
                    });
                } else {
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

#pragma mark - 获取支持城市、秘钥
- (void)cityData {
    [SDKNetworkState WithSuccessBlock:^(BOOL status) {
        if (status == true)
        {
            
            self.hud = [SDKcustomHUD new];
            [self.hud showCustomHUDWithView:self.view];
            [SDKCommonService requestAccumulationFundAndSocialSecurityWithType:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self.hud hideCustomHUD];
                [self.provinceArray removeAllObjects];
                NSArray *dataArray = responseObject[@"data"];
                for (NSDictionary *provinceDict in dataArray) {
                    SDKProvinceModel *provinceM = [[SDKProvinceModel alloc] initWithDict:provinceDict];
                    [self.provinceArray addObject:provinceM];
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

- (void)dealloc
{
    [self clearNotificationAndGesture];
}

#pragma mark - 懒加载
- (NSMutableArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

@end
