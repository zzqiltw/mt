//
//  ZQWordCutTool.h
//  MT
//
//  Created by zzqiltw on 15/5/28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface ZQWordCutTool : NSObject
SingletonH(WordCutTool)

- (void)cutCNWord:(NSString *)cnWord success:(void(^)(NSArray *result))success failure:(void(^)(NSError *error))failure;
@end
