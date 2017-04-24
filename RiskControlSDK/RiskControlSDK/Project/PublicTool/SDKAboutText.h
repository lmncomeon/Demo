//
//  SDKAboutText.h
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/17.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDKAboutText : NSObject

+ (CGFloat)calculateTextHeight:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font;

+ (CGFloat)calcaulateTextWidth:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

//计算宽度高度
+ (CGSize)sizeWithString:(NSString *)string maxWidth:(CGFloat)maxWidth font:(UIFont *)font;

//
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

@end
