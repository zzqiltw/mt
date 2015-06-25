//
//  ZQHTTPTools.m
//  MT
//
//  Created by zzqiltw on 15/6/24.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQHTTPTools.h"
#import <AFNetworking.h>
#import "MBProgressHUD+ZQ.h"
@implementation ZQHTTPTools
SingletonM(HTTPTools)

+ (void)showError
{
//    [MBProgressHUD showError:@"加载失败,请检查网络"];
}

+ (void)httpJsonGet:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)httpJsonPost:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)httpPlainGet:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSData *responseObject))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)httpPlainPost:(NSString *)urlString params:(NSDictionary *)params success:(void (^)(NSData *responseObject))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError];
        if (failure) {
            failure(error);
        }
    }];
}

@end
