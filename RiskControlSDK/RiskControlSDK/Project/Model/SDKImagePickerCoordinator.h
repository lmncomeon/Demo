//
//  SDKImagePickerCoordinator.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/21.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SDKBaseViewController;

@interface SDKImagePickerCoordinator : NSObject

- (BOOL)isVideoRecordingAvailable;
- (BOOL)isAlbumAvailable; // 相册授权
- (void)showInnerViewcontroller:(SDKBaseViewController *)innerVC text:(NSString *)text;

@property (nonatomic, copy) void(^sendData)(NSData *mp4, NSString* name);

@property (nonatomic, copy) void (^sendURL)(NSURL *url);

@end
