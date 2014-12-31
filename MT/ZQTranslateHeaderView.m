
//
//  ZQTranslateHeaderView.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateHeaderView.h"
#import <MBAutoGrowingTextView.h>

@interface ZQTranslateHeaderView () <UITextFieldDelegate, UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *mode;
- (IBAction)clickTranslateBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *textView;


@end

@implementation ZQTranslateHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQTranslateHeaderView" owner:nil options:nil] lastObject];
        self.inputField.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.frame;
}

- (void)setModeType:(NSString *)modeType
{
    _modeType = modeType;
    //    self.mode.text = modeType;
}

- (void)setInputFieldAccessoryView:(UIView *)inputAccessoryView
{
    self.inputField.inputAccessoryView = inputAccessoryView;
}

- (void)quitKb
{
    [self.inputField endEditing:YES];
}

- (void)clearInputField
{
    self.inputField.text = nil;
}

- (IBAction)clickTranslateBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(translateHeaderView:didClickTranslateBtn:)]) {
        [self.delegate translateHeaderView:self didClickTranslateBtn:sender];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputField endEditing:YES];

    });
}



@end
