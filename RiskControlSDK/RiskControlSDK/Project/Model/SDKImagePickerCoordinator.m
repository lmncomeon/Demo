//
//  SDKImagePickerCoordinator.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/21.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKImagePickerCoordinator.h"
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
// other
#import "SDKJWAlertView.h"
#import "SDKBaseViewController.h"
#import "UIView+SDKCustomView.h"
#import "SDKAboutText.h"
#import "SDKProjectHeader.h"

@interface SDKImagePickerCoordinator () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *camera;
@property (nonatomic, strong) SDKCustomLabel *lab;

@end

@implementation SDKImagePickerCoordinator

- (UIImagePickerController *)camera {
    if (!_camera) {
        _camera = [UIImagePickerController new];
        _camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        _camera.mediaTypes = @[(NSString *)kUTTypeMovie];
        _camera.videoQuality=UIImagePickerControllerQualityTypeMedium;
        _camera.cameraDevice = UIImagePickerControllerCameraDeviceFront;//前置摄像头
        _camera.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（录制视频）
        _camera.allowsEditing=YES;//允许编辑
//        _camera.videoMaximumDuration = 3;
        _camera.delegate = self;
    }
    return _camera;
}

- (SDKCustomLabel *)lab {
    if (!_lab) {
        _lab = [SDKCustomLabel setLabelTitle:@"" setLabelFrame:CGRectMake(kDefaultPadding, adaptY(64), kKeyWindow.width-2*kDefaultPadding, 0) setLabelColor:commonBlackColor setLabelFont:kFont(16)];
        _lab.numberOfLines = 0;
        _lab.backgroundColor = commonBlueColor;
    }
    return _lab;
}

// 相机授权
- (BOOL)isVideoRecordingAvailable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
                return false;
            }
            return true;
        }
    }
    return false;
}

// 相册授权
- (BOOL)isAlbumAvailable {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        return false;
    }
    return true;
}

// 显示
- (void)showInnerViewcontroller:(SDKBaseViewController *)innerVC text:(NSString *)text {
    [innerVC presentViewController:self.camera animated:true completion:nil];
    
    // 文本阅读
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lab.text = text;
        self.lab.height = [SDKAboutText sizeWithString:text maxWidth:kKeyWindow.width-2*kDefaultPadding font:kFont(16)].height;
        [kKeyWindow addSubview:self.lab];
    });
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){ // 录制视频
//        [self saveToAlbumWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
        NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
        
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSURL *newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]];

        
        [self.lab removeFromSuperview];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    }

}

- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 [self alertUploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
    
}

- (void)alertUploadVideo:(NSURL *)outputURL {
    NSData *data = [NSData dataWithContentsOfURL:outputURL];
    
    
    DLog(@"%@ \n%@", outputURL, outputURL.absoluteString);
    
    NSRange range = [outputURL.absoluteString rangeOfString:@"output"];
    NSString *name = @"";
    if (range.location != 0) {
        name = [outputURL.absoluteString substringFromIndex:range.location];
    }
    
    !_sendData ? : _sendData(data, name);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.lab removeFromSuperview];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"---%@", editingInfo);
}

#pragma mark - 获取文件大小
//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat)getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

#pragma mark - save
// 保存到相册
- (void)saveToAlbumWithURL:(NSURL *)url {
    NSString *urlStr = [url path];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
        UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
    }
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        
        NSURL *url=[NSURL fileURLWithPath:videoPath];
    }
}

@end
