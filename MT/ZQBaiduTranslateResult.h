//
//  ZQBaiduTranslateResult.h
//  MT
//
//  Created by zzqiltw on 15-3-1.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQBaiduTranslateResultItem.h"
#import "MJExtension.h"

@interface ZQBaiduTranslateResult : NSObject
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, strong) NSArray *trans_result;


@end
