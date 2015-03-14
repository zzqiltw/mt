//
//  MBProgressHUD+ZQ.h
//  ZQWeibo
//
//  Created by zzqiltw on 15-2-2.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZQ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
@end
