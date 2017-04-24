//
//  SDKPhotoView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKPhotoView.h"
#import "UIView+SDKCustomView.h"
#import "SDKProjectHeader.h"
#import "SDKLineView.h"
#import "SDKJWAlertView.h"
#import "UIImage+SDKColorImage.h"
#import "SDKBaseViewController.h"
#import "SDKCommonModel.h"
#import "SDKImageModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "JPSImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

static NSInteger maxNum = 2;

@interface SDKPhotoView ()

@property (nonatomic, strong) NSMutableArray <SDKTakePhotoBtn *> *listArray;

@property (nonatomic, strong) SDKCommonModel *currentModel;
@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation SDKPhotoView
// 多张
- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model superVC:(SDKBaseViewController *)superVC {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        _currentModel = model; // 记录

        NSArray *tmp = [self getListByModel];
        
        NSInteger count = tmp.count;
        int row, col;
        
        CGFloat padding = adaptX(15);
        CGFloat imgW    = (frame.size.width- (maxNum+1)*padding) / maxNum;
        CGFloat imgH    = adaptY(80);
        for (int i = 0; i < count; i++) {
            row = i /maxNum;
            col = i %maxNum;
            SDKTakePhotoBtn *btn = [[SDKTakePhotoBtn alloc] initWithFrame:CGRectMake(padding+ col*(padding+imgW), padding+ row*(padding+imgH), imgW, imgH) superVC:superVC text:tmp[i] backgroundImage:[UIImage imageNamed:kImageBundle @"upload_pic"]];
            [self addSubview:btn];
            [self.listArray addObject:btn];
            
            btn.sendImage = ^ (UIImage *img) {
                !_sendValue ? : _sendValue(img, i);
            };
        }
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame) + padding;
        
        SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, self.height-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [self addSubview:bottomL];
    }
    return self;
}

// 一张
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text superVC:(SDKBaseViewController *)superVC {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat btnW = adaptX(134);
        CGFloat btnH = adaptY(80);
        SDKTakePhotoBtn *btn = [[SDKTakePhotoBtn alloc] initWithFrame:CGRectMake((frame.size.width-btnW)*0.5, 0, btnW, btnH) superVC:superVC text:text backgroundImage:[UIImage imageNamed:kImageBundle @"upload_pic"]];
        btn.sendImage = ^ (UIImage *img) {
            !_sendValue ? : _sendValue(img, 0);
        };
        [self addSubview:btn];
        [self.listArray addObject:btn];
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);
    }
    return self;
}

- (void)showPicWithModel:(SDKCommonModel *)model {

    NSMutableArray *urlArr = [NSMutableArray array];
    [urlArr addObject:model.value1];
    [urlArr addObject:model.value2];
    [urlArr addObject:model.value3];
    
    for (int i = 0; i < self.listArray.count; i++) {
        SDKTakePhotoBtn *btn = self.listArray[i];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:urlArr[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.890 alpha:1.0]]];
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
    
    
    NSString *currentName = @"";
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            currentName = _currentModel.name;
        } else if (i == 1) {
            currentName = _currentModel.name2;
        } else if (i == 2) {
            currentName = _currentModel.name3;
        }
        
        SDKImageModel *imgModel = [SDKImageModel new];
        imgModel.name = currentName;
        imgModel.url = urlArr[i];
        [self.imgArray addObject:imgModel];
    }
    
}

// upload success
- (void)settingImage:(UIImage *)img index:(NSInteger)index url:(NSString *)url {
    
    [self.listArray[index] setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self.listArray[index] setImage:img forState:UIControlStateNormal];
    [self.listArray[index] setTitle:@"" forState:UIControlStateNormal];
 
    
    
    NSString *currentName = @"";
    if (index == 0) {
        currentName = _currentModel.name;
    } else if (index == 1) {
        currentName = _currentModel.name2;
    } else if (index == 2) {
        currentName = _currentModel.name3;
    }
    
    for (SDKImageModel *model in self.imgArray) {
        if (model.name == currentName) {
            [self.imgArray removeObject:model];
            break;
        }
    }
    SDKImageModel *imgModel = [SDKImageModel new];
    imgModel.name = currentName;
    imgModel.url = url;
    [self.imgArray addObject:imgModel];
}

- (NSArray <NSString *> *)getListByModel {
    NSMutableArray *tmp = [NSMutableArray array];
    if (_currentModel.label) {
        [tmp addObject:_currentModel.label];
    }
    if (_currentModel.label2) {
        [tmp addObject:_currentModel.label2];
    }
    if (_currentModel.label3) {
        [tmp addObject:_currentModel.label3];
    }
    return tmp.copy;
}

// 检查数据
- (void)checkDataAndHandle:(void(^)(NSMutableDictionary *dic, BOOL res))handle {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (SDKImageModel *imgModel in self.imgArray) {
        dic[imgModel.name] = imgModel.url;
    }
    
    if (_currentModel.required == false)
    { // 非必填
        if (handle) {
            handle(dic, true);
        }
    }
    else
    { // 必填
        if ([self getListByModel].count > self.imgArray.count) { // 数据填写不全
            if (handle) {
                handle(nil, false);
            }
            
            // 错误色
            for (int i = 0; i < self.listArray.count; i++) {
                SDKTakePhotoBtn *btn = self.listArray[i];
                if (!btn.currentImage) {
                    btn.backgroundColor = kErrorColor;
                } else {
                    btn.backgroundColor = commonWhiteColor;
                }
            }
            
        } else {
            if (handle) {
                handle(dic, true);
            }
        }
    }
    
    
}

#pragma mark - lazy laod
- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSMutableArray <SDKTakePhotoBtn *> *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end



//===============================================================================================//
@interface SDKTakePhotoBtn ()

@property (strong, nonatomic) JPSImagePickerController *imagePickerController;
@property (nonatomic, strong) SDKBaseViewController *superVC;

@end

@implementation SDKTakePhotoBtn

// init camera
- (JPSImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [JPSImagePickerController new];
        _imagePickerController.delegate = self;
        _imagePickerController.flashlightEnabled = NO;
    }
    return _imagePickerController;
}

- (instancetype)initWithFrame:(CGRect)frame superVC:(SDKBaseViewController *)superVC text:(NSString *)text backgroundImage:(UIImage *)backgroundImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        _superVC = superVC;
        
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = 1;
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:commonBlackColor forState:UIControlStateNormal];
        self.titleLabel.font = kFont(14);
        self.titleEdgeInsets = UIEdgeInsetsMake(adaptY(14), 0, -adaptY(14), 0);
        [self addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        
//        SDKCustomLabel *lab = [SDKCustomLabel setLabelTitle:text setLabelFrame:CGRectMake(0, frame.size.height-adaptY(30), frame.size.width, adaptY(20)) setLabelColor:commonBlackColor setLabelFont:kFont(14) setAlignment:1];
//        [self addSubview:lab];
    }
    
    return self;
}

// 拍照
- (void)takePhoto:(UIButton *)sender {
    // jude authorization
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        //        showTipByView(@"当前相机不可使用", self.superVC.view)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SDKJWAlertView * alert  = [[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:@"温馨提示" message:@"当前相机不可使用,请在系统设置中打开相机权限" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert alertShow];
        });
        return;
    }
    
    // show camera
    [_superVC presentViewController:self.imagePickerController animated: YES completion:nil];
}

#pragma mark - camera delegate
- (void)picker:(JPSImagePickerController *)picker didTakePicture:(UIImage *)picture {
    picker.confirmationOverlayBackgroundColor = [UIColor orangeColor];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        picker.confirmationOverlayBackgroundColor = [UIColor colorWithRed:0 green:0.8f blue:0 alpha:1.0f];
    });
}

- (void)picker:(JPSImagePickerController *)picker didConfirmPicture:(UIImage *)picture {
    !_sendImage ? : _sendImage([self selectAndUniformScaleImageOfImage:picture]);
}

- (void)pickerDidCancel:(JPSImagePickerController *)picker {
    self.imagePickerController = nil;
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 压缩图片
//压缩图片
- (UIImage *)selectAndUniformScaleImageOfImage:(UIImage *)image {
    UIImage * newImage = nil;
    CGSize imageSize = image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    CGFloat maxFloat = 1280;
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    if (imageWidth > imageHeight) {
        if (imageWidth > maxFloat) {
            newImageWidth = maxFloat;
            newImageHeight = (maxFloat * imageHeight) / imageWidth;
        }else{
            newImageWidth = imageWidth;
            newImageHeight = imageHeight;
        }
    }else if (imageHeight > imageWidth){
        if (imageHeight > maxFloat) {
            newImageHeight = maxFloat;
            newImageWidth = (maxFloat * imageWidth) / imageHeight;
        }else{
            newImageHeight = imageHeight;
            newImageWidth = imageWidth;
        }
    }else if (imageHeight == imageWidth){
        if (imageWidth > maxFloat) {
            newImageHeight = maxFloat;
            newImageWidth = maxFloat;
        }else{
            newImageHeight = imageHeight;
            newImageWidth = imageWidth;
        }
    }
    CGSize newImageSize = CGSizeMake(newImageWidth, newImageHeight);
    UIGraphicsBeginImageContext(newImageSize);
    [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        DLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

@end
