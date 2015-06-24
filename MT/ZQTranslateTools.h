//
//  ZQTranslateTools.h
//  MT
//
//  Created by zzqiltw on 15-2-28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQBaiduTranslateResult.h"
#import "ZQYoudaoTranslateResult.h"

@interface ZQTranslateTools : NSObject

+ (void)baiduTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(ZQBaiduTranslateResult *result))success failure:(void(^)(NSError *error))failure;

+ (void)youdaoTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(ZQYoudaoTranslateResult *youdaoResult))success failure:(void(^)(NSError *error))failure;

+ (void)googleTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(NSString *googleResult))success failure:(void(^)(NSError *error))failure;

+ (void)bingTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(NSString *bingResult))success failure:(void(^)(NSError *error))failure;

@end
