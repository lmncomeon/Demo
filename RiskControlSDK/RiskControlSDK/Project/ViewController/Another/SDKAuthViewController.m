//
//  SDKAuthViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/4/11.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKAuthViewController.h"
#import "UIImageView+WebCache.h"
#import "SDKBaseWebViewController.h"

@interface SDKAuthViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) UIView *main;
@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;

@property (nonatomic, strong) NSDictionary *authStatusDic;

@property (nonatomic, strong) NSMutableArray <UIImageView *> *nikesArray;

@end

@implementation SDKAuthViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (SDKCustomRoundedButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _submitBtn.frame = CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(35));
        [self.submitBtn addTarget:self action:@selector(submitAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollview addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavWithTitle:_titleStr];
    if (_type == Entrance_out) {
        self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    }
    
//    if (self.edit) {
//        [self createTitleBarButtonItemStyle:BaseBtnRightType title:@"编辑" TapEvent:^{
//            self.navigationItem.rightBarButtonItem = nil;
//            // 进入编辑页面
//            for (int i = 0; i < _main.subviews.count; i++) {
//                UIView *item = _main.subviews[i];
//                [item addSingleTapEvent:^{
//                    if (self.dataList[i].placeholder) {
//                        SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
//                        webVC.loadUrlStr = self.dataList[i].placeholder;
//                        [self.navigationController pushViewController:webVC animated:true];
//                    }
//                }];
//            }
//            
//            self.submitBtn.y = CGRectGetMaxY(_main.frame) + adaptY(30);
//            self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) +adaptY(30));
//            
//            
//        }];
//        
//    }
    
    
    _main = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.mainScrollview addSubview:_main];
    
    CGFloat itemW = kScreenWidth*0.5;
    CGFloat itemH = adaptY(140);
    
    for (int i = 0; i < self.dataList.count; i++) {
        SDKCommonModel *model = self.dataList[i];
        
        NSInteger row = i /2;
        NSInteger col = i %2;
        UIView *item = [self createViewWithFrame:CGRectMake(col*itemW, adaptY(10)+row*itemH, itemW, itemH) model:model];
        [item addSingleTapEvent:^{
            if (self.dataList[i].placeholder) {
                SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
                webVC.loadUrlStr = self.dataList[i].placeholder;
                [self.navigationController pushViewController:webVC animated:true];
            }
                            }];
        
        [_main addSubview:item];
    }
    
    _main.height = CGRectGetMaxY(_main.subviews.lastObject.frame);

    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.mainScrollview.subviews.lastObject.frame)+ adaptY(30));
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.dataList.count) {
        [self authStatusWithData:^(NSDictionary *dic) {
            self.authStatusDic = dic; // 记录
            
            for (int i = 0; i < _main.subviews.count; i++) {
                UIView *item = _main.subviews[i];
                
                if ([dic[self.dataList[i].name] boolValue]) {
                    self.nikesArray[i].hidden = false;
                    
                    // 控制交互
                    item.userInteractionEnabled = false;
                } else {
                    self.nikesArray[i].hidden = true;
                    
                    // 控制交互
                    item.userInteractionEnabled = true;
                }
                
            }
        }];
    }
    
}

// 授权提交
- (void)submitAuth {
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
    
    for (SDKCommonModel *model in self.dataList) {
        totalDic[model.name] = self.authStatusDic[model.name];
    }
    
    NSString *contentStr = @"";
    if ([self dictionaryToJson:totalDic]) {
        contentStr = [self dictionaryToJson:totalDic];
        
        // send
        [self modifyCreditInfoWithContent:contentStr name:_name success:^{
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    }
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - other method
// 创建授权小方块
- (UIView *)createViewWithFrame:(CGRect)frame model:(SDKCommonModel *)model {
    UIView *item = [[UIView alloc] initWithFrame:frame];
    
    CGFloat iconWH = adaptX(77);
    CGFloat useW   = frame.size.width;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((useW-iconWH)*0.5, 0, iconWH, iconWH)];
    [icon sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.890 alpha:1.0]]];
    [item addSubview:icon];
    
    CGFloat nikeWH = adaptX(25);
    UIImageView *nike = [[UIImageView alloc] initWithFrame:CGRectMake(icon.frame.size.width-nikeWH, 0, nikeWH, nikeWH)];
    nike.image = [UIImage imageNamed:kImageBundle @"ios-对勾"];
    [icon addSubview:nike];
    nike.hidden = true;
    [self.nikesArray addObject:nike];
    
    SDKCustomLabel *nameLab = [SDKCustomLabel setLabelTitle:model.label setLabelFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+adaptY(5), useW, adaptY(20)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
    [item addSubview:nameLab];


    
    return item;
}

#pragma mark - lazy load
- (NSMutableArray <UIImageView *> *)nikesArray {
    if (!_nikesArray) {
        _nikesArray = [NSMutableArray array];
    }
    return _nikesArray;
}

@end
