//
//  SDKInputTypeViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/22.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKInputTypeViewController.h"
#import "SDKInputView.h"
#import "SDKAnswerModel.h"
#import "SDKSelectPhoneView.h"
#import "SDKVideoView.h"

@interface SDKInputTypeViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SDKTitleView *titleView;
@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) SDKSelectPhoneView *phoneView;

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *videoUrl;

@end

@implementation SDKInputTypeViewController

- (UIScrollView *)mainScrollview {
    if (!_mainScrollview) {
        _mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _mainScrollview.alwaysBounceVertical=true;
        _mainScrollview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_mainScrollview];
    }
    return _mainScrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavWithTitle:@"补充信用资料"];
    self.navigationItem.leftBarButtonItem = [self createBackButton:@selector(back)];
    [self addNotification];

//   
//    // 进度
//    SDKProgressView *progress = [[SDKProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(44)) count:9 current:1];
//    [self.mainScrollview addSubview:progress];
//    
//    
    // 标题
    _titleView = [[SDKTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)  colorLump:kBtnNormalBlue text:@"松鼠小测试"];
    _titleView.backgroundColor = commonWhiteColor;
    [_titleView noneBottomLine];
    [self.mainScrollview addSubview:_titleView];

    [self createUI];
}

- (void)createUI {
    SDKAnswerModel *model = _arr[_currentIndex];
    if (model.second > 0 && ![model.type isEqualToString:@"audio"] && ![model.type isEqualToString:@"video"]) { // 有限时
        [self startTimer:0 type:model.type];
    }
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame)+adaptY(17), kScreenWidth, 0)];
    [self.mainScrollview addSubview:_container];
    
    if ([model.type isEqualToString:@"text"]) {
        // 输入
        SDKInputView *topicView = [[SDKInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) topic:model.question];
        topicView.sendValue = ^ (NSString *str) {
            _value = str;
        };
        [_container addSubview:topicView];
        
        // btn
        SDKCustomRoundedButton *btn = [self createSubmitBtn];
        btn.y = CGRectGetMaxY(topicView.frame) + adaptY(30);
        
        [btn addTarget:self action:@selector(textAction) forControlEvents:UIControlEventTouchUpInside];
    
    }
    else if ([model.type isEqualToString:@"radio"]) {
        // 选择手机号码
        _phoneView = [[SDKSelectPhoneView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) topic:model.question list:model.options];
        [_container addSubview:_phoneView];
        
        // btn
        SDKCustomRoundedButton *btn = [self createSubmitBtn];
        btn.y = CGRectGetMaxY(_phoneView.frame) + adaptY(30);
        [btn addTarget:self action:@selector(radioAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([model.type isEqualToString:@"image"]) {
        // 拍照
        SDKPhotoView *photoView = [[SDKPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) text:model.question superVC:self];
        photoView.sendValue = ^ (UIImage *img, NSInteger index) {
            [self uplodImage:img model:nil index:0 sucess:^(NSString *url) {
                _url = url;
                [photoView settingImage:img index:0 url:url];
            }];
        };
        [_container addSubview:photoView];
        
        // btn
        SDKCustomRoundedButton *btn = [self createSubmitBtn];
        btn.y = CGRectGetMaxY(photoView.frame) + adaptY(30);
        [btn addTarget:self action:@selector(imageAction) forControlEvents:UIControlEventTouchUpInside];
        
    } if ([model.type isEqualToString:@"audio"]) {
        // 录音
        SDKRecordView *recordView = [[SDKRecordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) tipText:model.question];
        if (model.second) {
            recordView.maxRecordTime = model.second;
        }
        recordView.uplodFile = ^ (NSData *audioData) {
            [self uplodRecord:audioData sucess:^(NSString *url) {
                [recordView deleteOldVoice];
                
                _voiceUrl = url;
                [self handleClickActionWithType:model.type];
            }];
        };
        [_container addSubview:recordView];
        
    } if ([model.type isEqualToString:@"video"]) {
        // 录制视频
        SDKVideoView *videoView = [[SDKVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) innerViewController:self text:model.question];
        videoView.useVideoEvent = ^ (NSData *mp4, NSString *name) {
            
            [self uplodVideo:mp4 name:name sucess:^(NSString *url) {
                
                _videoUrl = url;
                [self handleClickActionWithType:model.type];
            }];
        };
        [_container addSubview:videoView];
    }
    
    _container.height = CGRectGetMaxY(_container.subviews.lastObject.frame);
    
    self.mainScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(_container.frame) + adaptY(30));
    
}

- (SDKCustomRoundedButton *)createSubmitBtn {
    SDKCustomRoundedButton *btn = [SDKCustomRoundedButton roundedBtnWithTitle:@"点击提交" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
    btn.frame = CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(35));
    [_container addSubview:btn];
    return btn;
}

#pragma mark - 提交
- (void)textAction {
    [self handleClickActionWithType:@"text"];
}

- (void)imageAction {
    [self handleClickActionWithType:@"image"];
}

- (void)radioAction {
    [self handleClickActionWithType:@"radio"];
}

- (void)handleClickActionWithType:(NSString *)type {
    if (_arr[_currentIndex].second > 0 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"video"]) { // 有限时
        [_timer invalidate];
        _timer = nil;
    }
    
    
    
    
    if ([type isEqualToString:@"text"])
    {
        if (_arr[_currentIndex].second > 0 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"video"]) { // 有限时
            
        } else {
            if (!_value) {
                showTip(@"请填写");
                return;
            }
        }
        
        [self submitAnwserWithQid:_arr[_currentIndex].ID answer:_value ? _value : @"" result:^(BOOL res) {
            [self handleByResult:res type:type];
        }];

    }
    else if ([type isEqualToString:@"image"]) {
        if (_arr[_currentIndex].second > 0 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"video"]) { // 有限时
            
        } else {
            if (!_url) {
                showTip(@"请上传照片");
                return;
            }
        }
        
        [self submitAnwserWithQid:_arr[_currentIndex].ID answer:_url ? _url : @"" result:^(BOOL res) {
            [self handleByResult:res type:type];
        }];
    }
    else if ([type isEqualToString:@"radio"]) {
        [self submitAnwserWithQid:_arr[_currentIndex].ID answer:[_phoneView selectedValue] result:^(BOOL res) {
            [self handleByResult:res type:type];
        }];
    }
    else if ([type isEqualToString:@"audio"]) {
        [self submitAnwserWithQid:_arr[_currentIndex].ID answer:_voiceUrl result:^(BOOL res) {
            [self handleByResult:res type:type];
        }];
    }
    else if ([type isEqualToString:@"video"]) {
        [self submitAnwserWithQid:_arr[_currentIndex].ID answer:_videoUrl result:^(BOOL res) {
            [self handleByResult:res type:type];
        }];
    }
}

- (void)handleByResult:(BOOL)result type:(NSString *)type {
    if (!result) // 失败
    {
        if (_arr[_currentIndex].second > 0 && ![type isEqualToString:@"video"] && ![type isEqualToString:@"audio"]) { // 有限时
            [self startTimer:[[[NSUserDefaults standardUserDefaults] objectForKey:type] integerValue] type:type];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:type];
        _url = [NSString string];
        _value = [NSString string];
        _voiceUrl = [NSString string];
        _videoUrl = [NSString string];
        
        _currentIndex++;
        if (_currentIndex <= _arr.count-1) {
            [_container removeFromSuperview];
            [self createUI];
        } else {
            [self dismissViewControllerAnimated:true completion:nil];
            !_answerEnd ? : _answerEnd();
        }
        
    }
}

- (void)startTimer:(NSInteger)time type:(NSString *)type {
    __block NSInteger currentTime = time;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
        currentTime++;
        [[NSUserDefaults standardUserDefaults] setObject:@(currentTime) forKey:type];
        if (currentTime >= _arr[_currentIndex].second) {
            // 自动提交
            [self handleClickActionWithType:type];
        }
    }];
}

- (void)dealloc {
    [self clearNotificationAndGesture];
}

#pragma mark - 返回
- (void)back {
//    [self dismissViewControllerAnimated:true completion:nil];
    !_backEvent ? : _backEvent();
}

@end
