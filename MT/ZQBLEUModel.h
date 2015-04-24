//
//  ZQBLEUModel.h
//  MT
//
//  Created by zzqiltw on 15/4/23.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQBLEUModel : NSObject

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *baiduTra;
@property (nonatomic, copy) NSString *youdaoTra;
@property (nonatomic, copy) NSString *bingTra;
@property (nonatomic, copy) NSString *googleTra;


@property (nonatomic, assign) BOOL baiduGet;
@property (nonatomic, assign) BOOL googleGet;
@property (nonatomic, assign) BOOL bingGet;
@property (nonatomic, assign) BOOL youdaoGet;

@end
