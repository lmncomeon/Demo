//
//  SDKBaseViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKBaseViewController.h"
#import "SDKTTooltipView.h"


@interface SDKBaseViewController ()

@property (nonatomic, copy) dispatch_block_t tapleftBarButtonItemEvent;

@property (nonatomic, copy) dispatch_block_t taprightBarButtonItemEvent;

@property (nonatomic, copy) dispatch_block_t tapimageleftBarButtonItemEvent;

@property (nonatomic, copy) dispatch_block_t tapimagerightBarButtonItemEvent;

@end

@implementation SDKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark  - 失败处理
- (void)errorDispose:(NSInteger)errorCode judgeMent:(NSString *)judgement{
    
    DLog(@"\n错误代码：%ld\n错误信息：%@", (long)errorCode, judgement);
    if (errorCode == 401) { // token 失效
        RiskControlSDK *sdk = [RiskControlSDK new];
        if (sdk.tokenInvalid) {
            sdk.tokenInvalid();
        }
        
//        //请求新token
//        [SDKCommonService requestAccesstokenWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
//                // 存储
//                [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"data"] forKey:keyName_token];
////                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kUIDName];
//            }else{
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
        [self dismissViewControllerAnimated:true completion:nil];
        
        UINavigationController * nav  = self.navigationController;
        [nav popToRootViewControllerAnimated:true];
    }else if (errorCode >= 500 && errorCode <= 599) {
        showTip(@"服务器出现故障，我们正在全力抢修，请您稍后");
    }else{

    }
}
#pragma mark  - 无网络的统一处理
- (void)errorRemind:(NSString *)judgement{
    // judgement -> 防止产品汪要做的其他特殊处理。
    showTip(@"请检查您的网络情况！");
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


- (void)createTitleBarButtonItemStyle:(BaseBtnTypeStyle)btnStyle title:(NSString *)title TapEvent:(void(^)(void))event{
    UIBarButtonItem *buttonItem;
    [buttonItem setTintColor:UIColorFromRGB(0x646563)];
    if (btnStyle==BaseBtnRightType) {
        buttonItem= [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(titleTapRightBar)];
        self.navigationItem.rightBarButtonItem = buttonItem;
        self.taprightBarButtonItemEvent = event;
    }else if (btnStyle==BaseBtnLeftType){
        buttonItem= [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(titleTapLeftBar)];
        self.navigationItem.leftBarButtonItem = buttonItem;
        self.tapleftBarButtonItemEvent = event;
    }
}
- (void)createImageBarButtonItemStyle:(BaseBtnTypeStyle)btnStyle Image:(NSString *)image TapEvent:(void(^)(void))event{
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (kScreenWidth <= 320) {
        settingButton.frame = CGRectMake(280, 10, 24, 24);
    }else if (kScreenWidth > 320) {
        settingButton.frame = CGRectMake(280, 7.6, 28.8, 28.8);
    }
    [settingButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    if (btnStyle==BaseBtnRightType) {
        self.navigationItem.rightBarButtonItem = buttonItem;
        self.tapimagerightBarButtonItemEvent = event;
        [settingButton addTarget:self action:@selector(tapimagerightBar) forControlEvents:UIControlEventTouchUpInside];
    }else if (btnStyle==BaseBtnLeftType){
        self.tapimageleftBarButtonItemEvent  = event;
        [settingButton addTarget:self action:@selector(tapimageleftBar) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)titleTapRightBar{!self.taprightBarButtonItemEvent ? nil:self.taprightBarButtonItemEvent();}
-(void)titleTapLeftBar{!self.tapleftBarButtonItemEvent ? nil:self.tapleftBarButtonItemEvent();}
-(void)tapimagerightBar{!self.tapimagerightBarButtonItemEvent ? nil:self.tapimagerightBarButtonItemEvent();}
-(void)tapimageleftBar{!self.tapimageleftBarButtonItemEvent ? nil:self.tapimageleftBarButtonItemEvent();}

- (void)setupNav:(NSString *)titleStr{
    self.navigationItem.titleView = ({
        UILabel *titleLab = [UILabel new];
        titleLab.frame = CGRectMake(0, 0, 200, 30);
        titleLab.text = titleStr;
        titleLab.textAlignment = 1;
        titleLab.font = kFont(17);
        titleLab.textColor = kNavTitleColor;
        titleLab;
    });
}

- (void)setupNavWithTitle:(NSString *)title {
    self.navigationItem.titleView = ({
        UILabel *titleLab = [UILabel new];
        titleLab.frame = CGRectMake(0, 0, 80, 30);
        titleLab.text = title;
        titleLab.textAlignment = 1;
        titleLab.font = kFont(17);
        titleLab.textColor = kNavTitleColor;
        titleLab;
    });
}

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


// 模型转换
- (NSArray *)optionModelToPickerModel:(NSArray <SDKOptionModel *> *)options {
    NSMutableArray *tmp = [NSMutableArray array];
    for (SDKOptionModel *model in options) {
        SDKPickerModel *change = [SDKPickerModel new];
        change.text = model.text;
        change.value = model.value;
        [tmp addObject:change];
    }
    
    return tmp.copy;
}

// 字典转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    if (dic == nil) {
        return nil;
    }
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    if ([jsonData length] > 0 && parseError == nil){
        DLog(@"Successfully serialized the dictionary into data.");
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return nil;

}


#pragma mark - 接口
// 上传照片
- (void)uplodImage:(UIImage *)img model:(SDKCommonModel *)model index:(NSInteger)index sucess:(void(^)(NSString * url))sucess {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
            
            NSString *fileName = @"";
            if (model) {
                if (index == 0) {
                    fileName = model.name;
                } else if (index == 1) {
                    fileName = model.name2;
                } else if (index == 2) {
                    fileName = model.name3;
                }
            }
            
            [SDKCommonService uplodFileWithType:@"image" file:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg", fileName] mimeType:@"image/jpeg"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    
                    if (sucess) {
                        // 传url
                        sucess(responseObject[@"data"] ? responseObject[@"data"] : @"");
                    }
                    
                    [self.hud hideCustomHUD];
                }else{
                    [self.hud hideCustomHUD];
                    showTip(responseObject[@"msg"]);
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

// 上传录音
- (void)uplodRecord:(NSData *)recordData sucess:(void(^)(NSString *url))sucess {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
      
            [SDKCommonService uplodFileWithType:@"audio" file:^(id<AFMultipartFormData> formData) {

                [formData appendPartWithFileData:recordData name:@"file" fileName:@"record.mp4" mimeType:@"audio/mp4"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    
                    if (sucess) {
                        sucess(responseObject[@"data"] ? responseObject[@"data"] : @"");
                    }
                    
                    [self.hud hideCustomHUD];
                }else{
                    [self.hud hideCustomHUD];
                    showTip(responseObject[@"msg"]);
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

// 上传视频
- (void)uplodVideo:(NSData *)videoData name:(NSString *)name sucess:(void(^)(NSString *url))sucess {
    if ([name isEqualToString:@""]) {
        name = @"video.mp4";
    }
    
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];

            [SDKCommonService uplodFileWithType:@"video" file:^(id<AFMultipartFormData> formData) {
                
                [formData appendPartWithFileData:videoData name:@"file" fileName:name mimeType:@"video/mpeg4"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    
                    if (sucess) {
                        sucess(responseObject[@"data"] ? responseObject[@"data"] : @"");
                    }
                    
                    [self.hud hideCustomHUD];
                }else{
                    [self.hud hideCustomHUD];
                    showTip(responseObject[@"msg"]);
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


// 提交数据
- (void)sendDataToServerWithContent:(NSString *)content name:(NSString *)name sucess:(void(^)(NSArray <SDKAnswerModel *>*arr))sucess {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService infomationSubmitWithStepName:name content:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:5];
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        SDKAnswerModel *model = [SDKAnswerModel yy_modelWithDictionary:dic];
                        [tmp addObject:model];
                    }
                    
                    if (sucess) {
                        sucess(tmp.copy);
                    }
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

// 修改信审资料
- (void)modifyCreditInfoWithContent:(NSString *)content name:(NSString *)name success:(void(^)())success {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService editCreditInfoWithStepName:name content:content success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    if (success) {
                        success();
                    }
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

// 获取某项授权状态
- (void)requsetAuthStatusWithType:(NSString *)type result:(void(^)(BOOL res))result {
   
    [SDKNetworkState WithSuccessBlock:^(BOOL status) {
        if (status == true)
        {

            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService requestAuthorizeStautsSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    NSDictionary *dic = responseObject[@"data"];
                    if (result) {
                        result([dic[type] boolValue]);
                    }
                    
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

// 是否全部授权
- (void)judgeAuthStatusWithNames:(NSArray <NSString *> *)names result:(void(^)(BOOL res))result {
    [SDKNetworkState WithSuccessBlock:^(BOOL status) {
        if (status == true)
        {
            
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService requestAuthorizeStautsSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    NSDictionary *dic = responseObject[@"data"];
                    
                    NSInteger flag = 1;
                    for (NSString *key in names) {
                        if (![dic[key] boolValue]) {
                            flag = 0;
                            break;
                        }
                    }
                    
                    if (flag == 1) { // 通通授权
                        if (result) {
                            result(true);
                        }
                    } else {
                        if (result) {
                            result(false);
                        }
                    }
                    
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

// 获取授权情况
- (void)authStatusWithData:(void (^)(NSDictionary *dic))data {
    [SDKNetworkState WithSuccessBlock:^(BOOL status) {
        if (status == true)
        {
            
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService requestAuthorizeStautsSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                    
                    NSDictionary *dic = responseObject[@"data"];
                    if (data) {
                        data(dic);
                    }
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


// 提交风控
- (void)submitAnwserWithQid:(NSInteger)qid answer:(NSString *)answer result:(void(^)(BOOL res))result {
    [SDKNetworkState WithSuccessBlock:^(BOOL status){
        if (status == true)
        {
            self.hud = [[SDKcustomHUD alloc] init];
            [self.hud showCustomHUDWithView:self.view];
            
            [SDKCommonService submitAnswerQuestionWithQid:qid answer:answer success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"retcode"] integerValue] == 200) {
                    [self.hud hideCustomHUD];
                   
                    if (result) {
                        result(true);
                    }
                }else{
                    showTip(responseObject[@"msg"]);
                    [self.hud hideCustomHUD];
                    
                    if (result) {
                        result(false);
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.hud hideCustomHUD];
                [self errorDispose:[[operation response] statusCode] judgeMent:nil];
                
                if (result) {
                    result(false);
                }
            }];
          
        }
        else
        {
            [self errorRemind:nil];
        }
    }];
}

@end













