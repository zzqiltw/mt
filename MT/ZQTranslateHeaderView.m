
//
//  ZQTranslateHeaderView.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateHeaderView.h"
#import "ZQKeyboardToolView.h"
@interface ZQTranslateHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *mode;
- (IBAction)clickTranslateBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation ZQTranslateHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQTranslateHeaderView" owner:nil options:nil] lastObject];
        self.inputField.inputAccessoryView = [[ZQKeyboardToolView alloc] init];
    }
    return self;
}

- (void)setModeType:(NSString *)modeType
{
    _modeType = modeType;
    self.mode.text = modeType;
}

- (IBAction)clickTranslateBtn:(id)sender {
}
@end
