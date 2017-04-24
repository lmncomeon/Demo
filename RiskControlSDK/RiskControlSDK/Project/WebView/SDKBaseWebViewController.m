//
//  SDKBaseWebViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/2.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseWebViewController.h"
#import "SDKcustomHUD.h"
#import "SDKCustomRoundedButton.h"
#import "SDKIdentityAuthenticationViewController.h"

@interface SDKBaseWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) SDKcustomHUD *blankHUD;

@property (nonatomic, strong) SDKCustomRoundedButton *agreenBtn;

@end

@implementation SDKBaseWebViewController

- (SDKCustomRoundedButton *)agreenBtn {
    if (!_agreenBtn) {
        _agreenBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"我同意并继续使用" font:kFont(14) titleColor:commonWhiteColor backgroundColor:commonBlueColor];
        _agreenBtn.frame = CGRectMake(kDefaultPadding, kScreenHeight-64-adaptY(30)-kDefaultPadding, kScreenWidth-2*kDefaultPadding, adaptY(30));
        [_agreenBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreenBtn];
    }
    return _agreenBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@", self.loadUrlStr, kgetCommonData(keyName_token)]]]];
 
    // 加载圈
    self.blankHUD = [SDKcustomHUD new];
    [self.blankHUD showBlankViewInView:self.view];
    
    // 重写返回
    if ([self.loadUrlStr containsString:policyAgreement]) {
        self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    }
}

#pragma mark - web delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 隐藏导航条
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('mx-title-bar')[0].parentNode.style.display = 'none'"];
    
    // 设置标题
    if (self.titleStr) {
        self.title = self.titleStr;
    } else {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [self.blankHUD hideBlankView];
    
    // 协议有按钮
    if ([webView.request.URL.absoluteString containsString:policyAgreement]) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"].length ? [webView stringByEvaluatingJavaScriptFromString:@"document.title"] : @"协议";
        [self agreenBtn];
    }

//    //禁止用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    //禁止长按弹出选择框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.absoluteString;
    NSMutableString *newURL = url.mutableCopy;
    NSInteger flag = 0;
    
    while ([newURL rangeOfString:@"http"].location != NSNotFound) {
        [newURL replaceOccurrencesOfString:@"http" withString:@"" options:NSAnchoredSearch range:[newURL rangeOfString:@"http"]];
        flag++;
    }
    
    if (flag == 1 && [newURL containsString:@"SUCCESS"]) {
        [self.navigationController popViewControllerAnimated:true];
        return false;
    }
    

    return true;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"%@ error:\n%@\n", webView, error);
}

#pragma mark - 同意协议
- (void)agreeAction {
    [self.navigationController pushViewController:[SDKIdentityAuthenticationViewController new] animated:true];
}

#pragma mark - 返回(policyAgreement专用)
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - other method
- (UIBarButtonItem *)createBackButton:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"RiskControlBundle.bundle/arrow_back_white"]
            forState:UIControlStateNormal];
    button.tintColor = commonBlackColor;
    [button addTarget:self action:action
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, (44-adaptX(18))*0.5, adaptX(18), adaptX(18));
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return menuButton;
}

@end
