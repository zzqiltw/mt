//
//  ZQNavigationButton.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQNavigationButton.h"
#import <pop/POP.h>

@implementation ZQNavigationButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextFillEllipseInRect(context, self.bounds);
}

- (void)setHighlighted:(BOOL)highlighted
{
    BOOL animated = self.highlighted != highlighted;
    [super setHighlighted:highlighted];
    if (animated) {
        if (highlighted) {
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.duration = 0.1;
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
            [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        } else {
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
            scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
            scaleAnimation.springBounciness = 25;
            [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        }
    }
}


@end
