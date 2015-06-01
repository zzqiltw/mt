//
//  ZQTranslateModel.h
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TextFont [UIFont systemFontOfSize:16]

typedef enum{
    TranslateResultSupporterBaidu,
    TranslateResultSupporterGoogle,
    TranslateResultSupporterYoudao,
    TranslateResultSupporterBing,
    TranslateResultSupporterNone
} TranslateResultSupporter;

@interface ZQTranslateModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *srcText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) TranslateResultSupporter type;
@property (nonatomic, assign) double bleuScore;

@property (nonatomic, assign) TranslateType CEorEC;

@end
