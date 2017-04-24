//
//  UIImage+ColorImage.m
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/27.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "UIImage+SDKColorImage.h"

@implementation UIImage (SDKColorImage)

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//压缩图片
+ (UIImage *)selectAndUniformScaleImageOfImage:(UIImage *)image {
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
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


@end
