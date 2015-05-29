//
//  ZQTranslateViewCell.m
//  MT
//
//  Created by zzqiltw on 14-12-28.
//  Copyright (c) 2014年 zzqiltw. All rights reserved.
//

#import "ZQTranslateViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+IW.h"

@interface ZQTranslateViewCell ()

@property (nonatomic, weak) UILabel *srcText;
@property (weak, nonatomic) UILabel *translateText;
@property (weak, nonatomic) UIImageView *icon;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, weak) UIView *sepaView;
@property (nonatomic, weak) UIButton *recordBtn;
@property (nonatomic, strong) AVSpeechSynthesizer *av;

@end

@implementation ZQTranslateViewCell

- (AVSpeechSynthesizer *)av
{
    if (_av == nil) {
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc] init];
        _av = av;
    }
    return _av;
}

- (UIButton *)recordBtn
{
#warning 网络没有连接的时候，hud不能取消。
#warning play.png没整好
    if (_recordBtn == nil) {
        UIImage *recordImg = [UIImage imageNamed:@"play"];
        UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordBtn setImage:recordImg forState:UIControlStateNormal];
        recordBtn.frame = CGRectMake(0, 0, recordImg.size.width * 0.7, recordImg.size.height * 0.7);
        self.accessoryView = recordBtn;
        [recordBtn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn = recordBtn;
    }
    return _recordBtn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *srcTextLabel = [[UILabel alloc] init];
        srcTextLabel.numberOfLines = 0;
        srcTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        srcTextLabel.font = TextFont;
        srcTextLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:srcTextLabel];
        self.srcText = srcTextLabel;
        
        UILabel *translateText = [[UILabel alloc] init];
        translateText.numberOfLines = 0;
        translateText.lineBreakMode = NSLineBreakByWordWrapping;
        translateText.font = TextFont;
        translateText.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.8];
        [self.contentView addSubview:translateText];
        self.translateText = translateText;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [[UIColor colorWithRed:30/255.0 green:164/255.0 blue:160/255.0 alpha:1.0f] CGColor];
        imageView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:imageView];
        self.icon = imageView;
        
        self.accessoryView = self.recordBtn;
        
//        UIView *sepaView = [[UIView alloc] init];
//        sepaView.backgroundColor = [UIColor colorWithRed:30/255.0 green:164/255.0 blue:160/255.0 alpha:0.5f];
//        sepaView.alpha = 0.5f;
//        [self.contentView addSubview:sepaView];
//        self.sepaView = sepaView;
        
        [self setupBg];
    }
    return self;
}

- (UIImageView *)bgView
{
    if (_bgView == nil) {
        UIImage *bgImage = [UIImage resizedImage:@"common_card_middle_background"];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:bgImage];
        imageView.frame = self.frame;
        _bgView = imageView;
    }
    
    return _bgView;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 3;
    frame.origin.y += 3;
    frame.size.width -= 6;
    frame.size.height -= 6;
    [super setFrame:frame];
}
- (void)setupBg
{
    self.backgroundColor = [UIColor clearColor];
    self.bgView = nil;
    [self insertSubview:self.bgView atIndex:0];
}

- (void)setTranslateFrame:(ZQTranslateFrame *)translateFrame
{
    _translateFrame = translateFrame;
    
    self.icon.image = [UIImage imageNamed:translateFrame.model.iconName];
    self.translateText.text = translateFrame.model.text;
    self.srcText.text = translateFrame.model.srcText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.icon.frame = self.translateFrame.iconFrame;
    self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.5f;
    self.translateText.frame = self.translateFrame.textFrame;
    self.srcText.frame = self.translateFrame.srcTextFrame;
//    self.sepaView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    self.bgView.frame = self.translateFrame.bgFrame;
}

- (void)recordBtnClick:(UIButton *)button
{
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:[self.translateFrame.model.text substringFromIndex:0]];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    [self.av speakUtterance:utterance];
}


@end
