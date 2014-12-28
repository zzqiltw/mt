//
//  ActionButton.m
//  Baobaotuan
//
//  Created by Qusic on 8/15/14.
//  Copyright (c) 2014 Baobaotuan. All rights reserved.
//

#import "ActionButton.h"
#import <POP/POP.h>

@implementation ActionButton

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = CGRectInset(self.bounds, 1, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0 alpha:0.4].CGColor);
    CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:bounds.size.height / 2.0].CGPath;
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
}

- (void)setHighlighted:(BOOL)highlighted
{
    BOOL animated = self.highlighted != highlighted;
    [super setHighlighted:highlighted];
    if (animated) {
        if (highlighted) {
            POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.duration = 0.2;
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

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.alpha = enabled ? 1.0 : 0.6;
}

@end
