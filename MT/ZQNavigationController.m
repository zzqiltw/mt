//
//  ZQNavigationController.m
//
//  Created by zzqiltw on 14-12-7.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQNavigationController.h"

@interface ZQNavigationController ()

@end

@implementation ZQNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

+ (void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
//    NSString *navBarBgImgName = nil;
//    if (iOS7) {
//        navBarBgImgName = @"NavBar64";
//        navigationBar.tintColor = [UIColor whiteColor];
//    } else {
//        navBarBgImgName = @"NavBar";
//    }
//    [navigationBar setBackgroundImage:[UIImage imageNamed:navBarBgImgName] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBarTintColor:[UIColor colorWithRed:63/255.0 green:160/255.0 blue:165/255.0 alpha:1.0f]];
    navigationBar.tintColor = [UIColor whiteColor];
    
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
//    if (!iOS7) {
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    
}

@end
