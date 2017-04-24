//
//  UIView+SDKCustomView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/16.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "UIView+SDKCustomView.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic,   copy) dispatch_block_t singleTapEvent;

@end

@implementation UIView (SDKCustomView)

-(void)setSingleTapEvent:(dispatch_block_t)singleTapEvent{
    objc_setAssociatedObject(self, @selector(singleTapEvent), singleTapEvent, OBJC_ASSOCIATION_COPY);
}

-(dispatch_block_t)singleTapEvent{
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


- (void)addSingleTapEvent:(void(^)())event{
    
    self.userInteractionEnabled = true;
    
    if (event) {
        self.singleTapEvent = event;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    
    tap.numberOfTapsRequired = 1;
    
    tap.numberOfTouchesRequired = 1;
    
    [self addGestureRecognizer:tap];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap{
    
    !self.singleTapEvent ? nil:self.singleTapEvent();
    
}




@end
