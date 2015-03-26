//
//  ZQTranslateTools.m
//  MT
//
//  Created by zzqiltw on 15-2-28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQTranslateTools.h"
#import <AFNetworking/AFNetworking.h>

#define TimeOutInterval 10.0f
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
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
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

+ (void)youdaoTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void (^)(ZQYoudaoTranslateResult *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *encodedText = [srcText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:
                           @"http://fanyi.youdao.com/openapi.do?keyfrom=testtestest&key=815265506&type=data&doctype=json&version=1.1&q=%@", encodedText];
    manager.requestSerializer.timeoutInterval = TimeOutInterval;
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ZQYoudaoTranslateResult *result = [ZQYoudaoTranslateResult objectWithKeyValues:responseObject];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  Google翻译方法1，直接访问
 *
 *  @return <#return value description#>
 */
+ (void)googleTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    NSString *urlString = @"http://translate.google.cn/translate_a/t";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"client"] = @"t";
    params[@"hl"] = @"zh-CN";
    params[@"text"] = srcText;
    if (type == TranslateTypeCn2En) {
        params[@"sl"] = @"zh-CN";
        params[@"tl"] = @"en";
    } else if (type == TranslateTypeEn2Cn) {
        params[@"sl"] = @"en";
        params[@"tl"] = @"zh-CN";
    }
    params[@"ie"] = @"UTF-8";
    params[@"oe"] = @"UTF-8";
    
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultSet = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSRange range = [resultSet rangeOfString:@"\","];
        NSString *result = [resultSet substringWithRange:NSMakeRange(4, range.location - 4)];
        
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"google error%@", error.localizedDescription);
    }];
}

/**
 *  Google翻译方法2，中转服务
 *
 *  @param srcText <#srcText description#>
 *  @param type    <#type description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
//+ (void)googleTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *urlString = @"http://brisk.eu.org/api/translate.php";
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    if (type == TranslateTypeCn2En) {
//        params[@"from"] = @"zh-CN";
//        params[@"to"] = @"en";
//    } else if (type == TranslateTypeEn2Cn) {
//        params[@"from"] = @"en";
//        params[@"to"] = @"zh-CN";
//    }
//    params[@"text"] = srcText;
//    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *resultSetOri = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSString *resultSet = [NSString replaceUnicode:resultSetOri];
//        NSUInteger location = [resultSet rangeOfString:@"res"].location + 6;
//        NSUInteger length = [resultSet rangeOfString:@"}"].location - location - 1;
//        NSRange range = NSMakeRange(location, length);
//        NSString *resultString = [resultSet substringWithRange:range];
//        if (success) {
//            success(resultString);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"google error%@", error.localizedDescription);
//    }];
//}

+ (void)bingTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = @"http://api.microsofttranslator.com/v2/Http.svc/Translate";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"appId"] = @"TOZ5h9QsS_TW5cHMpjTo4F4YNOprcv8_gk4nTj_Mz8ergin9dj4_J6M43KBb_aZ7D";
    params[@"text"] = srcText;
    if (type == TranslateTypeCn2En) {
        params[@"from"] = @"zh-CN";
        params[@"to"] = @"en";
    } else if (type == TranslateTypeEn2Cn) {
        params[@"from"] = @"en";
        params[@"to"] = @"zh-CN";
    }
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultSet = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSRange range = [resultSet rangeOfString:@"/\">"];
        NSUInteger location = range.location + 3;
        NSUInteger length = [resultSet rangeOfString:@"</string>"].location - location;
        NSString *result = [resultSet substringWithRange:NSMakeRange(location, length)];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"bing error%@", error.localizedDescription);
    }];
}

+ (void)icibaTranslate:(NSString *)srcText ofType:(TranslateType)type
{
    NSString *encodedText = [srcText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://dict-co.iciba.com/api/dictionary.php?w=%@&key=B642361EC9E04B97EF436ED054A7C24A", encodedText];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@,%@", [responseObject class], [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
