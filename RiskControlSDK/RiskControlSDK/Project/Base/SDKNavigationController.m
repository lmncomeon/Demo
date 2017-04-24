//
//  SDKNavigationController.m
//  coreEnterpriseDW
//
//  Created by 李贵文 on 16/5/19.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "SDKNavigationController.h"
#import "SDKProjectHeader.h"

@interface SDKNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation SDKNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    //返回箭头的颜色
    self.navigationBar.tintColor = commonBlackColor;
    self.navigationBar.translucent = NO;
    //开启滑动返回
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:commonWhiteColor, NSFontAttributeName:kMediumFont(16.0)};
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1)
    {
        viewController.navigationItem.leftBarButtonItem = [self createBackButton];
    }
}

#pragma mark 重写barbutton
- (UIBarButtonItem *)createBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"RiskControlBundle.bundle/arrow_back_white"]
            forState:UIControlStateNormal];
    button.tintColor = commonBlackColor;
    [button addTarget:self action:@selector(popself)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, (44-adaptX(18))*0.5, adaptX(18), adaptX(18));
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return menuButton;
}


- (void)popself {
    [self popViewControllerAnimated:YES];
}

@end
