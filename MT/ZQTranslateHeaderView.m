
//
//  ZQTranslateHeaderView.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateHeaderView.h"
#import <MBAutoGrowingTextView.h>
#define PlaceHolder @"请输入要翻译的内容"

@interface ZQTranslateHeaderView () <UITextFieldDelegate, UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *mode;
- (IBAction)clickTranslateBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *textView;


@end

@implementation ZQTranslateHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQTranslateHeaderView" owner:nil options:nil] lastObject];
        self.textView.text = PlaceHolder;
        self.textView.delegate = self;
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
    self.textView.inputAccessoryView = inputAccessoryView;
}

- (void)quitKb
{
    [self.textView endEditing:YES];
}

- (void)clearInputField
{
    self.textView.text = PlaceHolder;
}

- (IBAction)clickTranslateBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(translateHeaderView:didClickTranslateBtn: withInput:)]) {
        [self.delegate translateHeaderView:self didClickTranslateBtn:sender withInput:self.textView.text];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView endEditing:YES];

    });
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

@end
