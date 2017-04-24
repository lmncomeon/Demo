//
//  SDKCredictPublicView.m
//  RiskControlSDK
//
//  Created by 美娜栾 on 2017/2/25.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCredictPublicView.h"
#import "SDKBaseViewController.h"
#import "SDKInfomationModel.h"
#import "SDKCommonModel.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKCustomRoundedButton.h"
#import "UIImageView+WebCache.h"

#import "SDKProgressView.h"
#import "SDKTitleView.h"
#import "SDKPhotoView.h"
#import "SDKRadioView.h"
#import "SDKListView.h"
#import "SDKInputView.h"
#import "SDKAddressView.h"
#import "SDKPickerModel.h"
#import "SDKCityView.h"
#import "SDKAboutText.h"

@interface SDKCredictPublicView ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) SDKPhotoView *photoView;

@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;
@property (nonatomic, strong) SDKCustomRoundedButton *nextBtn; // 授权专用

@property (nonatomic, strong) SDKBaseViewController *superVC;

@property (nonatomic, strong) SDKInfomationModel *currentModel;
@property (nonatomic, strong) NSMutableArray <SDKCustomLabel *> *labsArray;

@property (nonatomic, strong) NSDictionary *authStatusDic;

@end

@implementation SDKCredictPublicView

- (SDKCustomRoundedButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _submitBtn.frame = CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(35));
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (SDKCustomRoundedButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"下一步" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _nextBtn.frame = CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(35));
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
    }
    return _nextBtn;
}

- (instancetype)initWithFrame:(CGRect)frame model:(SDKInfomationModel *)model pageCount:(NSInteger)pageCount currentIndex:(NSInteger)currentIndex innerVC:(SDKBaseViewController *)innerVC areaList:(NSArray <SDKPickerModel *> *)areaList
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _superVC   = innerVC;
        _currentModel = model;
        
        // 进度
        SDKProgressView *progress = [[SDKProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(44)) count:pageCount current:currentIndex+1];
        [self addSubview:progress];
        
        // 标题
        SDKTitleView *titleView = [[SDKTitleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(progress.frame), kScreenWidth, 0)  colorLump:kBtnNormalBlue text:model.title];
        [self addSubview:titleView];
        
        // 容器
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), kScreenWidth, 0)];
        [self addSubview:_container];
        
        
        // 授权容器
        NSMutableArray *baseArray = [NSMutableArray arrayWithCapacity:5];
        // 初始化
        for (SDKCommonModel *UIModel in model.items)
        {
            if ([UIModel.type isEqualToString:@"image"]) {
                // 照片
                _photoView = [[SDKPhotoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), kScreenWidth, 0) model:UIModel superVC:_superVC];
                _photoView.sendValue = ^ (UIImage *img, NSInteger index) {
                    
                    // upload img
                    !_uplodImageBlock ? : _uplodImageBlock(img, UIModel, index);
                };
                [_container addSubview:_photoView];
                
            }
            else if ([UIModel.type isEqualToString:@"radio"]) {
                //水平单选
                SDKRadioView *radioView = [[SDKRadioView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) title:UIModel.label model:UIModel selectedIndex:0];
                [_container addSubview:radioView];
                
            }
            else if ([UIModel.type isEqualToString:@"list"]) {
                // 选择框
                SDKListView *listView = [[SDKListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
                [_container addSubview:listView];
            }
            else if ([UIModel.type isEqualToString:@"checkbox"]) {
                SDKListView *checkView = [[SDKListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
                [_container addSubview:checkView];
            }
            else if ([UIModel.type isEqualToString:@"text"]) {
                SDKInputView *inputView = [[SDKInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
                [_container addSubview:inputView];
            }
            else if ([UIModel.type isEqualToString:@"phone"]) {
                SDKInputView *inputView = [[SDKInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
                [_container addSubview:inputView];
            }
            else if ([UIModel.type isEqualToString:@"mailbox"]) {
                SDKInputView *inputView = [[SDKInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel];
                [_container addSubview:inputView];
            }
            else if ([UIModel.type isEqualToString:@"readtext"]) {
                // 通讯录
                SDKAddressView *addressView = [[SDKAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel innerVC:_superVC];
                [_container addSubview:addressView];
                addressView.sendAllInfo = ^ (NSString *content) {
                    !_addressInfo ? : _addressInfo(content);
                };
            }
            else if ([UIModel.type isEqualToString:@"area"]) {
                // 城市
                SDKCityView *cityView = [[SDKCityView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:UIModel list:areaList];
                [_container addSubview:cityView];
            }
            else if ([UIModel.type isEqualToString:@"H5"] || [UIModel.type isEqualToString:@"gongjijin"] || [UIModel.type isEqualToString:@"jinpo"]) {
                [baseArray addObject:UIModel];
            }
            
        }
        
        
        if (baseArray.count)
        { // **** 运行商授权页面
            CGFloat itemW = kScreenWidth*0.5;
            CGFloat itemH = adaptY(140);
            for (int i = 0; i < baseArray.count; i++) {
                NSInteger row = i /2;
                NSInteger col = i %2;
                UIView *item = [self createViewWithFrame:CGRectMake(col*itemW, adaptY(10)+row*itemH, itemW, itemH) model:baseArray[i]];
                [item addSingleTapEvent:^{
                    [self handleMthod:baseArray[i]];
                }];
                [_container addSubview:item];
            }
            
            _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
            
            // 下一步
            self.nextBtn.y = CGRectGetMaxY(_container.frame) + adaptY(30);
            
            // 温馨提示
            NSString *tipStr = [SDKAboutText replaceUnicode:model.depict];
            SDKCustomLabel *tipLab = [SDKCustomLabel setLabelTitle:tipStr setLabelFrame:CGRectMake(2*kDefaultPadding, CGRectGetMaxY(_nextBtn.frame)+adaptY(20), kScreenWidth-3*kDefaultPadding, [SDKAboutText sizeWithString:tipStr maxWidth:kScreenWidth-3*kDefaultPadding font:kFont(14)].height) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
            tipLab.numberOfLines = 0;
            [self addSubview:tipLab];
            
        }
        else
        {
            // *****其他页面
            CGFloat subY = 0;
            for (UIView *sub in _container.subviews) {
                sub.y = subY;
                subY  += sub.height;
            }
            
            _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
            
            // 提交
            self.submitBtn.y = CGRectGetMaxY(_container.frame) + adaptY(30);
        }
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
    }
    return self;
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
        }
        
        !_submitEvent ? : _submitEvent(contentStr);
    }
    
}

// 下一步
- (void)nextAction {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < _currentModel.items.count; i++) {
        dic[_currentModel.items[i].name] = self.authStatusDic[_currentModel.items[i].name];
    }
    
    NSString *jsonStr = [self dictionaryToJson:dic.copy];
    if (jsonStr) {
        !_nextEvent ? : _nextEvent(jsonStr);
    }
    
}

- (void)photoSuccessWithImage:(UIImage *)img index:(NSInteger)index url:(NSString *)url {
    [_photoView settingImage:img index:index url:url];
}

// 字典转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

// create view
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

- (void)handleMthod:(SDKCommonModel *)model {
    if (!self.authStatusDic) return;
    
    if (![self.authStatusDic[model.name] boolValue]) { // 未授权
        if ([model.type isEqualToString:@"H5"]) {
            
            !_intoH5 ? : _intoH5(model);
            
        } else if ([model.type isEqualToString:@"gongjijin"]) {
            !_intoGJJApp ? : _intoGJJApp(model);
        } else if ([model.type isEqualToString:@"jinpo"]) {
            !_intoSBApp ? : _intoSBApp(model);
        }
    }
}

// 赋值授权
- (void)settingAuthWithDic:(NSDictionary *)dic {
    self.authStatusDic = dic; // 记录
    
    for (int i = 0; i < _currentModel.items.count; i++) {
        BOOL res = [dic[_currentModel.items[i].name] boolValue];
        if (res) {
            self.labsArray[i].text = @"(已授权)";
        }
    }
 
}

#pragma mark - lazy load
- (NSMutableArray <SDKCustomLabel *> *)labsArray {
    if (!_labsArray) {
        _labsArray = [NSMutableArray array];
    }
    return _labsArray;
}

@end
