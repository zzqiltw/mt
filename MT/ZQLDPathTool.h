//
//  ZQLDPathTool.h
//  MT
//
//  Created by zzqiltw on 15/5/28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//


/**
 *  系统融合工具类
 */

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ZQLDPathTool : NSObject

SingletonH(LDPathTool)

/**
 *  系统融合
 *
 *  @param sl1  <#sl1 description#>
 *  @param sl2  <#sl2 description#>
 *  @param sl3  <#sl3 description#>
 *  @param sl4  <#sl4 description#>
 *  @param type 翻译类型（来确定要不要分词）
 *
 *  @return <#return value description#>
 */
- (NSString *)combineOfFourSentences:(NSArray *)sl1 second:(NSArray *)sl2 third:(NSArray *)sl3 four:(NSArray *)sl4 type:(TranslateType)type;
@end
