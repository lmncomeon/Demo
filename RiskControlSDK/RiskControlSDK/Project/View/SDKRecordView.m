//
//  SDKRecordView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/23.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKRecordView.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKCustomLabel.h"
#import "SDKAboutText.h"
#import "SDKJYZRecorder.h"
#import "SDKJWAlertView.h"
#import "SDKCustomRoundedButton.h"

#import <AVFoundation/AVFoundation.h>

@interface SDKRecordView ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) SDKCustomLabel *timeLab;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) SDKCustomRoundedButton *submitBtn;

////播放器
//@property(strong, nonatomic)AVPlayer * player;
//@property(strong, nonatomic)AVPlayerItem * palyItem;


@property(strong, nonatomic)SDKJYZRecorder * recorderJIa;

@end

@implementation SDKRecordView

- (SDKJYZRecorder *)recorderJIa {
    if (!_recorderJIa) {
        _recorderJIa = [SDKJYZRecorder initRecorder];
        _recorderJIa.recordName = @"record.aac";
        _recorderJIa.recordMaxTime = 30;
    }
    return _recorderJIa;
}

- (SDKCustomRoundedButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [SDKCustomRoundedButton roundedBtnWithTitle:@"提交语音" font:kFont(14) titleColor:commonWhiteColor normalBackgroundColor:kBtnNormalBlue highBackgroundColor:kBtnHighlightBlue];
        _submitBtn.frame = CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(35));
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitBtn];
    }
    return _submitBtn;
}

- (instancetype)initWithFrame:(CGRect)frame tipText:(NSString *)tipText
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        _flag = 0;
        
        CGFloat selfW = frame.size.width;
        
        CGFloat iconWH = adaptX(37);
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((selfW-iconWH)*0.5, 0, iconWH, iconWH)];
        iconView.image = [UIImage imageNamed:kImageBundle @"voice_logo"];
        [self addSubview:iconView];
        
        NSString *text = @"请录制一段语音！\n按照屏幕提示读出文字";
        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:text setLabelFrame:CGRectMake(kDefaultPadding, CGRectGetMaxY(iconView.frame), selfW-2*kDefaultPadding, adaptY(40)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
        lab.numberOfLines = 0;
        [self addSubview:lab];
        
        
        NSString *tipStr = [NSString stringWithFormat:@"\"%@\"", tipText];
        CGFloat caseLabH = [SDKAboutText calculateTextHeight:tipStr maxWidth:selfW-2*kDefaultPadding font:kFont(16)];
        SDKCustomLabel *caseLab = [SDKCustomLabel setLabelTitle:tipStr setLabelFrame:CGRectMake(kDefaultPadding, CGRectGetMaxY(lab.frame) + adaptY(10), selfW-2*kDefaultPadding, caseLabH) setLabelColor:kBtnNormalBlue setLabelFont:kFont(16) setAlignment:1];
        caseLab.numberOfLines = 0;
        [self addSubview:caseLab];
        
        
        // btn
        CGFloat btnWH = adaptX(79);
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake((selfW-btnWH)*0.5, CGRectGetMaxY(caseLab.frame)+adaptY(10), btnWH, btnWH);
        [_btn setImage:[UIImage imageNamed:kImageBundle @"record_default"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        // 时间
        _timeLab = [SDKCustomLabel setLabelTitle:@"00 : 00" setLabelFrame:CGRectMake(kDefaultPadding, CGRectGetMaxY(_btn.frame)+adaptY(10), selfW-2*kDefaultPadding, adaptY(40)) setLabelColor:kBtnNormalBlue setLabelFont:kFont(16) setAlignment:1];
        [self addSubview:_timeLab];
        
        if (_maxRecordTime) {
            self.recorderJIa.recordMaxTime = _maxRecordTime;
        }
        self.recorderJIa.sendTime = ^ (NSInteger time) {
            NSString *lastStr = [NSString stringWithFormat:@"%ld", time];
            if (time < 10) {
                lastStr = [NSString stringWithFormat:@"0%ld", time];
            }
            
            _timeLab.text = [NSString stringWithFormat:@"00 : %@", lastStr];
        };
        
        // 提交
        self.submitBtn.y = CGRectGetMaxY(_timeLab.frame) + 	adaptY(30);
        
        self.recorderJIa.endRecord = ^ () {
            // 结束录音
            [self.recorderJIa stopRecorder];
            [self submitAction];
            _flag = 3;
            
        };
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
        

    }
    return self;
}

- (void)btnAction {
    // 麦克风权限
    [self checkMicrophoneAuthorityWithResult:^{
        if (_flag == 0) {
            // 开始录音
            [_btn setImage:[UIImage imageNamed:kImageBundle @"record_change"] forState:UIControlStateNormal];
            [self.recorderJIa startRecorder];
            _flag = 1;
            
        }
        else if (_flag == 1) {
            // 暂停
            [self.recorderJIa pauseRecorder];
            
            [_btn setImage:[UIImage imageNamed:kImageBundle @"record_default"] forState:UIControlStateNormal];
            _flag = 2;
        }
        else if (_flag == 2) {
            // 继续
            _flag = 1;
            [self.recorderJIa pauseToStartRecorder];
            
            [_btn setImage:[UIImage imageNamed:kImageBundle @"record_change"] forState:UIControlStateNormal];
            
        }
    }];

}

- (void)submitAction {
    [self.recorderJIa stopRecorder];
    [_btn setImage:[UIImage imageNamed:kImageBundle @"record_default"] forState:UIControlStateNormal];
    
    _flag = 3;
    
    NSURL * audioUrl  = [NSURL fileURLWithPath:[RecordFile stringByAppendingString:@"record.aac"]];
    
    
    NSData *audioData = [NSData dataWithContentsOfURL:audioUrl];
    
    !_uplodFile ? : _uplodFile(audioData);

//    _palyItem = [[AVPlayerItem alloc]initWithURL:audioUrl];
//    _player = [[AVPlayer alloc]initWithPlayerItem:_palyItem];
//    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//    
//    [self.layer addSublayer:playerLayer];
//    [_player play];
}

- (void)deleteOldVoice {
    [self.recorderJIa deleteRecord];
}

// 判断权限
- (void)checkMicrophoneAuthorityWithResult:(void(^)())result {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)])
    {
        
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                if (result) {
                    result();
                }
            }
            else
            {
                
                [[[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:@"麦克风不可用" message:@"请到设置>隐私>麦克风打开本应用的权限设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@[@"确定"]] alertShow];
            }
        }];
    }
}

@end
