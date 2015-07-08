//
//  ZQYoudaoTranslateResult.h
//  MT
//
//  Created by zzqiltw on 15-3-2.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQYoudaoTranslateResultWebItem.h"

/**
 *  有道翻译结果模型（面向模型开发而不是面向字典开发）
 */
@interface ZQYoudaoTranslateResult : NSObject

@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) NSArray *translation;
@property (nonatomic, strong) NSArray *web;




@end
