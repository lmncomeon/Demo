//
//  SDKCreditInfoViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/1.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCreditInfoViewController.h"
#import "SDKBaseWebViewController.h"
#import "UIImageView+WebCache.h"
#import "SDKInfoView.h"

@interface SDKCreditInfoViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;

// 展示
@property (nonatomic, strong) UIView *main;

// 编辑
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) SDKPhotoView *photoView;
@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;
@property (nonatomic, strong) NSMutableArray *areaList;

// 授权
@property (nonatomic, strong) NSMutableArray <SDKCustomLabel *> *labsArray;
@property (nonatomic, strong) NSMutableArray <SDKCommonModel *> *h5Arr;

@property (nonatomic, strong) NSDictionary *authStatusDic;

@end

@implementation SDKCreditInfoViewController

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
        [self.mainScrollview addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavWithTitle:self.titleStr];
    if (self.edit) {
        [self createTitleBarButtonItemStyle:BaseBtnRightType title:@"编辑" TapEvent:^{
            self.navigationItem.rightBarButtonItem = nil;
            // 进入编辑页面
            if (self.h5Arr.count)
            { // h5授权页面
                for (int i = 0; i < _main.subviews.count; i++) {
                    UIView *item = _main.subviews[i];
                    [item addSingleTapEvent:^{
                        if (self.dataArray[i].placeholder) {
                            SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
                            webVC.loadUrlStr = self.dataArray[i].placeholder;
                            [self.navigationController pushViewController:webVC animated:true];
                        }
                    }];
                }
                
                self.submitBtn.y = CGRectGetMaxY(_main.frame) + adaptY(30);
                self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame));
                [self.submitBtn addTarget:self action:@selector(submitAuth) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [self addNotification];
                [_main removeFromSuperview];
                [self getProvince];
            }
            
        }];
        
    }
    

    // handle data
    for (int i = 0; i < self.dataArray.count; i++) {
        SDKCommonModel *model = self.dataArray[i];
        
        if ([model.type isEqualToString:@"H5"]) {
            [self.h5Arr addObject:model];
        }
    }
    
    
    _main = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.mainScrollview addSubview:_main];
    
    if (self.h5Arr.count)
    { // h5授权页面
        CGFloat itemW = kScreenWidth*0.5;
        CGFloat itemH = adaptY(140);
        
        for (int i = 0; i < self.h5Arr.count; i++) {
            SDKCommonModel *model = self.h5Arr[i];
        
            NSInteger row = i /2;
            NSInteger col = i %2;
            UIView *item = [self createViewWithFrame:CGRectMake(col*itemW, adaptY(10)+row*itemH, itemW, itemH) model:model];
            
            [_main addSubview:item];
        }

    }
    else
    {
        
        for (int i = 0; i < self.dataArray.count; i++) {
            SDKCommonModel *model = self.dataArray[i];
            
            SDKInfoView *infoView = [[SDKInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:model];
            [_main addSubview:infoView];
        }
        
        CGFloat subY = 0;
        for (UIView *sub in _main.subviews) {
            sub.y = subY;
            subY += sub.height;
        }

    }

    _main.height = CGRectGetMaxY(_main.subviews.lastObject.frame);
    
    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(_main.frame)+ adaptY(30));

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.h5Arr.count) {
        [self authStatusWithData:^(NSDictionary *dic) {
            self.authStatusDic = dic; // 记录
            
            for (int i = 0; i < _main.subviews.count; i++) {
                if ([dic[self.h5Arr[i].name] boolValue]) {
                    self.labsArray[i].text = @"已授权";
                }
            }
        }];
    }
    
}
// 获取省市区
- (void)getProvince {
    [SDKCommonService requestProvinceCityZoneSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *dic in responseObject) {
            SDKPickerModel *provinceModel = [SDKPickerModel new];
            provinceModel.text = dic[@"province"];
            
            NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:5];
            NSArray *tmpCityArr = dic[@"cities"];
            for (NSDictionary *cityDic in tmpCityArr) {
                SDKPickerModel *cityModel = [SDKPickerModel new];
                cityModel.text = cityDic[@"city"];
                
                NSMutableArray *zoneArray = [NSMutableArray arrayWithCapacity:5];
                NSArray *tmpZoneArr = cityDic[@"zones"];
                for (NSString *zone in tmpZoneArr) {
                    SDKPickerModel *zoneModel = [SDKPickerModel new];
                    zoneModel.text = zone;
                    [zoneArray addObject:zoneModel];
                }
                
                cityModel.list = zoneArray;
                [cityArray addObject:cityModel];
            }
            
            
            provinceModel.list = cityArray;
            [tmp addObject:provinceModel];
            
        }
        
        self.areaList = tmp.copy;
        [self showEditView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}

// 显示编辑页面
- (void)showEditView {
    // 容器
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.mainScrollview addSubview:_container];
    
    // 初始化
    for (SDKCommonModel *UIModel in _dataArray)
    {
        if ([UIModel.type isEqualToString:@"image"]) {
            // 照片
            _photoView = [[SDKPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel superVC:self];
            [_photoView showPicWithModel:UIModel];
            
            __weak __typeof(&*self)weakSelf = self;
            _photoView.sendValue = ^ (UIImage *img, NSInteger index) {
                // upload img
                [weakSelf uplodImage:img model:UIModel index:index sucess:^(NSString *url) {
                    [weakSelf.photoView settingImage:img index:index url:url];
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
            SDKCityView *cityView = [[SDKCityView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel list:self.areaList];
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
    [self.submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn.y = CGRectGetMaxY(_container.frame) + adaptY(30);
    
    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame)+adaptY(30));
}

#pragma mark - 点击提交按钮
// 普通提交
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

// 授权提交
- (void)submitAuth {
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
    
    for (SDKCommonModel *model in self.h5Arr) {
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

#pragma mark - other method
// 创建授权小方块
- (UIView *)createViewWithFrame:(CGRect)frame model:(SDKCommonModel *)model {
    UIView *item = [[UIView alloc] initWithFrame:frame];
    
    CGFloat iconWH = adaptX(77);
    CGFloat useW   = frame.size.width;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((useW-iconWH)*0.5, 0, iconWH, iconWH)];
    [icon sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.890 alpha:1.0]]];
    icon.layer.masksToBounds = true;
    icon.layer.cornerRadius = iconWH*0.5;
    [item addSubview:icon];
    
    SDKCustomLabel *nameLab = [SDKCustomLabel setLabelTitle:model.label setLabelFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+adaptY(5), useW, adaptY(20)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
    [item addSubview:nameLab];
    
    SDKCustomLabel *typeLab = [SDKCustomLabel setLabelTitle:model.required ? @"(必填)" : @"(选填)"  setLabelFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame), useW, adaptY(20)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
    [item addSubview:typeLab];
    [self.labsArray addObject:typeLab];
    
    return item;
}

- (void)dealloc {
    [self clearNotificationAndGesture];
}

#pragma mark - lazy load
- (NSMutableArray <SDKCustomLabel *> *)labsArray {
    if (!_labsArray) {
        _labsArray = [NSMutableArray array];
    }
    return _labsArray;
}


- (NSMutableArray <SDKCommonModel *> *)h5Arr {
    if (!_h5Arr) {
        _h5Arr = [NSMutableArray array];
    }
    return _h5Arr;
}

@end
