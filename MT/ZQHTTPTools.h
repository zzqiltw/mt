//
//  ZQHTTPTools.h
//  MT
//
//  Created by zzqiltw on 15/6/24.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

/**
 *  HTTP工具类，目的是解除项目对AFNetworking的耦合
 *
 */
#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface ZQHTTPTools : NSObject
/**
 *  单例宏
 */
SingletonH(HTTPTools)

/**
 *  返回Json格式的Get请求
 *
 *  @param urlString <#urlString description#>
 *  @param params    <#params description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)httpJsonGet:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  返回Json格式的post请求
 *
 *  @param urlString <#urlString description#>
 *  @param params    <#params description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)httpJsonPost:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  返回Plain格式的Get请求，和json区别在于success回调中的responseObject的数据类型（NSData）
 *
 *  @param urlString <#urlString description#>
 *  @param params    <#params description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)httpPlainGet:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSData *responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  返回Plain格式的Post请求
 *
 *  @param urlString <#urlString description#>
 *  @param params    <#params description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)httpPlainPost:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSData *responseObject))success failure:(void (^)(NSError *error))failure;
@end
