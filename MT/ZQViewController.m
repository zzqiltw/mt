//
//  ZQViewController.m
//  MT
//
//  Created by zzqiltw on 14-12-26.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ZQViewController.h"
#import "ZQTranslateViewController.h"
#import "ZQNavigationButton.h"

@interface ZQViewController ()
- (IBAction)cn2En:(ZQNavigationButton *)sender;

- (IBAction)en2Cn:(ZQNavigationButton *)sender;



@end

@implementation ZQViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}


- (IBAction)cn2En:(ZQNavigationButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:TranslateTypeCn2En forKey:TranslateTypeKey];
    [defaults synchronize];
    
    [self pushToTranslateVC];
}

- (IBAction)en2Cn:(ZQNavigationButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:TranslateTypeEn2Cn forKey:TranslateTypeKey];
    [defaults synchronize];
    
    [self pushToTranslateVC];
}

- (void)pushToTranslateVC
{
    ZQTranslateViewController *vc = [[ZQTranslateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
