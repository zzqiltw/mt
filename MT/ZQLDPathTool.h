//
//  ZQLDPathTool.h
//  MT
//
//  Created by zzqiltw on 15/5/28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ZQLDPathTool : NSObject

SingletonH(LDPathTool)

- (NSString *)combineOfFourSentences:(NSArray *)sl1 second:(NSArray *)sl2 third:(NSArray *)sl3 four:(NSArray *)sl4 type:(TranslateType)type;
@end
