//
//  ZQTranslateTools.h
//  MT
//
//  Created by zzqiltw on 15-2-28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQBaiduTranslateResult.h"

@interface ZQTranslateTools : NSObject

+ (void)baiduTranslate:(NSString *)srcText ofType:(TranslateType)type success:(void(^)(ZQBaiduTranslateResult *result))success failure:(void(^)(NSError *error))failure;

@end
