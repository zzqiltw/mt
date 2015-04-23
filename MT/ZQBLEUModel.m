//
//  ZQBLEUModel.m
//  MT
//
//  Created by zzqiltw on 15/4/23.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQBLEUModel.h"
#import "ZQTranslateTools.h"

@implementation ZQBLEUModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"src=%@, baidu=%@, youdao=%@, bing=%@, google=%@", self.src, self.baiduTra, self.youdaoTra, self.bingTra, self.googleTra];
}

@end
