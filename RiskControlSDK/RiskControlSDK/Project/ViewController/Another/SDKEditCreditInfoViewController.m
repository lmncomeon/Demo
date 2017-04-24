//
//  SDKEditCreditInfoViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/10.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKEditCreditInfoViewController.h"


@interface SDKEditCreditInfoViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) SDKPhotoView *photoView;

@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;

@end

@implementation SDKEditCreditInfoViewController

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
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollview addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:self.titleStr];
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    [self addNotification];
    
    [self setupUI];
}

- (void)setupUI {
    // 容器
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.mainScrollview addSubview:_container];
    
    
    // 授权容器
    NSMutableArray *baseArray = [NSMutableArray arrayWithCapacity:5];
    // 初始化
    for (SDKCommonModel *UIModel in _dataArray)
    {
        if ([UIModel.type isEqualToString:@"image"]) {
            // 照片
            _photoView = [[SDKPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel superVC:self];
            [_photoView showPicWithModel:UIModel];
            _photoView.sendValue = ^ (UIImage *img, NSInteger index) {
                // upload img
                [self uplodImage:img model:UIModel index:index sucess:^(NSString *url) {
                    [_photoView settingImage:img index:index url:url];
                }];
            };
            [_container addSubview:_photoView];
            
        }
        else if ([UIModel.type isEqualToString:@"radio"]) {
            //水平单选
            NSInteger selectedIndex = 0;
            for (int i = 0; i < UIModel.options.count; i++) {
                if ([UIModel.options[i].text isEqualToString:UIModel.value1]) {
                    selectedIndex = i;
                }
            }
            
            SDKRadioView *radioView = [[SDKRadioView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) title:UIModel.label model:UIModel selectedIndex:selectedIndex];
            [_container addSubview:radioView];
            
        }
        else if ([UIModel.type isEqualToString:@"list"] || [UIModel.type isEqualToString:@"checkbox"]) {
            // 选择框
            SDKListView *listView = [[SDKListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
            [listView showContent];
            [_container addSubview:listView];
        }
        else if ([UIModel.type isEqualToString:@"text"]  ||
                 [UIModel.type isEqualToString:@"phone"] ||
                 [UIModel.type isEqualToString:@"mailbox"])
        {
            SDKInputView *inputView = [[SDKInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
            [inputView showValueWithModel:UIModel];
            [_container addSubview:inputView];
        }
        else if ([UIModel.type isEqualToString:@"readtext"]) {
            // 通讯录
            SDKAddressView *addressView = [[SDKAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel innerVC:self];
            [_container addSubview:addressView];
            [addressView showContent];
            addressView.sendAllInfo = ^ (NSString *content) {
//                !_addressInfo ? : _addressInfo(content);
            };
        }
        else if ([UIModel.type isEqualToString:@"area"]) {
            // 城市
            SDKCityView *cityView = [[SDKCityView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel list:_areaList];
            [cityView showContent];
            [_container addSubview:cityView];
        }
       
    }
    
    CGFloat subY = 0;
    for (UIView *sub in _container.subviews) {
        sub.y = subY;
        subY  += sub.height;
    }
    
    _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
    
    // 提交
    self.submitBtn.y = CGRectGetMaxY(_container.frame) + adaptY(30);
    
    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame)+adaptY(30));
}

- (void)submitAction {
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
    
    __block  NSInteger status = 1;
    for (SDKBaseView *sub in _container.subviews) {
        [sub checkDataAndHandle:^(NSMutableDictionary *dic, BOOL res) {
            if (res == false) {
                status = 0;
            } else {
                [totalDic addEntriesFromDictionary:dic];
            }
        }];
        
        if (status == 0) {
            break;
        }
    }
    
    if (status == 1) { // data -> server
        NSString *contentStr = @"";
        if ([self dictionaryToJson:totalDic]) {
            contentStr = [self dictionaryToJson:totalDic];
            
            // send
            [self modifyCreditInfoWithContent:contentStr name:_name success:^{
                [self dismissViewControllerAnimated:true completion:nil];
            }];
        }
    }
    
}

- (void)dealloc {
    [self clearNotificationAndGesture];
}

#pragma mark - 返回
- (void)back {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
