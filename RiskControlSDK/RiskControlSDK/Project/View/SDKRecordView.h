//
//  SDKRecordView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/23.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKRecordView : UIView

- (instancetype)initWithFrame:(CGRect)frame tipText:(NSString *)tipText;

@property (nonatomic, assign) NSInteger maxRecordTime;

@property (nonatomic, copy) void (^uplodFile)(NSData *audioData);

- (void)deleteOldVoice;

@end
