
//
//  ZQTranslateHeaderView.m
//  MT
//
//  Created by zzqiltw on 14-12-27.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateHeaderView.h"
#import <MBAutoGrowingTextView.h>

static NSString * const PlaceHolderCN = @"请输入要翻译的内容";
static NSString * const PlaceHolderEN = @"Please input the content to be translated";

@interface ZQTranslateHeaderView () <UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *mode;
- (IBAction)clickTranslateBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *textView;

@property (nonatomic, weak) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *inputText;

@property (nonatomic, copy) NSString *showingPlaceHold;

@end

@implementation ZQTranslateHeaderView

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.font = [UIFont systemFontOfSize:13];
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel = placeHolderLabel;
        _placeHolderLabel.hidden = NO;
        [self.textView addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZQTranslateHeaderView" owner:nil options:nil] lastObject];
        self.textView.textColor = [UIColor blackColor];
//        self.textView.text = PlaceHolder;
        self.textView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.frame;
    self.placeHolderLabel.frame = CGRectInset(self.textView.bounds, 5, 2);
}

- (void)setTextForInput:(NSString *)text
{
    self.textView.text = text;
}

- (void)letInputTextViewBecomeFirstResponder
{
    [self.textView becomeFirstResponder];
}

- (void)setModeType:(TranslateType)modeType
{
    _modeType = modeType;
    
    if (modeType == TranslateTypeEn2Cn) {
        self.placeHolderLabel.text = PlaceHolderEN;
    } else {
        self.placeHolderLabel.text = PlaceHolderCN;
    }
}

- (void)setInputFieldAccessoryView:(UIView *)inputAccessoryView
{
    self.textView.inputAccessoryView = inputAccessoryView;
}

- (void)quitKb
{
    [self.textView endEditing:YES];
    [self.textView resignFirstResponder];
//    self.textView.text = PlaceHolder;
}

- (void)clearInputField
{
    self.textView.text = @"";
    self.placeHolderLabel.hidden = NO;
}

- (IBAction)clickTranslateBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(translateHeaderView:didClickTranslateBtn: withInput:)]) {
        self.inputText = self.textView.text;
        [self.delegate translateHeaderView:self didClickTranslateBtn:sender withInput:self.textView.text];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView endEditing:YES];
    });
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    if (self.inputText == nil) {
//        textView.text = @"";
//    } else {
//        self.inputText = nil;
//    }
    self.placeHolderLabel.hidden = YES;
}

@end
