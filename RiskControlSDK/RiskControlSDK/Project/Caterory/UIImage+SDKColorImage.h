//
//  UIImage+SDKColorImage.h
//  coreEnterpriseDW
//
//  Created by 栾美娜 on 16/5/27.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SDKColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)selectAndUniformScaleImageOfImage:(UIImage *)image;

@end
