//
//  ZQTranslateModel.m
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateModel.h"

@implementation ZQTranslateModel
- (void)setType:(TranslateResultSupporter)type
{
    _type = type;
    switch (type) {
        case TranslateResultSupporterYoudao:
            _iconName = @"youdao";
            break;
        case TranslateResultSupporterBing:
            _iconName = @"biying";
            break;
        case TranslateResultSupporterBaidu:
            _iconName = @"baidu";
            break;
        case TranslateResultSupporterGoogle:
            _iconName = @"google";
            break;
        default:
            break;
    }
}
@end
