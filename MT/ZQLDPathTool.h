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

@property (nonatomic, strong) NSArray *s1;
@property (nonatomic, strong) NSArray *s2;

@property (nonatomic, strong) NSMutableArray *r1;
@property (nonatomic, strong) NSMutableArray *r2;
- (int)ldCalcPath;

@end
