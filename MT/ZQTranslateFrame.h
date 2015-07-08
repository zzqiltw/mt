//
//  ZQTranslateFrame.h
//  MT
//
//  Created by zzqiltw on 14-12-30.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQTranslateModel.h"

/**
 *  为了防止算两遍的高度，要先计算好frame
 */
@interface ZQTranslateFrame : NSObject

@property (nonatomic, assign, readonly) CGRect iconFrame;
@property (nonatomic, assign, readonly) CGRect srcTextFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat rowHeight;
@property (nonatomic, assign, readonly) CGRect bgFrame;

@property (nonatomic, strong) ZQTranslateModel *model;

- (instancetype)initWithModel:(ZQTranslateModel *)model;

@end
