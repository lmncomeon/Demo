//
//  SDKAuthSheBaoViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/3.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKAuthSheBaoViewController.h"
#import "SDKSocialAuthorizationModel.h"
#import "SDKSocialSecurityAuthorizationWithCityCell.h"
#import "SDKSocialSecurityAuthorizationCell.h"
#import "SDKBaseWebViewController.h"

@interface SDKAuthSheBaoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SDKLevelTwoPickerViewDelegate>

@property (nonatomic, strong) UITableView *mainTableview;

@property (assign, nonatomic) NSInteger flag; // 记录
@property (assign, nonatomic) NSInteger areaId;
@property (copy, nonatomic)  NSString *cityTitle;

@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cellsArray;

@property (copy, nonatomic) NSString *secretKey; // 秘钥
@property (strong, nonatomic) UITapGestureRecognizer *scrollViewTap;

@property (nonatomic, weak) UIButton *submitBtn;
@property (strong, nonatomic) UIButton * upAgreementButton;//同意三方借款协议
@property (strong, nonatomic) UIButton * theThreePartiesLoanAgreementButton;//三方借款协议

@end

static NSString *const Social_Identifier     = @"SocialSecurityAuthorizationCell";
static NSString *const SocialCity_Identifier = @"SocialSecurityAuthorizationWithCityCell";

@implementation SDKAuthSheBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"社保授权"];
    [self setUpUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self cityData];
}

- (void)setUpUI {
    _mainTableview = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _mainTableview.dataSource = self;
    _mainTableview.delegate   = self;
    
    [self.view addSubview:_mainTableview];
    
    [_mainTableview registerClass:[SDKSocialSecurityAuthorizationCell class] forCellReuseIdentifier:Social_Identifier];
    [_mainTableview registerClass:[SDKSocialSecurityAuthorizationWithCityCell class] forCellReuseIdentifier:SocialCity_Identifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:kImageBundle @"instalment_tip"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(moreAction)];
    
    [self addNotification];
    
    // 创建数据源
    for (int i = 0; i < 5; i++) {
        SDKSocialAuthorizationModel *model = [SDKSocialAuthorizationModel new];
        switch (i) {
            case 0:{
                model.leftTitle = @"密码:";
                model.rightTip  = @"请输入密码";
            } break;
            case 1:{
                model.leftTitle = @"用户名";
                model.rightTip  = @"请输入您的用户名";
            } break;
            case 2:{
                model.leftTitle = @"社保编码";
                model.rightTip  = @"请输入您的社保编码";
            } break;
            case 3:{
                model.leftTitle = @"社保卡号";
                model.rightTip  = @"请输入您的社保卡号";
            } break;
            case 4:{
                model.leftTitle = @"个人编码";
                model.rightTip  = @"请输入您的个人编号";
            } break;
            default:
                break;
        }
        
        [self.cellsArray addObject:model];
    }
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
                
                [self.mainTableview reloadData];
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

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.flag)
    {
        if (self.flag == 0)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.flag)
    {
        if (section == 0)
        {
            return 3;
        }
        else if (section == 1)
        {
            switch (self.flag) {
                case 1:
                case 5:{
                    return 1;
                } break;
                case 2:
                case 3:
                case 4:{
                    return 2;
                } break;
                default:
                    break;
            }
        }
        
    }
    else
    {
        return 3;
    }
    
    return 0;
}
#pragma mark - levelPickerView delegate
- (void)SDKLevelTwoPickerView:(SDKLevelTwoPickerView *)LevelTwoPickerView cancelBtnDidclicked:(UIButton *)cancelBtn{
    
    [self.view endEditing:YES];
}

- (void)SDKLevelTwoPickerView:(SDKLevelTwoPickerView *)LevelTwoPickerView determineBtnDidclicked:(UIButton *)determine CityModel:(SDKCityModel *)CityModel title:(NSString *)title {
    self.flag   = CityModel.flag;
    self.areaId = CityModel.areaId;
    self.cityTitle = title;
    
    [_mainTableview reloadData];
    [self.view endEditing:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:{
                SDKSocialSecurityAuthorizationCell *cell = [tableView dequeueReusableCellWithIdentifier:Social_Identifier forIndexPath:indexPath];
                cell.leftLabel.text = @"姓名:";
                cell.rightTextField.userInteractionEnabled = NO;
                cell.rightTextField.placeholder = @"请输入姓名";
//                cell.rightTextField.text = self.userInfoDM.realName;
                cell.rightTextField.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } break;
            case 1:{
                SDKSocialSecurityAuthorizationCell *cell = [tableView dequeueReusableCellWithIdentifier:Social_Identifier forIndexPath:indexPath];
                cell.leftLabel.text = @"身份证号:";
                cell.rightTextField.userInteractionEnabled = NO;
                cell.rightTextField.placeholder = @"请输入身份证号";
//                cell.rightTextField.text = self.userInfoDM.identify;
                cell.rightTextField.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } break;
            case 2:
            {
                SDKSocialSecurityAuthorizationWithCityCell *cell = [tableView dequeueReusableCellWithIdentifier:SocialCity_Identifier forIndexPath:indexPath];
                cell.leftLabel.text = @"缴纳城市:";
                cell.chinaPickerView.delegate = self;
                if (self.cityTitle) {
                    cell.rightTextField.text = self.cityTitle;
                }
                //                cell.delegate = self;
                if (self.provinceArray.count != 0) {
                    cell.provinceArray = self.provinceArray;
                    
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
                
            default:
                break;
        }
        
    }
    if (self.flag) {
        if (indexPath.section == 1)
        {
            SDKSocialSecurityAuthorizationCell *cell = [tableView dequeueReusableCellWithIdentifier:Social_Identifier forIndexPath:indexPath];
            if (indexPath.row == 0)
            {
                cell.model = self.cellsArray[self.flag-1];
            }
            else if (indexPath.row == 1)
            {
                cell.model = self.cellsArray[0];
            }
            
            cell.rightTextField.delegate = self;
            cell.rightTextField.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }
    
    return nil;
}

#pragma mark - tableView delegate
#pragma mark - cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return adaptY(KcellHeight);
}
#pragma mark header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return adaptY(125);
    }
    else
    {
        return 0.1f;
    }
}

#pragma mark headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        UIView *header = [[UIView alloc] initWithFrame:resetRectXYWH(0, 0, 320, 125)];
        UIImageView *headerImg = [[UIImageView alloc] initWithFrame:resetRectXYWH(0, 0, 320, 120)];
        headerImg.image = [UIImage imageNamed:kImageBundle @"operatorAuthorization_sb"];
        [header addSubview:headerImg];
        
        return header;
    }
    else
    {
        return nil;
    }
    
}

#pragma mark footer height
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.flag)
    {
        if (section == 0)
        {
            adaptY(5);
        }
        else
        {
            return adaptY(200);
        }
    }
    else
    {
        
        return adaptY(200);
        
    }
    return 0;
}

#pragma mark footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.flag)
    {
        if (section == 0)
        {
            return nil;
        }
        else
        {
            UIView *footer = [self footerWithSubmitButton];
            return footer;
        }
        
    }
    else
    {
        UIView *footer = [self footerWithSubmitButton];
        return footer;
    }
}

#pragma mark － 提交
- (void)submitAction:(UIButton *)sender {
    //    self.areaId // 城市序列id
    NSString *password = @"";
    NSString *userName = @"";
    NSString *socialCode = @"";
    NSString *socialCard = @"";
    NSString *personalNumer = @"";
    NSString *area = @"";
    // 赋值
    SDKSocialSecurityAuthorizationWithCityCell *cityCell = [_mainTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    area = cityCell.rightTextField.text; // 选择城市
    if (self.flag)
    {
        SDKSocialSecurityAuthorizationCell *oneCell = [_mainTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        switch (self.flag) {
            case 1:
                password = oneCell.rightTextField.text;
                break;
            case 2:
                userName = oneCell.rightTextField.text;
                break;
            case 3:
                socialCode = oneCell.rightTextField.text;
                break;
            case 4:
                socialCard = oneCell.rightTextField.text;
                break;
            case 5:
                personalNumer = oneCell.rightTextField.text;
                break;
            default:
                break;
        }
        
        if (self.flag == 2 || self.flag == 3 || self.flag == 4)
        {
            SDKSocialSecurityAuthorizationCell *twoCell = [_mainTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            password = twoCell.rightTextField.text;
        }
    }
    
    DLog(@"password %@ userName %@ socialCode %@ socialCard %@ personalNumer %@ area %@", password, userName, socialCode, socialCard, personalNumer, area);
    // 判断是否为空
    if (area == nil || [area isEqualToString:@""])
    {
        [self showGTTooltipViewWithString:@"请选择缴纳城市"];
    }
    else
    {
        switch (self.flag) {
            case 0:{
                if (_upAgreementButton.selected == NO)
                {
                    [self showGTTooltipViewWithString:@"请同意《社保授权协议》"];
                }
                else
                {
                    [self sendSocialSecurityWithfiled:password areaId:self.areaId ownerNum:personalNumer sbCode:socialCode sbNum:socialCard flag:self.flag userName:userName];
                }
            } break;
            case 1:{
                if (password == nil || [password isEqualToString:@""])
                {
                    [self showGTTooltipViewWithString:@"请输入密码"];
                }
                else if (_upAgreementButton.selected == NO)
                {
                    [self showGTTooltipViewWithString:@"请同意《社保授权协议》"];
                }
                else
                {
                    [self sendSocialSecurityWithfiled:password areaId:self.areaId ownerNum:personalNumer sbCode:socialCode sbNum:socialCard flag:self.flag userName:userName];
                    
                }
            } break;
            case 2:{
                if (userName == nil || [userName isEqualToString:@""]) {
                    [self showGTTooltipViewWithString:@"请输入您的用户名"];
                }
                else if (password == nil || [password isEqualToString:@""])
                {
                    [self showGTTooltipViewWithString:@"请输入您的密码"];
                }
                else if (_upAgreementButton.selected == NO)
                {
                    [self showGTTooltipViewWithString:@"请同意《社保授权协议》"];
                }
                else
                {
                    [self sendSocialSecurityWithfiled:password areaId:self.areaId ownerNum:personalNumer sbCode:socialCode sbNum:socialCard flag:self.flag userName:userName];
                }
            } break;
            case 3:{
                if (socialCode == nil || [socialCode isEqualToString:@""]) {
                    [self showGTTooltipViewWithString:@"请输入您的社保编码"];
                }
                else if (password == nil || [password isEqualToString:@""])
                {
                    [self showGTTooltipViewWithString:@"请输入您的密码"];
                }
                else if (_upAgreementButton.selected == NO)
                {
                    [self showGTTooltipViewWithString:@"请同意《社保授权协议》"];
                }
                else
                {
                    [self sendSocialSecurityWithfiled:password areaId:self.areaId ownerNum:personalNumer sbCode:socialCode sbNum:socialCard flag:self.flag userName:userName];
                }
            } break;
            case 4:{
                if (socialCard == nil || [socialCard isEqualToString:@""]) {
                    [self showGTTooltipViewWithString:@"请输入您的社保卡号"];
                }
                else if (password == nil || [password isEqualToString:@""])
                {
                    [self showGTTooltipViewWithString:@"请输入您的密码"];
                }
                else if (_upAgreementButton.selected == NO)
                {
                    [self showGTTooltipViewWithString:@"请同意《社保授权协议》"];
                }
                else
                {
                    [self sendSocialSecurityWithfiled:password areaId:self.areaId ownerNum:personalNumer sbCode:socialCode sbNum:socialCard flag:self.flag userName:userName];

                }
            } break;
            case 5:{
                if (personalNumer == nil || [personalNumer isEqualToString:@""]) {
                    [self showGTTooltipViewWithString:@"请输入您的个人编号"];
                }
                else if (_upAgreementButton.selected == NO)
                {
                    [self showGTTooltipViewWithString:@"请同意《社保授权协议》"];
                }
                else
                {
                    [self sendSocialSecurityWithfiled:password areaId:self.areaId ownerNum:personalNumer sbCode:socialCode sbNum:socialCard flag:self.flag userName:userName];
                }
            } break;
            default:
                break;
        }
    }
    
}

/** footer */
- (UIView *)footerWithSubmitButton {
    UIView *footer = [[UIView alloc] initWithFrame:resetRectXYWH(0, 0, 320, 260)];
    [self.mainTableview setContentSize:CGSizeMake(0, self.mainTableview.frame.size.height + 72)];
    
    if (!_upAgreementButton) {
        _upAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _upAgreementButton.frame = resetRectXYWH(18, 8, 22, 22);
    [_upAgreementButton setBackgroundImage:[UIImage imageNamed:kImageBundle @"instalment-tongyi"] forState:UIControlStateSelected];
    [_upAgreementButton setBackgroundImage:[UIImage imageNamed:kImageBundle @"instalment-tongyino"] forState:UIControlStateNormal];
    _upAgreementButton.selected = YES;
    [_upAgreementButton addTarget:self action:@selector(upAgreemeneMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_upAgreementButton];
    
    _theThreePartiesLoanAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _theThreePartiesLoanAgreementButton.frame = resetRectXYWH(48, 8, 12*20, 22);
    _theThreePartiesLoanAgreementButton.titleLabel.font = lightMaxFont(12.0);
    _theThreePartiesLoanAgreementButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *titleStr = @"同意《社保授权协议》";
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [titleString addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleNone], NSForegroundColorAttributeName :UIColorFromRGB(0x8297a9)} range:NSMakeRange(0, 2)];
    [titleString addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName :UIColorFromRGB(0x42aef7)} range:NSMakeRange(2, [titleStr length] - 2)];
    [_theThreePartiesLoanAgreementButton setAttributedTitle:titleString forState:UIControlStateNormal];
    [_theThreePartiesLoanAgreementButton addTarget:self action:@selector(theThreePartiesLoanAgreementMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_theThreePartiesLoanAgreementButton];
    
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = resetRectXYWH(30, 42, footer.frame.size.width - 60, 40);
    submit.backgroundColor = commonBlueColor;
    submit.layer.cornerRadius  = 5;
    submit.layer.masksToBounds = YES;
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setTitleColor:commonWhiteColor forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:submit];
    self.submitBtn = submit;
    
    UILabel *tipMessage = [[UILabel alloc] initWithFrame:resetRectXYWH(30, 92, footer.frame.size.width - 60, 30)];
    tipMessage.text = @"温馨提示";
    tipMessage.font = kFont(14);
    tipMessage.textColor = [UIColor grayColor];
    UILabel *tipcontent = [[UILabel alloc] initWithFrame:resetRectXYWH(30, 128, footer.frame.size.width - 60, 80)];
    tipcontent.numberOfLines = 0;
    tipcontent.textColor = [UIColor grayColor];
    tipcontent.text = @"（1）松鼠贷承诺不会保存您的授权账户及密码\n（2）授权信息仅用于信用评估，不会泄漏给他人或第三方机构";
    tipcontent.font = kFont(14);
    [footer addSubview:tipcontent];
    [footer addSubview:tipMessage];
    return footer;
}

#pragma mark - 懒加载
- (NSMutableArray *)provinceArray {
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (NSMutableArray *)cellsArray {
    if (!_cellsArray) {
        _cellsArray = [NSMutableArray array];
    }
    return _cellsArray;
}


#pragma mark - 传数据
/**
 *
 *  @param filed        密码
 *  @param areaId       城市序列id
 *  @param ownerNum     个人编号
 *  @param sbCode       社保编号
 *  @param sbNum        社保卡号
 *  @param flag         登陆策略
 *  @param userName     用户名
 */
- (void)sendSocialSecurityWithfiled:(NSString *)filed
                                    areaId:(NSInteger)areaId
                                  ownerNum:(NSString *)ownerNum
                                    sbCode:(NSString *)sbCode
                                     sbNum:(NSString *)sbNum
                                      flag:(NSInteger)flag
                                  userName:(NSString *)userName {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            
            self.hud = [SDKcustomHUD new];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService requestSocialSecurityWithCertificationWithFiled:filed areaId:areaId ownerNum:ownerNum sbCode:sbCode sbNum:sbNum flag:flag userName:userName success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
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

#pragma mark - 提示文字几秒消失
- (void)showGTTooltipViewWithString:(NSString *)string
{
    showTip(string);
}


#pragma mark - more
- (void)moreAction {
    SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
    webVC.loadUrlStr = KtipForSocialSecurity;
    webVC.titleStr = @"提示";
    [self.navigationController pushViewController:webVC animated:true];
}

#pragma mark - 跳转到授权成功页面
- (void)pushToViewController:(NSMutableArray *)titltesArray {
//    self.view.userInteractionEnabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
//        SuccessOfOrderController *pushViewController = [[SuccessOfOrderController alloc] init];
//        pushViewController.btnTitleArray = titltesArray;
//        [self.navigationController pushViewController:pushViewController animated:YES];
//    });
    
}

- (void)dealloc
{
    [self clearNotificationAndGesture];
}

#pragma mark - 协议同意按钮
- (void)upAgreemeneMethod:(UIButton *)button{
    button.selected = !button.selected;
}

#pragma mark - 协议按钮
- (void)theThreePartiesLoanAgreementMethod:(UIButton *)button {
    SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
    webVC.titleStr = @"社保授权协议";
    webVC.loadUrlStr = kAgreeURL;
    [self.navigationController pushViewController:webVC animated:true];
}

@end
