//
//  ZQKeyboardToolView.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQKeyboardToolView.h"

@implementation ZQKeyboardToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQKeyboardToolView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (IBAction)quitKb:(id)sender {
}

- (IBAction)clearAll:(id)sender {
}
@end
