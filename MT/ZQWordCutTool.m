//
//  ZQWordCutTool.m
//  MT
//
//  Created by zzqiltw on 15/5/28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQWordCutTool.h"
#import "ZQHTTPTools.h"
@implementation ZQWordCutTool
SingletonM(WordCutTool)

- (void)cutCNWord:(NSString *)cnWord success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_key"] = WordCutApiKey;
    params[@"text"] = cnWord;
    params[@"pattern"] = @"ws";
    params[@"format"] = @"plain";
    params[@"has_key"] = @"false";
    
    [ZQHTTPTools httpPlainGet:WordCutURLString params:params success:^(NSData *responseObject) {
        if (success) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSArray *result = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (result.count > 0) {
                success(result);
            } else {
                success(@[str]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
