//
//  ZQBLEUTool.h
//  BLEUTest
//
//  Created by zzqiltw on 15/5/12.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  BLEU工具类
 */
@interface ZQBLEUTool : NSObject

- (double)getBLUEScoreofFirst:(NSString *)first andStrings:(NSArray *)strings Ngram:(NSInteger)n ofType:(TranslateType)type;
@end
