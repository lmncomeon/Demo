//
//  SDKVideoView.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/21.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDKBaseViewController;

@interface SDKVideoView : UIView

- (instancetype)initWithFrame:(CGRect)frame innerViewController:(SDKBaseViewController*)innerVC text:(NSString *)text;

@property (nonatomic, copy) void (^useVideoEvent)(NSData*, NSString *);
@property (nonatomic, copy) void (^useVideoURL)(NSURL *);

@end
