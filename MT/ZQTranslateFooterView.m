//
//  ZQTranslateFooterView.m
//  MT
//
//  Created by zzqiltw on 15-3-30.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQTranslateFooterView.h"


@implementation ZQTranslateFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *evaluationButton = [[UIButton alloc] init];
        evaluationButton.frame = CGRectMake(5, 5, 310, ZQFooterViewHeight);
        [evaluationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [evaluationButton setTitle:@"分析译文" forState:UIControlStateNormal];
        evaluationButton.titleLabel.font = [UIFont systemFontOfSize:13];
        evaluationButton.backgroundColor = ZQColor(40, 175, 179, 0.7);
        [evaluationButton addTarget:self action:@selector(clickEvaluaBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:evaluationButton];
    }
    return self;
}

- (void)clickEvaluaBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(footerView:didClickButton:)]) {
        [self.delegate footerView:self didClickButton:button];
    }
}

@end
