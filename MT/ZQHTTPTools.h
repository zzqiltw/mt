//
//  ZQHTTPTools.h
//  MT
//
//  Created by zzqiltw on 15/6/24.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface ZQHTTPTools : NSObject
SingletonH(HTTPTools)

+ (void)httpJsonGet:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSError *error))failure;

+ (void)httpJsonPost:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)httpPlainGet:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSData *responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)httpPlainPost:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSData *responseObject))success failure:(void (^)(NSError *error))failure;
@end
