//
//  SDKCreditNumTwoViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/20.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKCreditNumTwoViewController.h"
#import "SDKBaseWebViewController.h"
#import "SDKCredictPublicView.h"
#import "SDKCommonModel.h"
#import "SDKAuthGJJViewController.h"
#import "SDKAuthSheBaoViewController.h"
#import "SDKAccumulationFundAuthorizationViewController.h"

// 风控页面
#import "SDKInputTypeViewController.h"

@interface SDKCreditNumTwoViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) SDKCredictPublicView *publicView;

@end

@implementation SDKCreditNumTwoViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self handleAuthText];
}

- (void)handleAuthText {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
    for (SDKCommonModel *UIModel in self.data[_current].items) {
        if ([UIModel.type isEqualToString:@"H5"] || [UIModel.type isEqualToString:@"gongjijin"] || [UIModel.type isEqualToString:@"jinpo"]) {
            [tmp addObject:UIModel];
        }
    }
    
    
    if (tmp.count) { // 授权页
        [self authStatusWithData:^(NSDictionary *dic) {
            [_publicView settingAuthWithDic:dic];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"完善信用资料"];
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    
    [self addNotification];
    
    // UI
    [self createUIView];
    
}

- (void)createUIView {
    __weak __typeof(&*self)weakSelf = self;
    
    _publicView = [[SDKCredictPublicView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) model:self.data[_current] pageCount:self.data.count currentIndex:_current innerVC:self areaList:self.areaList];
    [self.mainScrollview addSubview:_publicView];
    
    
    _publicView.uplodImageBlock =  ^ (UIImage *img, SDKCommonModel *model, NSInteger index) {
        [weakSelf uplodImage:img model:model index:index sucess:^(NSString *url) {
            [weakSelf.publicView photoSuccessWithImage:img index:index url:url];
        }];
    };
    
    // 提交
    _publicView.submitEvent = ^ (NSString *contentStr) {
        [weakSelf sendDataToServerWithContent:contentStr name:weakSelf.data[weakSelf.current].name sucess:^(NSArray<SDKAnswerModel *> *arr) {
            if (arr.count)
            { // 有风控
                SDKInputTypeViewController *inputVC = [SDKInputTypeViewController new];
                inputVC.arr = arr;
                inputVC.currentIndex = 0;
                inputVC.answerEnd = ^ () {
                    [weakSelf loadingNewView];
                };
                inputVC.backEvent = ^ () {
                    [weakSelf dismissViewControllerAnimated:true completion:nil];
                };
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:inputVC] animated:true completion:nil];
            }
            else
            {
                [weakSelf loadingNewView];
                
            }

        }];
       
    };
    
    // 下一步
    _publicView.nextEvent = ^ (NSString *jsonStr) {
       
        [weakSelf sendDataToServerWithContent:jsonStr name:weakSelf.data[weakSelf.current].name sucess:^(NSArray<SDKAnswerModel *> *arr) {
            
            weakSelf.current++;
            if (_current <= self.data.count-1) {
                
                [weakSelf.publicView removeFromSuperview];
                [weakSelf createUIView];
                
                [weakSelf handleAuthText];
            } else { // lastVC
                [weakSelf dismissViewControllerAnimated:true completion:nil];
            }
            
            }];
        
        
//        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
//        for (SDKCommonModel *subM in weakSelf.data[weakSelf.current].items) {
//            [tmp addObject:subM.name];
//        }
//        
//        [weakSelf judgeAuthStatusWithNames:tmp.copy result:^(BOOL res) {
//            if (res) {
//                weakSelf.current++;
//                if (_current <= self.data.count-1) {
//                    
//                    [weakSelf.publicView removeFromSuperview];
//                    [weakSelf createUIView];
//                    
//                    [weakSelf handleAuthText];
//                } else { // lastVC
//                    [weakSelf dismissViewControllerAnimated:true completion:nil];
//                }
//            } else {
//                showTip(@"有未授权项");
//            }
//        }];
//
        
        
    };
    
    // 通讯录数据
    _publicView.addressInfo = ^ (NSString *str) {
        DLog(@"address:%@", str);
        
        [SDKCommonService submitExtraInfoWithContent:str success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"retcode"] integerValue] == 200) {
                DLog(@"address成功");
            } else {
                DLog(@"address失败");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf errorDispose:[[operation response] statusCode] judgeMent:nil];
        }];
    };
    
    // 运行商点击图标-> h5
    _publicView.intoH5 = ^ (SDKCommonModel *model) {
        SDKBaseWebViewController *webVC = [SDKBaseWebViewController new];
        webVC.loadUrlStr = [NSString stringWithFormat:@"%@?access_token=%@&source=ios", model.placeholder, kgetCommonData(keyName_token)];
        [weakSelf.navigationController pushViewController:webVC animated:true];
//        [weakSelf requsetAuthStatusWithType:model.name result:^(BOOL res) {
//            if (!res) {
        
//            }
//        }];
    };
    
    
    // 公积金
    _publicView.intoGJJApp = ^ (SDKCommonModel *model) {
//        [weakSelf requsetAuthStatusWithType:model.name result:^(BOOL res) {
//            if (!res) {
//                
//                
//            }
//        }];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"SDKAuthorizationInfo" bundle:[NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"RiskControlBundle" ofType: @"bundle"]]];
        SDKAccumulationFundAuthorizationViewController *pushViewController = [storyboard instantiateViewControllerWithIdentifier:@"SDKAccumulationFundAuthorizationViewController"];
        [weakSelf.navigationController pushViewController:pushViewController animated:YES];
        
    };
    
    // 社保
    _publicView.intoSBApp = ^ (SDKCommonModel *model) {
//        [weakSelf requsetAuthStatusWithType:model.name result:^(BOOL res) {
//            if (!res) {
//                
//            }
//        }];
        
        [weakSelf.navigationController pushViewController:[SDKAuthSheBaoViewController new] animated:true];
    };
    
    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(_publicView.frame) + adaptY(30));
}

- (void)loadingNewView {
    _current++;
    if (_current <= self.data.count-1) {
        [_publicView removeFromSuperview];
        [self createUIView];
        
    } else { // lastVC
        [self dismissViewControllerAnimated:true completion:nil];
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
