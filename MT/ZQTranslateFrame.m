//
//  ZQTranslateFrame.m
//  MT
//
//  Created by zzqiltw on 14-12-30.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateFrame.h"
#define Margin 10

@implementation ZQTranslateFrame

- (void)setModel:(ZQTranslateModel *)model
{
    _model = model;
    [self countFrameWithModel:model];
}

- (void)countFrameWithModel:(ZQTranslateModel *)model
{
    _iconFrame = CGRectMake(8, 10, 30, 30);
 
    CGSize labelsize = [model.text sizeWithFont:TextFont constrainedToSize:CGSizeMake(218, 200) lineBreakMode:NSLineBreakByWordWrapping];
    _textFrame = CGRectMake(Margin + CGRectGetMaxX(_iconFrame), _iconFrame.origin.y, labelsize.width, labelsize.height);

    _rowHeight = Margin * 1.5 + MAX(labelsize.height, CGRectGetMaxY(_iconFrame));
}

- (instancetype)initWithModel:(ZQTranslateModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

@end
