//
//  ZQTranslateTools.m
//  MT
//
//  Created by zzqiltw on 15-2-28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQTranslateTools.h"
#import <AFNetworking/AFNetworking.h>
@implementation ZQTranslateTools

+ (void)baiduTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void (^)(ZQBaiduTranslateResult *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"from"] = @"auto";
    params[@"to"] = @"auto";
//    if (type == TranslateTypeCn2En) {
//        params[@"from"] = @"zh";
//        params[@"to"] = @"en";
//    } else {
//        params[@"from"] = @"en";
//        params[@"to"] = @"zh";
//    }
    params[@"client_id"] = BaiduAPIKey;
    params[@"q"] = srcText;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:BaiduURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ZQBaiduTranslateResult *result = [ZQBaiduTranslateResult objectWithKeyValues:responseObject];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)youdaoTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *encodedText = [srcText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:
                           @"http://fanyi.youdao.com/openapi.do?keyfrom=testtestest&key=815265506&type=data&doctype=json&version=1.1&q=%@", encodedText];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject[@"translation"][0]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)icibaTranslate:(NSString *)srcText ofType:(TranslateType)type
{
    NSString *encodedText = [srcText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://dict-co.iciba.com/api/dictionary.php?w=%@&key=B642361EC9E04B97EF436ED054A7C24A", encodedText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@,%@", [responseObject class], [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
