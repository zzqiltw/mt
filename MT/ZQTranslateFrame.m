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
    _iconFrame = CGRectMake(8, 20, 30, 30);
 
    CGSize srcLabelsize = [model.srcText sizeWithFont:TextFont constrainedToSize:CGSizeMake(200, 200)];
    _srcTextFrame = CGRectMake(Margin + CGRectGetMaxX(_iconFrame), _iconFrame.origin.y - Margin * 0.5, srcLabelsize.width, srcLabelsize.height);
    
    CGSize labelsize = [model.text sizeWithFont:TextFont constrainedToSize:CGSizeMake(200, 200)];
    _textFrame = CGRectMake(Margin + CGRectGetMaxX(_iconFrame), CGRectGetMaxY(_srcTextFrame), labelsize.width, labelsize.height);

    _rowHeight = Margin * 1.5 + MAX(CGRectGetMaxY(_textFrame), CGRectGetMaxY(_iconFrame));
    
    _bgFrame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width - 6, _rowHeight - 3);
}

- (instancetype)initWithModel:(ZQTranslateModel *)model
{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

@end
