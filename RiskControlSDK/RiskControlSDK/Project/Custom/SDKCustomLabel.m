//
//  SDKCustomLabel.m
//  富文本测试
//
//  Created by 梁家文 on 16/1/5.
//  Copyright © 2016年 梁家文. All rights reserved.


//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "SDKCustomLabel.h"

@implementation SDKCustomLabel
+(SDKCustomLabel *)setLabelTitle:(NSString *)title setLabelFrame:(CGRect)frame setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font
{
    SDKCustomLabel * label = [[SDKCustomLabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    if (title) {
        label.text = title;
    }
//    else
//    {
//        label.text = @"--";
//    }
    return label;
}
+(SDKCustomLabel *)setLabelTitle:(NSString *)title setLabelSize:(CGSize)size setLabelFrameX:(CGFloat)frameOriginX setLabelFrameY:(CGFloat)frameOriginY setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font{
    SDKCustomLabel * label = [SDKCustomLabel new];
    label.font = font;
    label.text = title;
    label.textColor = color;
    label.numberOfLines = 0;
    CGSize labelSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    CGFloat x = frameOriginX;
    CGFloat y = frameOriginY;
    label.frame = (CGRect){{x,y},labelSize};
    return label;
}

+(SDKCustomLabel *)setLabelTitle:(NSString *)title setLabelFrame:(CGRect)frame setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font setAlignment:(NSTextAlignment)alignment{
    SDKCustomLabel * label = [[SDKCustomLabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    if (title) {
        label.text = title;
    }
//    else
//    {
//        label.text = @"--";
//    }
    return label;
}

- (void)setNumberAnimationForValueContent:(double)value
{
    CGFloat lastValue = [self.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) return;
    
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : self,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabelUp:) userInfo:userInfo repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }else if (delta < 0){
        self.text = [NSString stringWithFormat:@"%.2f", value];
    }
}

- (void)setupLabelUp:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.2f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    flag++;
}

- (void)setSingleTapEvent:(void(^)(void))event{
    self.userInteractionEnabled = true;
    if (event) {
        self.customLabTapEvent = event;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labSingleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)labSingleTapAction:(UITapGestureRecognizer *)tap{
    !self.customLabTapEvent ? nil:self.customLabTapEvent();
}

- (void)setText:(NSString *)text
{
    if (!text) {
        [super setText:text];
    }else{
        if (([text rangeOfString:@"<"].location != NSNotFound)||([text rangeOfString:@"["].location != NSNotFound)) {
            if (!_labelAnotherFont) {
                _labelAnotherFont = [UIFont systemFontOfSize:25];
            }
            if (!_labelAnotherColor) {
                _labelAnotherColor = [UIColor redColor];
            }
            NSMutableAttributedString *AttributedStr;
            NSRange range1;
            NSRange range2;
            NSUInteger location =0;
            NSUInteger length = 0;
            NSMutableArray *rangeColorArray = [NSMutableArray array];
            NSMutableArray *rangeBoldArray = [NSMutableArray array];
            NSMutableString *mstr = [NSMutableString string];
            NSMutableString *mstr2 = [NSMutableString string];
            [mstr appendString:text];
            [mstr2 appendString:text];
            
            [mstr replaceOccurrencesOfString:@"[" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr.length)];
            [mstr replaceOccurrencesOfString:@"]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr.length)];
            [mstr2 replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            [mstr2 replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            
            range1.location = 0;
            while (range1.location != NSNotFound) {
                range1 = [mstr rangeOfString:@"<"];
                range2 = [mstr rangeOfString:@">"];
                
                if (range1.location != NSNotFound) {
                    location = range1.location;
                    length = range2.location - range1.location-1;
                    if (length > 5000)break;
                    
                    [mstr replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range1.location + range1.length)];
                    [mstr replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range2.location + range2.length - 1)];
                }
                
                NSDictionary *dict = @{@"location":@(location),@"length":@(length)};
                [rangeColorArray addObject:dict];
            }
            
            range1.location = 0;
            length = 0;
            location = 0;
            while (range1.location != NSNotFound) {
                range1 = [mstr2 rangeOfString:@"["];
                range2 = [mstr2 rangeOfString:@"]"];
                
                if (range1.location != NSNotFound) {
                    location = range1.location;
                    length = range2.location - range1.location-1;
                    if (length > 5000)break;
                    
                    [mstr2 replaceOccurrencesOfString:@"[" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range1.location + range1.length)];
                    [mstr2 replaceOccurrencesOfString:@"]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range2.location + range2.length - 1)];
                }
                
                NSDictionary *dict = @{@"location":@(location),@"length":@(length)};
                [rangeBoldArray addObject:dict];
            }
            [mstr2 replaceOccurrencesOfString:@"[" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            [mstr2 replaceOccurrencesOfString:@"]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:mstr];
            for (NSDictionary *dict in rangeColorArray) {
                NSUInteger lo = [dict[@"location"] integerValue];
                NSUInteger le = [dict[@"length"] integerValue];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:_labelAnotherColor
                                      range:NSMakeRange(lo, le)];
            }
            
            for (NSDictionary *dict in rangeBoldArray) {
                NSUInteger lo = [dict[@"location"] integerValue];
                NSUInteger le = [dict[@"length"] integerValue];
                [AttributedStr addAttribute:NSFontAttributeName
                                      value:_labelAnotherFont
                                      range:NSMakeRange(lo, le)];
            }
            [self setAttributedText:AttributedStr];
        }else{
            [super setText:text];
        }
        
    }
}

+ (SDKCustomLabel *)addLineLabel:(CGRect)frame{
    
    SDKCustomLabel * linelab = [[SDKCustomLabel alloc] initWithFrame:frame];
    
    linelab.backgroundColor = UIColorFromRGB(0xe8e8e8);
    
    return linelab;
}


@end
