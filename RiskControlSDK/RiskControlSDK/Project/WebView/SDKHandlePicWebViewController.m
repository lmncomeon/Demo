//
//  SDKHandlePicWebViewController.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/3/24.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKHandlePicWebViewController.h"

@interface SDKHandlePicWebViewController ()

@property (nonatomic, strong) SDKJWAlertView *photoAlert;
@property (nonatomic, strong) SDKJWAlertView *alert;
@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation SDKHandlePicWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    NSString *url = request.URL.absoluteString;
    
    // 是图片
    if ([url hasSuffix:@".jpg"] || [url hasSuffix:@".png"]) {
        [self showImageOptionsWithUrl:url];
        
        return false;
    }
    
    return true;
}

- (void)showImageOptionsWithUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    _alert = [[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:nil message:@"保存" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@[@"否"]];
    
    [_alert alertShow];
}

- (void)SDKJWAlertView:(SDKJWAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex clickedButtonAtTitle:(NSString *)buttonTitle {
    if (alertView == _alert) {
        if (buttonIndex == 0) {
            if (![self isAlbumAvailable]) {
                _photoAlert  = [[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:@"温馨提示" message:@"当前相册不可使用,请在系统设置中打开相册权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [_photoAlert alertShow];
            } else {
                [self saveImageToDiskWithUrl:_imageUrl];
            }
            
        }
    }
    else if (alertView == _photoAlert) {
        
    }
    
}

- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        showTip(@"保存失败");
        
    }else{
        showTip(@"保存成功");
    }
}




@end
