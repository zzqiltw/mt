//
//  ZQTranslateTools.h
//  MT
//
//  Created by zzqiltw on 15-2-28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

/**
 *  翻译业务工具类
 */
#import <Foundation/Foundation.h>
#import "ZQBaiduTranslateResult.h"
#import "ZQYoudaoTranslateResult.h"

@interface ZQTranslateTools : NSObject

/**
 *  百度翻译业务方法
 *
 *  @param srcText 原文
 *  @param type    翻译类型，英汉，汉英，枚举值
 *  @param success 成功时回调方法
 *  @param failure 失败时回调方法
 */
+ (void)baiduTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(ZQBaiduTranslateResult *result))success failure:(void(^)(NSError *error))failure;

/**
 *  有道翻译业务方法
 *
 *  @param srcText <#srcText description#>
 *  @param type    <#type description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)youdaoTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(ZQYoudaoTranslateResult *youdaoResult))success failure:(void(^)(NSError *error))failure;

/**
 *  Google翻译业务方法
 *
 *  @param srcText <#srcText description#>
 *  @param type    <#type description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)googleTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(NSString *googleResult))success failure:(void(^)(NSError *error))failure;


/**
 *  Google翻译业务方法
 *
 *  @param srcText <#srcText description#>
 *  @param type    <#type description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)bingTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(NSString *bingResult))success failure:(void(^)(NSError *error))failure;

@end
