//
//  ZQYoudaoTranslateResult.m
//  MT
//
//  Created by zzqiltw on 15-3-2.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQYoudaoTranslateResult.h"

@implementation ZQYoudaoTranslateResult

- (NSDictionary *)objectClassInArray
{
    return @{@"web":[ZQYoudaoTranslateResultWebItem class]};
}

@end
