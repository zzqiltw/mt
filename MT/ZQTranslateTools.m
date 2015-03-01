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

@end
