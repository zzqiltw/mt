//
//  ZQWordCutTool.h
//  MT
//
//  Created by zzqiltw on 15/5/28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//


/**
 *  中文分词工具类
 */
#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface ZQWordCutTool : NSObject
SingletonH(WordCutTool)

/**
 *  分词
 *
 *  @param cnWord  <#cnWord description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
- (void)cutCNWord:(NSString *)cnWord success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
@end
