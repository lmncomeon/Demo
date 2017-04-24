//
//  SDKJWAlertView.h
//  富文本测试
//
//  Created by 梁家文 on 16/3/23.
//  Copyright © 2016年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDKJWAlertView;

@protocol SDKJWAlertViewDelegate <NSObject>

- (void)SDKJWAlertView:(SDKJWAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex clickedButtonAtTitle:(NSString *)buttonTitle; // !< SDKJWAlertViewDelegate

@end


@interface SDKJWAlertView : UIView

@property (nonatomic,copy) dispatch_block_t dismissAlertTapEvent;

@property (nonatomic, assign) id<SDKJWAlertViewDelegate> delegate;

@property (nonatomic,assign)BOOL permanentShow; //永久显示

+ (instancetype)initAlertViewWithMessage:(NSString * )message singleTapEvent:(void(^)(void))event;

//初始化方法
- (instancetype)initSDKJWAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<SDKJWAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
//显示alert
-(void)alertShow;

//设置title颜色
-(void)setTitleLabColor:(UIColor *)color; 
//设置Message颜色
-(void)setMessageLabColor:(UIColor *)color;
//设置按钮颜色，传入数组的索引。
-(void)setBtnColor:(UIColor *)color atIndex:(NSInteger)index;
//设置加粗按钮索引
-(void)setBtnBoldFountWithIndex:(NSInteger)index;
//设置按钮文字大小
-(void)setBtnFountWithIndex:(NSInteger)index andFontSize:(NSInteger)size;
//设置自动消失时间，可以创建无按钮alert
-(void)setDelayRemoveTimes:(NSInteger)time;

-(void)addCloseBtn;

@end
